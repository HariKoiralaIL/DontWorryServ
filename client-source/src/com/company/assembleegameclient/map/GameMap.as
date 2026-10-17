package com.company.assembleegameclient.map {
import MapBackgrounds.Background;

import arrows.ArrowOverlay;

import audio.MusicManager;

import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.BasicObject;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.NearbyPlayerTracker;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.ConditionEffect;

import flash.display.Graphics;
import flash.display.IGraphicsData;
import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import mapoverlay.MapOverlay;

public class GameMap extends MapHandler {

    private static const SORT_FIELDS:Array = ["sortVal_", "objectId_"];
    private static const SORT_OPTIONS:Array = [Array.NUMERIC, Array.NUMERIC];
    protected static const GREYSCALE_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.05, 0.05, 0.05, 0, 0, 0.05, 0.05, 0.05, 0, 0, 0.05, 0.05, 0.05, 0, 0, 0.05, 0.05, 0.05, 1, 0]);

    protected static var hurtColorTransform_:ColorTransform = new ColorTransform(0xFF / 0xFF, 55 / 0xFF, 0 / 0xFF, 0);

    /** Objects drawn after ground (depth sorted). */
    public var visible_:Array;
    /** Flat objects drawn under everything else (depth sorted). */
    public var visibleUnder_:Array;
    public var visibleSquares_:Vector.<Square>;
    public var topSquares_:Vector.<Square>;
    private var inUpdateLoop_:Boolean = false;
    private var addQueue_:Vector.<BasicObject>;
    private var removeQueue_:Vector.<int>;
    private var graphicsData_:Vector.<IGraphicsData>;

    public function GameMap(gameSprite:GameSprite) {
        super();
        this.addQueue_ = new Vector.<BasicObject>();
        this.removeQueue_ = new Vector.<int>();
        this.graphicsData_ = new Vector.<IGraphicsData>();
        this.visible_ = [];
        this.visibleUnder_ = [];
        this.visibleSquares_ = new Vector.<Square>();
        this.topSquares_ = new Vector.<Square>();
        gs_ = gameSprite;
        hurtOverlay_ = new HurtOverlay();
        gradientOverlay_ = new GradientOverlay();
        mapOverlay_ = new MapOverlay();
        partyOverlay_ = new ArrowOverlay(this);
        party_ = new NearbyPlayerTracker(this);
        quest_ = new Quest(this);
    }

    override public function setProps(width:int, height:int, name:String, backgroundId:int, allowPlayerTeleport:Boolean, showDisplays:Boolean, music:String, weather:int):void {
        width_ = width;
        height_ = height;
        name_ = name;
        backgroundId_ = backgroundId;
        allowPlayerTeleport_ = allowPlayerTeleport;
        showDisplays_ = showDisplays;
        music_ = music;
        weather_ = weather;
        MusicManager.reload(this.music_);
    }

    override public function initialize():void {
        this.squares_.length = this.width_ * this.height_;
        this.background_ = Background._U_q(this.backgroundId_);
        if (this.background_ != null) {
            addChild(this.background_);
        }
        addChild(this.map_);
        this.weatherBackground_ = Background.GetWeatherBackground(this.weather_);
        if (this.weatherBackground_ != null && !Parameters.data_.disableWeather) {
            addChild(this.weatherBackground_);
        }
        addChild(this.hurtOverlay_);
        addChild(this.gradientOverlay_);
        addChild(this.mapOverlay_);
        addChild(this.partyOverlay_);
    }

    override public function dispose():void {
        this.gs_ = null;
        this.background_ = null;
        this.map_ = null;
        this.hurtOverlay_ = null;
        this.gradientOverlay_ = null;
        this.mapOverlay_ = null;
        this.partyOverlay_ = null;
        for each (var square:Square in this.squareList_) {
            square.dispose();
        }
        this.squareList_.length = 0;
        this.squareList_ = null;
        this.squares_.length = 0;
        this.squares_ = null;
        for each (var gameObject:GameObject in this.goDict_) {
            gameObject.dispose();
        }
        this.goDict_ = null;
        for each (var basicObject:BasicObject in this.boDict_) {
            basicObject.dispose();
        }
        this.boDict_ = null;
        this.weatherBackground_ = null;
        this.merchLookup_ = null;
        this.player_ = null;
        this.party_ = null;
        this.quest_ = null;
        this.addQueue_ = null;
        this.removeQueue_ = null;
    }

    override public function update(time:int, dt:int):void {
        var obj:BasicObject;
        this.inUpdateLoop_ = true;
        for each (obj in this.goDict_) {
            if (!obj.update(time, dt)) {
                this.removeQueue_.push(obj.objectId_);
            }
        }
        for each (obj in this.boDict_) {
            if (!obj.update(time, dt)) {
                this.removeQueue_.push(obj.objectId_);
            }
        }
        this.inUpdateLoop_ = false;
        for each (obj in this.addQueue_) {
            this.addObjectNow(obj);
        }
        this.addQueue_.length = 0;
        for each (var objectId:int in this.removeQueue_) {
            this.removeObjectNow(objectId);
        }
        if (this.weatherBackground_ != null) {
            this.weatherBackground_.update();
        }
        this.removeQueue_.length = 0;
        this.party_.update(time, dt);
    }

    override public function pSTopW(screenX:Number, screenY:Number):Point {
        for each (var square:Square in this.visibleSquares_) {
            if (square.faces_.length != 0 && square.faces_[0].face_.contains(screenX, screenY)) {
                return new Point(square.center_.x, square.center_.y);
            }
        }
        return null;
    }

    override public function setGroundTile(x:int, y:int, tileType:uint):void {
        this.getSquare(x, y).setTileType(tileType);
        // Invalidate cached faces of the 3x3 neighbourhood that depend on this tile.
        var minX:int = (x > 0) ? x - 1 : x;
        var maxX:int = (x < this.width_ - 1) ? x + 1 : x;
        var minY:int = (y > 0) ? y - 1 : y;
        var maxY:int = (y < this.height_ - 1) ? y + 1 : y;
        for (var nx:int = minX; nx <= maxX; nx++) {
            for (var ny:int = minY; ny <= maxY; ny++) {
                var neighbour:Square = this.squares_[nx + ny * this.width_];
                if (neighbour != null && (neighbour.props_.hasEdge_ || neighbour.tileType_ != tileType)) {
                    neighbour.faces_.length = 0;
                }
            }
        }
    }

    override public function addObj(obj:BasicObject, x:Number, y:Number):void {
        obj.x_ = x;
        obj.y_ = y;
        if (this.inUpdateLoop_) {
            this.addQueue_.push(obj);
        } else {
            this.addObjectNow(obj);
        }
    }

    override public function removeObj(objectId:int):void {
        if (this.inUpdateLoop_) {
            this.removeQueue_.push(objectId);
        } else {
            this.removeObjectNow(objectId);
        }
    }

    override public function draw(camera:GameCamera, time:int):void {
        var clipRect:Rectangle = camera.clipRect_;
        x = -clipRect.x;
        y = -clipRect.y;
        var offset:Number = (-clipRect.y - clipRect.height / 2) / 50;
        var center:Point = new Point(
                camera.x_ + offset * Math.cos(camera.angleRad_ - Math.PI / 2),
                camera.y_ + offset * Math.sin(camera.angleRad_ - Math.PI / 2));
        if (this.background_ != null) {
            this.background_.draw(camera, time);
        }
        this.visible_.length = 0;
        this.visibleUnder_.length = 0;
        this.visibleSquares_.length = 0;
        this.topSquares_.length = 0;
        this.graphicsData_.length = 0;
        this.collectSquares(camera, time, center);
        this.collectObjects(camera, time);
        this.drawObjects(camera, time);
        this.updateOverlays(clipRect, time);
        var mapGraphics:Graphics = this.map_.graphics;
        mapGraphics.clear();
        mapGraphics.drawGraphicsData(this.graphicsData_);
        this.updateFilters(time);
        if (this.weatherBackground_ != null) {
            this.weatherBackground_.draw(camera, time);
        }
        this.mapOverlay_.draw(camera, time);
        this.partyOverlay_.draw(camera, time);
    }

    public function addObjectNow(obj:BasicObject):void {
        if (!obj.addTo(this, obj.x_, obj.y_)) {
            return;
        }
        var dict:Dictionary = (obj is GameObject) ? this.goDict_ : this.boDict_;
        if (dict[obj.objectId_] != null) {
            return;
        }
        dict[obj.objectId_] = obj;
    }

    public function removeObjectNow(objectId:int):void {
        var dict:Dictionary = this.goDict_;
        var obj:BasicObject = dict[objectId];
        if (obj == null) {
            dict = this.boDict_;
            obj = dict[objectId];
            if (obj == null) {
                return;
            }
        }
        obj.removeFromMap();
        delete dict[objectId];
    }

    /** Returns the square at (x, y), creating it on first access; null if out of bounds. */
    public function getSquare(x:Number, y:Number):Square {
        if (x < 0 || x >= this.width_ || y < 0 || y >= this.height_) {
            return null;
        }
        var index:int = int(x) + int(y) * this.width_;
        var square:Square = this.squares_[index];
        if (square == null) {
            square = new Square(this, int(x), int(y));
            this.squares_[index] = square;
            this.squareList_.push(square);
        }
        return square;
    }

    /** Like getSquare but never creates a square. */
    public function lookupSquare(x:int, y:int):Square {
        if (x < 0 || x >= this.width_ || y < 0 || y >= this.height_) {
            return null;
        }
        return this.squares_[x + y * this.width_];
    }

    private function collectSquares(camera:GameCamera, time:int, center:Point):void {
        var radius:int = camera.maxDist_;
        var minX:int = Math.max(0, center.x - radius);
        var maxX:int = Math.min(this.width_ - 1, center.x + radius);
        var minY:int = Math.max(0, center.y - radius);
        var maxY:int = Math.min(this.height_ - 1, center.y + radius);
        for (var sx:int = minX; sx <= maxX; sx++) {
            for (var sy:int = minY; sy <= maxY; sy++) {
                var square:Square = this.squares_[sx + sy * this.width_];
                if (square == null) {
                    continue;
                }
                var dx:Number = center.x - square.center_.x;
                var dy:Number = center.y - square.center_.y;
                if (dx * dx + dy * dy <= camera.maxDistSq_) {
                    square.lastVisible_ = time;
                    square.draw(this.graphicsData_, camera, time);
                    this.visibleSquares_.push(square);
                    if (square.topFace_ != null) {
                        this.topSquares_.push(square);
                    }
                }
            }
        }
    }

    private function collectObjects(camera:GameCamera, time:int):void {
        var square:Square;
        for each (var gameObject:GameObject in this.goDict_) {
            gameObject.unusedFlag_ = false;
            if (!gameObject.dead_) {
                square = gameObject.square_;
                if (square != null && square.lastVisible_ == time) {
                    gameObject.unusedFlag_ = true;
                    gameObject.computeSortVal(camera);
                    if (gameObject.props_.drawUnder_) {
                        if (gameObject.props_.drawOnGround_) {
                            gameObject.draw(this.graphicsData_, camera, time);
                        } else {
                            this.visibleUnder_.push(gameObject);
                        }
                    } else {
                        this.visible_.push(gameObject);
                    }
                }
            }
        }
        for each (var basicObject:BasicObject in this.boDict_) {
            basicObject.unusedFlag_ = false;
            square = basicObject.square_;
            if (square != null && square.lastVisible_ == time) {
                basicObject.unusedFlag_ = true;
                basicObject.computeSortVal(camera);
                this.visible_.push(basicObject);
            }
        }
    }

    private function drawObjects(camera:GameCamera, time:int):void {
        var obj:BasicObject;
        if (this.visibleUnder_.length > 0) {
            this.visibleUnder_.sortOn(SORT_FIELDS, SORT_OPTIONS);
            for each (obj in this.visibleUnder_) {
                obj.draw(this.graphicsData_, camera, time);
            }
        }
        this.visible_.sortOn(SORT_FIELDS, SORT_OPTIONS);
        if (Parameters.data_.drawShadows) {
            for each (obj in this.visible_) {
                if (obj.hasShadow_) {
                    obj.drawShadow(this.graphicsData_, camera, time);
                }
            }
        }
        for each (obj in this.visible_) {
            obj.draw(this.graphicsData_, camera, time);
        }
        for each (var square:Square in this.topSquares_) {
            square.drawTop(this.graphicsData_, camera, time);
        }
    }

    private function updateOverlays(clipRect:Rectangle, time:int):void {
        if (this.player_ != null && this.player_.breath_ >= 0 && this.player_.breath_ < Parameters._E_S_) {
            var intensity:Number = (Parameters._E_S_ - this.player_.breath_) / Parameters._E_S_;
            var pulse:Number = Math.abs(Math.sin(time / 300)) * 0.75;
            hurtColorTransform_.alphaMultiplier = intensity * pulse;
            this.hurtOverlay_.transform.colorTransform = hurtColorTransform_;
            this.hurtOverlay_.visible = true;
            this.hurtOverlay_.x = clipRect.left;
            this.hurtOverlay_.y = clipRect.top;
        } else {
            this.hurtOverlay_.visible = false;
        }
        if (this.player_ != null && !Parameters._0F_o) {
            this.gradientOverlay_.visible = true;
            this.gradientOverlay_.x = clipRect.right - 10;
            this.gradientOverlay_.y = clipRect.top;
        } else {
            this.gradientOverlay_.visible = false;
        }
    }

    private function updateFilters(time:int):void {
        if (this.player_ != null && (this.player_.condition_ & ConditionEffect.MAP_FILTER_BITMASK) != 0) {
            var filterList:Array = [];
            var blur:Number;
            if (this.player_.isDrunk()) {
                blur = 20 + 10 * Math.sin(time / 1000);
                filterList.push(new BlurFilter(blur, blur));
            }
            if (this.player_.hasConditionN_c()) {
                blur = 20 + 10 * Math.sin(time / 1000);
                filterList.push(new BlurFilter(blur, blur));
            }
            if (this.player_.isBlind()) {
                filterList.push(GREYSCALE_FILTER);
            }
            this.map_.filters = filterList;
        } else if (this.map_.filters.length > 0) {
            this.map_.filters = [];
        }
    }

}
}
