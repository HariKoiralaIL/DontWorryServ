package com.company.assembleegameclient.engine3d {
import com.company.assembleegameclient.map.GameCamera;
import com.company.util.Trig;

import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsEndFill;
import flash.display.GraphicsPath;
import flash.display.GraphicsPathCommand;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.geom.Matrix;
import flash.geom.Matrix3D;
import flash.geom.Utils3D;
import flash.geom.Vector3D;

/** A camera-facing square sprite drawn at a projected 3D position. */
public class Billboard {

    private static const PATH_COMMANDS:Vector.<int> = new <int>[
        GraphicsPathCommand.MOVE_TO,
        GraphicsPathCommand.LINE_TO,
        GraphicsPathCommand.LINE_TO,
        GraphicsPathCommand.LINE_TO];
    private static const END_FILL:GraphicsEndFill = new GraphicsEndFill();

    public var size_:Number;
    /** Projected position from the last draw() call. */
    public var projected_:Vector3D;

    private const data_:Vector.<Number> = new Vector.<Number>();
    private const path_:GraphicsPath = new GraphicsPath(PATH_COMMANDS, data_);
    private const bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null, new Matrix(), false, false);
    private const solidFill_:GraphicsSolidFill = new GraphicsSolidFill(0, 1);

    public function Billboard(size:Number) {
        this.size_ = size;
    }

    public function setSize(size:Number):void {
        this.size_ = size;
    }

    public function draw(graphicsData:Vector.<IGraphicsData>, worldPosition:Vector3D, rotation:Number,
                         worldToScreen:Matrix3D, camera:GameCamera, texture:BitmapData, color:uint = 0):void {
        this.projected_ = Utils3D.projectVector(worldToScreen, worldPosition);
        if (this.projected_.w < 0) {
            return;
        }
        var px:Number = this.projected_.x;
        var py:Number = this.projected_.y;
        var depthScale:Number = this.projected_.w * Math.sin((camera.perspective_.fieldOfView / 2) * Trig.DEG_TO_RAD);
        var half:Number = this.size_ / depthScale;

        this.data_.length = 0;
        if (rotation == 0) {
            this.data_.push(
                px - half, py - half,
                px + half, py - half,
                px + half, py + half,
                px - half, py + half);
        } else {
            var cos:Number = Math.cos(rotation);
            var sin:Number = Math.sin(rotation);
            this.pushRotatedCorner(px, py, -half, -half, cos, sin);
            this.pushRotatedCorner(px, py, half, -half, cos, sin);
            this.pushRotatedCorner(px, py, half, half, cos, sin);
            this.pushRotatedCorner(px, py, -half, half, cos, sin);
        }

        if (texture != null) {
            this.bitmapFill_.bitmapData = texture;
            var m:Matrix = this.bitmapFill_.matrix;
            m.identity();
            m.scale(2 * half / texture.width, 2 * half / texture.height);
            m.translate(-half, -half);
            m.rotate(rotation);
            m.translate(px, py);
            graphicsData.push(this.bitmapFill_);
        } else {
            this.solidFill_.color = color;
            graphicsData.push(this.solidFill_);
        }
        graphicsData.push(this.path_);
        graphicsData.push(END_FILL);
    }

    private function pushRotatedCorner(px:Number, py:Number, dx:Number, dy:Number, cos:Number, sin:Number):void {
        this.data_.push(px + (cos * dx + sin * dy), py + (sin * dx - cos * dy));
    }

}
}
