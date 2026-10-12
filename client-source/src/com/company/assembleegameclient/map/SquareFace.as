package com.company.assembleegameclient.map {
import com.company.assembleegameclient.engine3d.Face3D;

import flash.display.BitmapData;
import flash.display.IGraphicsData;

/** One textured quad of a Square, optionally with scrolling UVs. */
public class SquareFace {

    public var animate_:int;
    public var face_:Face3D;
    public var xOffset_:Number = 0;
    public var yOffset_:Number = 0;
    public var animateDx_:Number = 0;
    public var animateDy_:Number = 0;

    public function SquareFace(texture:BitmapData, vertices:Vector.<Number>, xOffset:Number, yOffset:Number, animateType:int, animateDx:Number, animateDy:Number) {
        this.face_ = new Face3D(texture, vertices, Square.UVT.concat());
        this.xOffset_ = xOffset;
        this.yOffset_ = yOffset;
        if (this.xOffset_ != 0 || this.yOffset_ != 0) {
            this.setUVOffset(this.xOffset_, this.yOffset_);
            this.face_.bitmapFill_.repeat = true;
        }
        this.animate_ = animateType;
        if (this.animate_ != AnimateProperties.NONE) {
            this.face_.bitmapFill_.repeat = true;
        }
        this.animateDx_ = animateDx;
        this.animateDy_ = animateDy;
    }

    public function dispose():void {
        this.face_.dispose();
        this.face_ = null;
    }

    public function draw(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):Boolean {
        if (this.animate_ != AnimateProperties.NONE) {
            var u:Number = 0;
            var v:Number = 0;
            switch (this.animate_) {
                case AnimateProperties.WAVE:
                    u = this.xOffset_ + Math.sin(this.animateDx_ * time / 1000);
                    v = this.yOffset_ + Math.sin(this.animateDy_ * time / 1000);
                    break;
                case AnimateProperties.FLOW:
                    u = this.xOffset_ + this.animateDx_ * time / 1000;
                    v = this.yOffset_ + this.animateDy_ * time / 1000;
                    break;
            }
            this.setUVOffset(u, v);
        }
        return this.face_.draw(graphicsData, camera);
    }

    private function setUVOffset(u:Number, v:Number):void {
        this.face_.uvts_.length = 0;
        this.face_.uvts_.push(0 + u, 0 + v, 0, 1 + u, 0 + v, 0, 1 + u, 1 + v, 0, 0 + u, 1 + v, 0);
        this.face_.setUVs(this.face_.uvts_);
    }

}
}
