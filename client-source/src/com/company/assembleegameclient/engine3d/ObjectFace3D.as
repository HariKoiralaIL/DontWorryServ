package com.company.assembleegameclient.engine3d {
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.GraphicHelper;
import com.company.util.MoreColorUtil;

import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsPath;
import flash.display.GraphicsPathCommand;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Vector3D;

/** One polygon of an Object3D, drawn with a texture or a lit solid color. */
public class ObjectFace3D {

    public const bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill();

    public var object_:Object3D;
    public var vertexIndices_:Vector.<int>;
    public var textured_:Boolean;
    public var texture_:BitmapData = null;
    public var localNormal_:Vector3D = null;
    public var normal_:Vector3D;
    public var brightness_:Number = 1;

    private var path_:GraphicsPath;
    private var solidFill_:GraphicsSolidFill = new GraphicsSolidFill(0xFFFFFF, 1);
    private var tToS_:Matrix = new Matrix();
    private var tempMatrix_:Matrix = new Matrix();

    public function ObjectFace3D(object:Object3D, vertexIndices:Vector.<int>, textured:Boolean = true) {
        this.object_ = object;
        this.vertexIndices_ = vertexIndices;
        this.textured_ = textured;

        var commands:Vector.<int> = new Vector.<int>();
        for (var i:int = 0; i < vertexIndices.length; i++) {
            commands.push(i == 0 ? GraphicsPathCommand.MOVE_TO : GraphicsPathCommand.LINE_TO);
        }
        var data:Vector.<Number> = new Vector.<Number>();
        data.length = vertexIndices.length * 2;
        this.path_ = new GraphicsPath(commands, data);
    }

    public function dispose():void {
        this.vertexIndices_ = null;
        this.path_.commands = null;
        this.path_.data = null;
        this.path_ = null;
    }

    /** Recomputes the face normal and its brightness from the object's current world vertices. */
    public function updateNormalAndBrightness():void {
        var last:int = this.vertexIndices_.length - 1;
        this.normal_ = new Vector3D();
        Plane.computeNormal(
            this.object_.getWorldVertex(this.vertexIndices_[0]),
            this.object_.getWorldVertex(this.vertexIndices_[1]),
            this.object_.getWorldVertex(this.vertexIndices_[last]),
            this.normal_);
        this.brightness_ = Lighting.getBrightness(this.normal_, 0.75);
        if (this.localNormal_ != null) {
            this.normal_ = this.object_.transform_.deltaTransformVector(this.localNormal_);
        }
    }

    public function draw(graphicsData:Vector.<IGraphicsData>, color:uint, texture:BitmapData):void {
        var last:int = this.vertexIndices_.length - 1;
        var i0:int = this.vertexIndices_[0] * 2;
        var i1:int = this.vertexIndices_[1] * 2;
        var iLast:int = this.vertexIndices_[last] * 2;
        var screen:Vector.<Number> = this.object_.screenVertices_;

        // Back-face culling in screen space.
        var e1x:Number = screen[i1] - screen[i0];
        var e1y:Number = screen[i1 + 1] - screen[i0 + 1];
        var e2x:Number = screen[iLast] - screen[i0];
        var e2y:Number = screen[iLast + 1] - screen[i0 + 1];
        if (e1x * e2y - e1y * e2x < 0) {
            return;
        }

        if (!this.textured_ || texture == null) {
            this.solidFill_.color = MoreColorUtil._kz(
                new ColorTransform(this.brightness_, this.brightness_, this.brightness_), color);
            graphicsData.push(this.solidFill_);
        } else {
            texture = TextureRedrawer.adjustBrightness(texture, this.brightness_);
            this.bitmapFill_.bitmapData = texture;
            this.bitmapFill_.matrix = this.computeTextureMatrix(texture);
            graphicsData.push(this.bitmapFill_);
        }

        for (var i:int = 0; i < this.vertexIndices_.length; i++) {
            var v:int = this.vertexIndices_[i];
            this.path_.data[i * 2] = screen[v * 2];
            this.path_.data[i * 2 + 1] = screen[v * 2 + 1];
        }
        graphicsData.push(this.path_);
        graphicsData.push(GraphicHelper.END_FILL);
    }

    private function computeTextureMatrix(texture:BitmapData):Matrix {
        var uvts:Vector.<Number> = this.object_.uvts_;
        var last:int = this.vertexIndices_.length - 1;
        var u0:int = this.vertexIndices_[0] * 3;
        var u1:int = this.vertexIndices_[1] * 3;
        var uLast:int = this.vertexIndices_[last] * 3;
        var originU:Number = uvts[u0] * texture.width;
        var originV:Number = uvts[u0 + 1] * texture.height;
        this.tToS_.a = uvts[u1] * texture.width - originU;
        this.tToS_.b = uvts[u1 + 1] * texture.height - originV;
        this.tToS_.c = uvts[uLast] * texture.width - originU;
        this.tToS_.d = uvts[uLast + 1] * texture.height - originV;
        this.tToS_.tx = originU;
        this.tToS_.ty = originV;
        this.tToS_.invert();

        var s0:int = this.vertexIndices_[0] * 2;
        var s1:int = this.vertexIndices_[1] * 2;
        var sLast:int = this.vertexIndices_[last] * 2;
        var screen:Vector.<Number> = this.object_.screenVertices_;
        this.tempMatrix_.a = screen[s1] - screen[s0];
        this.tempMatrix_.b = screen[s1 + 1] - screen[s0 + 1];
        this.tempMatrix_.c = screen[sLast] - screen[s0];
        this.tempMatrix_.d = screen[sLast + 1] - screen[s0 + 1];
        this.tempMatrix_.tx = screen[s0];
        this.tempMatrix_.ty = screen[s0 + 1];
        this.tToS_.concat(this.tempMatrix_);
        return this.tToS_;
    }

}
}
