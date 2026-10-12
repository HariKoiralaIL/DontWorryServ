package com.company.assembleegameclient.engine3d {
import flash.display.BitmapData;
import flash.geom.Matrix;

/** Maps a texture onto a projected polygon using its first, second and last vertices. */
public class TextureMatrix {

    public var texture_:BitmapData = null;
    public var tToS_:Matrix = new Matrix();
    private var inverseBasis_:Matrix = null;
    private var tempMatrix_:Matrix = new Matrix();

    public function TextureMatrix(texture:BitmapData, uvts:Vector.<Number>) {
        this.texture_ = texture;
        this.setUVs(uvts);
    }

    /** Recomputes the inverse texture-space basis from [u,v,t,...] coordinates. */
    public function setUVs(uvts:Vector.<Number>):void {
        if (this.texture_ == null) {
            this.inverseBasis_ = null;
            return;
        }
        var last:int = uvts.length - 3;
        var w:Number = this.texture_.width;
        var h:Number = this.texture_.height;
        var u0:Number = uvts[0] * w;
        var v0:Number = uvts[1] * h;
        var u1:Number = uvts[3] * w;
        var v1:Number = uvts[4] * h;
        var u2:Number = uvts[last] * w;
        var v2:Number = uvts[last + 1] * h;
        this.inverseBasis_ = new Matrix(u1 - u0, v1 - v0, u2 - u0, v2 - v0, u0, v0);
        this.inverseBasis_.invert();
    }

    /** Computes tToS_ for the given projected [x,y,...] screen vertices. */
    public function calculateTextureMatrix(screenVertices:Vector.<Number>):void {
        var m:Matrix = this.inverseBasis_;
        this.tToS_.a = m.a;
        this.tToS_.b = m.b;
        this.tToS_.c = m.c;
        this.tToS_.d = m.d;
        this.tToS_.tx = m.tx;
        this.tToS_.ty = m.ty;
        var lastX:int = screenVertices.length - 2;
        var lastY:int = lastX + 1;
        this.tempMatrix_.a = screenVertices[2] - screenVertices[0];
        this.tempMatrix_.b = screenVertices[3] - screenVertices[1];
        this.tempMatrix_.c = screenVertices[lastX] - screenVertices[0];
        this.tempMatrix_.d = screenVertices[lastY] - screenVertices[1];
        this.tempMatrix_.tx = screenVertices[0];
        this.tempMatrix_.ty = screenVertices[1];
        this.tToS_.concat(this.tempMatrix_);
    }

}
}
