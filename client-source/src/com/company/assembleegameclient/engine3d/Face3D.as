package com.company.assembleegameclient.engine3d {
import com.company.assembleegameclient.map.GameCamera;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.GraphicHelper;
import com.company.util.Triangle;

import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsPath;
import flash.display.GraphicsPathCommand;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.geom.Utils3D;
import flash.geom.Vector3D;

/** A standalone textured (or solid) polygon projected through the camera. */
public class Face3D {

    private static const SOLID_FILL:GraphicsSolidFill = new GraphicsSolidFill(0, 1);

    public var texture_:BitmapData;
    /** Flat [x,y,z,...] world-space vertices. */
    public var vertices_:Vector.<Number>;
    /** Flat [u,v,t,...] texture coordinates. */
    public var uvts_:Vector.<Number>;
    /** Flat [x,y,...] projected vertices, updated by draw(). */
    public var screenVertices_:Vector.<Number> = new Vector.<Number>();
    public var cullBackFaces_:Boolean;
    public var brightness_:Number = 1;
    public var useSolidFill_:Boolean = false;
    public var bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null, null, false, false);

    private var textureDirty_:Boolean = true;
    private var textureMatrix_:TextureMatrix = null;
    private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(), null);

    public function Face3D(texture:BitmapData, vertices:Vector.<Number>, uvts:Vector.<Number>,
                           cullBackFaces:Boolean = false, applyLighting:Boolean = false) {
        this.texture_ = texture;
        this.vertices_ = vertices;
        this.uvts_ = uvts;
        this.cullBackFaces_ = cullBackFaces;
        if (applyLighting) {
            var normal:Vector3D = new Vector3D();
            Plane.computeNormalFromVertices(vertices, normal);
            this.brightness_ = Lighting.getBrightness(normal, 0.75);
        }
        this.path_.commands.push(GraphicsPathCommand.MOVE_TO);
        for (var i:int = 3; i < this.vertices_.length; i += 3) {
            this.path_.commands.push(GraphicsPathCommand.LINE_TO);
        }
        this.path_.data = this.screenVertices_;
    }

    public function dispose():void {
        this.texture_ = null;
        this.vertices_ = null;
        this.uvts_ = null;
        this.screenVertices_ = null;
        this.textureMatrix_ = null;
        this.bitmapFill_ = null;
        this.path_.commands = null;
        this.path_.data = null;
        this.path_ = null;
    }

    public function setTexture(texture:BitmapData):void {
        if (this.texture_ == texture) {
            return;
        }
        this.texture_ = texture;
        this.textureDirty_ = true;
    }

    public function setUVs(uvts:Vector.<Number>):void {
        this.uvts_ = uvts;
        this.textureDirty_ = true;
    }

    /** Largest projected y among the face's vertices (used for draw ordering). */
    public function getMaxY():Number {
        var maxY:Number = -Number.MAX_VALUE;
        for (var i:int = 0; i < this.screenVertices_.length; i += 2) {
            if (this.screenVertices_[i + 1] > maxY) {
                maxY = this.screenVertices_[i + 1];
            }
        }
        return maxY;
    }

    /** Projects and queues the face; returns false if it was culled. */
    public function draw(graphicsData:Vector.<IGraphicsData>, camera:GameCamera):Boolean {
        Utils3D.projectVectors(camera.wToS_, this.vertices_, this.screenVertices_, this.uvts_);
        if (this.cullBackFaces_) {
            var s:Vector.<Number> = this.screenVertices_;
            var e1x:Number = s[2] - s[0];
            var e1y:Number = s[3] - s[1];
            var e2x:Number = s[4] - s[0];
            var e2y:Number = s[5] - s[1];
            if (e1x * e2y - e1y * e2x > 0) {
                return false;
            }
        }
        if (this.useSolidFill_) {
            graphicsData.push(SOLID_FILL);
            graphicsData.push(this.path_);
            graphicsData.push(GraphicHelper.END_FILL);
            return true;
        }
        if (this.textureDirty_) {
            this.refreshTexture();
        }
        this.textureMatrix_.calculateTextureMatrix(this.screenVertices_);
        this.bitmapFill_.bitmapData = this.textureMatrix_.texture_;
        this.bitmapFill_.matrix = this.textureMatrix_.tToS_;
        graphicsData.push(this.bitmapFill_);
        graphicsData.push(this.path_);
        graphicsData.push(GraphicHelper.END_FILL);
        return true;
    }

    /** Tests whether a screen point lies inside the projected triangle or quad. */
    public function contains(x:Number, y:Number):Boolean {
        var s:Vector.<Number> = this.screenVertices_;
        if (Triangle.containsPoint(s[0], s[1], s[2], s[3], s[4], s[5], x, y)) {
            return true;
        }
        if (s.length == 8 && Triangle.containsPoint(s[0], s[1], s[4], s[5], s[6], s[7], x, y)) {
            return true;
        }
        return false;
    }

    private function refreshTexture():void {
        var lit:BitmapData = TextureRedrawer.adjustBrightness(this.texture_, this.brightness_);
        if (this.textureMatrix_ == null) {
            this.textureMatrix_ = new TextureMatrix(lit, this.uvts_);
        } else {
            this.textureMatrix_.texture_ = lit;
            this.textureMatrix_.setUVs(this.uvts_);
        }
        this.textureDirty_ = false;
    }

}
}
