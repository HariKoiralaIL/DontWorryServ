package com.company.assembleegameclient.map {
import com.company.assembleegameclient.engine3d.TextureMatrix;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.util.TileRedrawer;

import flash.display.BitmapData;
import flash.display.IGraphicsData;
import flash.geom.Vector3D;

public class Square {

    public static const UVT:Vector.<Number> = new <Number>[0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0];
    private static const HASH_PRIMES:Vector.<int> = new <int>[26171, 44789, 20333, 70429, 98257, 59393, 33961];

    public var map_:GameMap;
    public var x_:int;
    public var y_:int;
    public var tileType_:uint = 0xFF;
    public var center_:Vector3D;
    public var vertices_:Vector.<Number>;
    public var obj_:GameObject = null;
    public var props_:GroundProperties;
    public var texture_:BitmapData = null;
    public var sink_:int = 0;
    public var lastDamage_:int = 0;
    public var faces_:Vector.<SquareFace>;
    public var topFace_:SquareFace = null;
    public var baseTexMatrix_:TextureMatrix = null;
    public var lastVisible_:int;

    public function Square(map:GameMap, x:int, y:int) {
        this.props_ = GroundLibrary.defaultProps_;
        this.faces_ = new Vector.<SquareFace>();
        super();
        this.map_ = map;
        this.x_ = x;
        this.y_ = y;
        this.center_ = new Vector3D(this.x_ + 0.5, this.y_ + 0.5, 0);
        this.vertices_ = new <Number>[this.x_, this.y_, 0, this.x_ + 1, this.y_, 0, this.x_ + 1, this.y_ + 1, 0, this.x_, this.y_ + 1, 0];
    }

    /** Deterministic per-tile texture variation seed. */
    private static function hash(x:int, y:int):int {
        var prime:int = HASH_PRIMES[(x + y) % 7];
        var h:Number = ((x << 16) | y) ^ 81397550;
        h = (h * prime) % 0xFFFF;
        return h;
    }

    public function dispose():void {
        this.map_ = null;
        this.center_ = null;
        this.vertices_ = null;
        this.obj_ = null;
        this.texture_ = null;
        for each (var face:SquareFace in this.faces_) {
            face.dispose();
        }
        this.faces_.length = 0;
        if (this.topFace_ != null) {
            this.topFace_.dispose();
            this.topFace_ = null;
        }
        this.faces_ = null;
        this.baseTexMatrix_ = null;
    }

    public function setTileType(tileType:uint):void {
        this.tileType_ = tileType;
        this.props_ = GroundLibrary.propsLibrary_[this.tileType_];
        this.texture_ = GroundLibrary.getBitmapData(this.tileType_, hash(this.x_, this.y_));
        this.baseTexMatrix_ = new TextureMatrix(this.texture_, UVT);
        this.faces_.length = 0;
    }

    public function isWalkable():Boolean {
        return !this.props_.noWalk_ && (this.obj_ == null || !this.obj_.props_.occupySquare_);
    }

    public function draw(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
        if (this.texture_ == null) {
            return;
        }
        if (this.faces_.length == 0) {
            this.buildFaces();
        }
        for each (var face:SquareFace in this.faces_) {
            if (!face.draw(graphicsData, camera, time)) {
                if (face.face_.screenVertices_[1] < camera.clipRect_.bottom) {
                    this.lastVisible_ = 0;
                }
                return;
            }
        }
    }

    public function drawTop(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
        this.topFace_.draw(graphicsData, camera, time);
    }

    private function buildFaces():void {
        this.faces_.length = 0;
        this.topFace_ = null;
        var composite:BitmapData;
        var uOffset:Number;
        var vOffset:Number;
        if (this.props_.animate_.type_ != AnimateProperties.NONE) {
            // NOTE: xOffset_ is intentionally passed for both axes (as in the original).
            this.faces_.push(new SquareFace(this.texture_, this.vertices_, this.props_.xOffset_, this.props_.xOffset_, this.props_.animate_.type_, this.props_.animate_.dx_, this.props_.animate_.dy_));
            composite = TileRedrawer.redraw(this, false);
            if (composite != null) {
                this.faces_.push(new SquareFace(composite, this.vertices_, 0, 0, AnimateProperties.NONE, 0, 0));
            }
        } else {
            composite = TileRedrawer.redraw(this, true);
            uOffset = 0;
            vOffset = 0;
            if (composite == null) {
                if (this.props_.randomOffset_) {
                    uOffset = int(this.texture_.width * Math.random()) / this.texture_.width;
                    vOffset = int(this.texture_.height * Math.random()) / this.texture_.height;
                } else {
                    uOffset = this.props_.xOffset_;
                    vOffset = this.props_.yOffset_;
                }
            }
            this.faces_.push(new SquareFace((composite != null) ? composite : this.texture_, this.vertices_, uOffset, vOffset, AnimateProperties.NONE, 0, 0));
        }
        if (this.props_.sink_) {
            this.sink_ = (composite == null) ? 12 : 6;
        } else {
            this.sink_ = 0;
        }
        if (this.props_.topData_) {
            var topVertices:Vector.<Number> = this.vertices_.concat();
            for (var i:uint = 2; i < topVertices.length; i += 3) {
                topVertices[i] = 1;
            }
            this.topFace_ = new SquareFace(this.props_.topData_.getTexture(), topVertices, 0, 0, this.props_.topAnimate_.type_, this.props_.topAnimate_.dx_, this.props_.topAnimate_.dy_);
        }
    }

}
}
