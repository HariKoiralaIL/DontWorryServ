package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.map.GameMap;
import com.company.assembleegameclient.map.GroundLibrary;
import com.company.assembleegameclient.objects.Character;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.GuildHallPortal;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.objects.Portal;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.tooltip.PlayerListToolTip;
import com.company.util.AssetLibrary;
import com.company.util.PointUtil;
import com.company.util.RectUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import menus.PlayerListMenu;

/**
 * The minimap: a pixel image of the whole map, scrolled around the player,
 * with coloured dots for players / enemies / portals, zoom buttons, a hover
 * tooltip listing nearby players and a click menu for them.
 *
 * Formerly: _ej
 */
public class MiniMap extends Sprite {

    /** Squared distance (in pixels) within which a player dot counts as hovered. */
    private static const HOVER_DISTANCE_SQUARED:int = 5 * 5;

    private static var objectColorCache_:Dictionary = new Dictionary();

    /** Minimap colour of a game object, cached per object type. Formerly _fG_. */
    public static function getObjectColor(go:GameObject):uint {
        var type:int = go.objectType_;
        if (!objectColorCache_.hasOwnProperty(String(type))) {
            objectColorCache_[type] = go.getColor();
        }
        return objectColorCache_[type];
    }

    public var map_:GameMap;
    public var w_:int;
    public var h_:int;
    /** Index into zoomLevels_ (0 = most zoomed in); formerly _Q_B_. */
    public var zoomIndex_:Number = 0;
    /** Visible area, centred on the origin (formerly _eh). */
    public var viewRect_:Rectangle;
    /** Size of the map in tiles (formerly _0M_j). */
    public var mapSize_:Point;
    /** One pixel per tile (formerly _02q). */
    public var mapBitmap_:BitmapData;
    /** Available scales in pixels per tile, largest first (formerly _M_R_). */
    public var zoomLevels_:Vector.<Number> = new Vector.<Number>();
    /** Player arrow graphic (formerly _0H_x). */
    public var playerArrow_:BitmapData;
    /** Shape showing the scrolled map image (formerly _else). */
    public var mapShape_:Shape;
    /** Shape showing the object dots and player arrow (formerly _16). */
    public var objectsShape_:Shape;
    /** Button that zooms in to a larger scale, i.e. lower zoomIndex_ (formerly _1_). */
    public var zoomInButton_:Sprite;
    /** Button that zooms out to a smaller scale, i.e. higher zoomIndex_ (formerly _tk). */
    public var zoomOutButton_:Sprite;

    private var mouseOver_:Boolean = false;
    private var toolTip_:PlayerListToolTip = null;
    private var playerMenu_:PlayerListMenu = null;
    private var mapMatrix_:Matrix = new Matrix();
    private var arrowMatrix_:Matrix = new Matrix();
    private var hoveredPlayers_:Vector.<Player> = new Vector.<Player>();
    private var edgePoint_:Point = new Point();

    public function MiniMap(map:GameMap, width:int, height:int) {
        super();
        this.map_ = map;
        this.w_ = width;
        this.h_ = height;
        this.viewRect_ = new Rectangle(-this.w_ / 2, -this.h_ / 2, this.w_, this.h_);
        this.mapSize_ = new Point(map.width_, map.height_);
        this.mapBitmap_ = new BitmapData(this.mapSize_.x, this.mapSize_.y, false, 0);
        var minZoom:Number = Math.max(this.w_ / this.mapSize_.x, this.h_ / this.mapSize_.y);
        var zoom:Number = 4;
        while (zoom > minZoom) {
            this.zoomLevels_.push(zoom);
            zoom = zoom / 2;
        }
        this.zoomLevels_.push(minZoom);
        this.playerArrow_ = AssetLibrary.getImageFromSet("lofiInterface", 54).clone();
        this.playerArrow_.colorTransform(this.playerArrow_.rect, new ColorTransform(0, 0, 1));
        graphics.clear();
        graphics.beginFill(0x1B1B1B);
        graphics.drawRect(0, 0, this.w_, this.h_);
        graphics.endFill();
        this.mapShape_ = new Shape();
        this.mapShape_.x = this.w_ / 2;
        this.mapShape_.y = this.h_ / 2;
        addChild(this.mapShape_);
        this.objectsShape_ = new Shape();
        this.objectsShape_.x = this.w_ / 2;
        this.objectsShape_.y = this.h_ / 2;
        addChild(this.objectsShape_);
        var icon:Bitmap = new Bitmap(AssetLibrary.getImageFromSet("lofiInterface", 54));
        icon.scaleX = 2;
        icon.scaleY = 2;
        this.zoomOutButton_ = new Sprite();
        this.zoomOutButton_.x = this.w_ - 20;
        this.zoomOutButton_.y = 4;
        this.zoomOutButton_.addChild(icon);
        this.zoomOutButton_.addEventListener(MouseEvent.CLICK, this.onZoomOutClick);
        addChild(this.zoomOutButton_);
        icon = new Bitmap(AssetLibrary.getImageFromSet("lofiInterface", 55));
        icon.scaleX = 2;
        icon.scaleY = 2;
        this.zoomInButton_ = new Sprite();
        this.zoomInButton_.x = this.w_ - 20;
        this.zoomInButton_.y = 14;
        this.zoomInButton_.addChild(icon);
        this.zoomInButton_.addEventListener(MouseEvent.CLICK, this.onZoomInClick);
        addChild(this.zoomInButton_);
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        addEventListener(MouseEvent.CLICK, this.onClick);
        this.updateZoomButtons();
    }

    public function dispose():void {
        this.mapBitmap_.dispose();
        this.mapBitmap_ = null;
        this.removePopups();
    }

    /** Shows more of the map (smaller scale). Formerly _w_. */
    public function zoomOut():void {
        if (this.zoomIndex_ < (this.zoomLevels_.length - 1)) {
            this.zoomIndex_++;
        }
        this.updateZoomButtons();
    }

    /** Shows less of the map (larger scale). Formerly _K_r. */
    public function zoomIn():void {
        if (this.zoomIndex_ > 0) {
            this.zoomIndex_--;
        }
        this.updateZoomButtons();
    }

    public function setGroundTile(x:int, y:int, tileType:uint):void {
        var color:uint = GroundLibrary.getColor(tileType);
        this.mapBitmap_.setPixel(x, y, color);
    }

    /** Paints the pixel of a static object on the map image. Formerly _0A_R_. */
    public function setObjectPixel(x:int, y:int, go:GameObject):void {
        var color:uint = getObjectColor(go);
        this.mapBitmap_.setPixel(x, y, color);
    }

    public function draw():void {
        var player:Player = this.map_.player_;
        var scale:Number = this.zoomLevels_[this.zoomIndex_];

        // Position the map so the player is at the centre, but never scroll past its edges.
        this.mapMatrix_.identity();
        this.mapMatrix_.translate(-player.x_, -player.y_);
        this.mapMatrix_.scale(scale, scale);
        var topLeft:Point = this.mapMatrix_.transformPoint(PointUtil.ORIGIN);
        var bottomRight:Point = this.mapMatrix_.transformPoint(this.mapSize_);
        var shiftX:Number = 0;
        if (topLeft.x > this.viewRect_.left) {
            shiftX = this.viewRect_.left - topLeft.x;
        } else if (bottomRight.x < this.viewRect_.right) {
            shiftX = this.viewRect_.right - bottomRight.x;
        }
        var shiftY:Number = 0;
        if (topLeft.y > this.viewRect_.top) {
            shiftY = this.viewRect_.top - topLeft.y;
        } else if (bottomRight.y < this.viewRect_.bottom) {
            shiftY = this.viewRect_.bottom - bottomRight.y;
        }
        this.mapMatrix_.translate(shiftX, shiftY);
        topLeft = this.mapMatrix_.transformPoint(PointUtil.ORIGIN);

        var mapArea:Rectangle = new Rectangle();
        mapArea.x = Math.max(this.viewRect_.x, topLeft.x);
        mapArea.y = Math.max(this.viewRect_.y, topLeft.y);
        mapArea.right = Math.min(this.viewRect_.right, topLeft.x + (this.mapSize_.x * scale));
        mapArea.bottom = Math.min(this.viewRect_.bottom, topLeft.y + (this.mapSize_.y * scale));
        var g:Graphics = this.mapShape_.graphics;
        g.clear();
        g.beginBitmapFill(this.mapBitmap_, this.mapMatrix_, false);
        g.drawRect(mapArea.x, mapArea.y, mapArea.width, mapArea.height);
        g.endFill();

        // Object dots.
        g = this.objectsShape_.graphics;
        g.clear();
        var mouseX_:Number = mouseX - (this.w_ / 2);
        var mouseY_:Number = mouseY - (this.h_ / 2);
        this.hoveredPlayers_.length = 0;
        for each (var go:GameObject in this.map_.goDict_) {
            if (go.props_.noMiniMap_ || go == this.map_.player_) {
                continue;
            }
            var color:uint;
            var otherPlayer:Player = go as Player;
            if (otherPlayer != null) {
                if (this.map_.player_.canBeHitBy(otherPlayer) && otherPlayer.isInvisible()) {
                    continue;
                }
                if (otherPlayer.isPaused()) {
                    color = 0x7F7F7F;
                } else if (otherPlayer.inParty) {
                    color = 0x00FFFF;
                } else if (otherPlayer.isFellowGuild_) {
                    color = 0x00FF00;
                } else {
                    color = 0xFFFF00;
                }
            } else if (go is Character) {
                if (go.props_.isEnemy_) {
                    color = 0xFF0000;
                } else {
                    color = getObjectColor(go);
                }
            } else if (go is Portal || go is GuildHallPortal) {
                color = 0x0000FF;
            } else {
                continue;
            }
            var dotX:Number = (this.mapMatrix_.a * go.x_) + (this.mapMatrix_.c * go.y_) + this.mapMatrix_.tx;
            var dotY:Number = (this.mapMatrix_.b * go.x_) + (this.mapMatrix_.d * go.y_) + this.mapMatrix_.ty;
            if (dotX <= (-this.w_ / 2) || dotX >= (this.w_ / 2) || dotY <= (-this.h_ / 2) || dotY >= (this.h_ / 2)) {
                // Off-screen objects are pinned to the edge of the minimap.
                RectUtil.findEdgeCrossing(this.viewRect_, 0, 0, dotX, dotY, this.edgePoint_);
                dotX = this.edgePoint_.x;
                dotY = this.edgePoint_.y;
            }
            if (otherPlayer != null && this.mouseOver_ && (this.playerMenu_ == null || this.playerMenu_.parent == null)) {
                var dx:Number = mouseX_ - dotX;
                var dy:Number = mouseY_ - dotY;
                if (((dx * dx) + (dy * dy)) < HOVER_DISTANCE_SQUARED) {
                    this.hoveredPlayers_.push(otherPlayer);
                }
            }
            g.beginFill(color);
            g.drawRect(dotX - 2, dotY - 2, 4, 4);
            g.endFill();
        }

        // Tooltip for the hovered players.
        if (this.hoveredPlayers_.length != 0) {
            if (this.toolTip_ == null) {
                this.toolTip_ = new PlayerListToolTip(this.hoveredPlayers_);
                stage.addChild(this.toolTip_);
            } else if (!this.samePlayers(this.toolTip_.players_, this.hoveredPlayers_)) {
                this.toolTip_.setPlayers(this.hoveredPlayers_);
            }
        } else if (this.toolTip_ != null) {
            if (this.toolTip_.parent != null) {
                this.toolTip_.parent.removeChild(this.toolTip_);
            }
            this.toolTip_ = null;
        }

        // Player arrow, rotated with the camera.
        var playerX:Number = (this.mapMatrix_.a * player.x_) + (this.mapMatrix_.c * player.y_) + this.mapMatrix_.tx;
        var playerY:Number = (this.mapMatrix_.b * player.x_) + (this.mapMatrix_.d * player.y_) + this.mapMatrix_.ty;
        this.arrowMatrix_.identity();
        this.arrowMatrix_.translate(-4, -5);
        this.arrowMatrix_.scale(8 / this.playerArrow_.width, 32 / this.playerArrow_.height);
        this.arrowMatrix_.rotate(Parameters.data_.cameraAngle);
        this.arrowMatrix_.translate(playerX, playerY);
        g.beginBitmapFill(this.playerArrow_, this.arrowMatrix_, false);
        g.drawRect(playerX - 16, playerY - 16, 32, 32);
        g.endFill();
    }

    /** Greys out a zoom button when its limit is reached. Formerly _ze. */
    private function updateZoomButtons():void {
        if (this.zoomIndex_ == (this.zoomLevels_.length - 1)) {
            this.zoomOutButton_.transform.colorTransform = new ColorTransform(0.5, 0.5, 0.5);
        } else {
            this.zoomOutButton_.transform.colorTransform = new ColorTransform(1, 1, 1);
        }
        if (this.zoomIndex_ == 0) {
            this.zoomInButton_.transform.colorTransform = new ColorTransform(0.5, 0.5, 0.5);
        } else {
            this.zoomInButton_.transform.colorTransform = new ColorTransform(1, 1, 1);
        }
    }

    /** Removes the tooltip and the player menu. Formerly _false. */
    private function removePopups():void {
        if (this.toolTip_ != null) {
            if (this.toolTip_.parent != null) {
                this.toolTip_.parent.removeChild(this.toolTip_);
            }
            this.toolTip_ = null;
        }
        if (this.playerMenu_ != null) {
            if (this.playerMenu_.parent != null) {
                this.playerMenu_.parent.removeChild(this.playerMenu_);
            }
            this.playerMenu_ = null;
        }
    }

    /** Formerly _while */
    private function samePlayers(a:Vector.<Player>, b:Vector.<Player>):Boolean {
        if (a.length != b.length) {
            return false;
        }
        for (var i:int = 0; i < a.length; i++) {
            if (a[i] != b[i]) {
                return false;
            }
        }
        return true;
    }

    /** Formerly _0_7 */
    private function onZoomOutClick(event:MouseEvent):void {
        event.stopPropagation();
        this.zoomOut();
    }

    /** Formerly _Q_x */
    private function onZoomInClick(event:MouseEvent):void {
        event.stopPropagation();
        this.zoomIn();
    }

    private function onMouseOver(event:MouseEvent):void {
        this.mouseOver_ = true;
    }

    private function onMouseOut(event:MouseEvent):void {
        this.mouseOver_ = false;
    }

    /** Click on a hovered player dot opens the player menu. Formerly _R_B_. */
    private function onClick(event:MouseEvent):void {
        if (this.toolTip_ == null || this.toolTip_.parent == null || this.toolTip_.players_ == null || this.toolTip_.players_.length == 0) {
            return;
        }
        var players:Vector.<Player> = this.toolTip_.players_;
        var menuX:int = this.toolTip_.x + 12;
        var menuY:int = this.toolTip_.y;
        this.removePopups();
        this.playerMenu_ = new PlayerListMenu(this.map_, players);
        this.playerMenu_.x = menuX;
        this.playerMenu_.y = menuY;
        stage.addChild(this.playerMenu_);
    }
}
}
