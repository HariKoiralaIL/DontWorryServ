package com.company.assembleegameclient.engine3d {
import com.company.assembleegameclient.map.GameCamera;

import flash.display.BitmapData;
import flash.display.IGraphicsData;
import flash.geom.Matrix3D;
import flash.geom.Utils3D;
import flash.geom.Vector3D;

/** A positioned instance of a MeshModel that can be projected and drawn. */
public class Object3D {

    public static function getObject(modelName:String):Object3D {
        return new Object3D(MeshModel.getModel(modelName));
    }

    public var model_:MeshModel = null;
    public var vertices_:Vector.<Number>;
    public var uvts_:Vector.<Number>;
    public var faces_:Vector.<ObjectFace3D> = new Vector.<ObjectFace3D>();
    public var screenVertices_:Vector.<Number> = new Vector.<Number>();
    public var worldVertices_:Vector.<Number> = new Vector.<Number>();
    public var transform_:Matrix3D = new Matrix3D();

    public function Object3D(model:MeshModel = null) {
        if (model != null) {
            this.model_ = model;
            this.vertices_ = model.vertices_;
            this.uvts_ = model.uvts_.concat();
            for each (var face:ModelFace in model.faces_) {
                this.faces_.push(new ObjectFace3D(this, face.vertexIndices_, face.textured_));
            }
        } else {
            this.vertices_ = new Vector.<Number>();
            this.uvts_ = new Vector.<Number>();
        }
        this.setPosition(0, 0, 0, 0);
    }

    public function dispose():void {
        this.vertices_ = null;
        this.uvts_ = null;
        for each (var face:ObjectFace3D in this.faces_) {
            face.dispose();
        }
        this.faces_.length = 0;
        this.faces_ = null;
        this.screenVertices_ = null;
        this.worldVertices_ = null;
        this.transform_ = null;
    }

    public function setPosition(x:Number, y:Number, z:Number, rotationZ:Number):void {
        this.transform_.identity();
        this.transform_.appendRotation(rotationZ, Vector3D.Z_AXIS);
        this.transform_.appendTranslation(x, y, z);
        this.transform_.transformVectors(this.vertices_, this.worldVertices_);
        for each (var face:ObjectFace3D in this.faces_) {
            face.updateNormalAndBrightness();
        }
    }

    /** Returns the world-space vertex at index, or null if out of range. */
    public function getWorldVertex(index:int):Vector3D {
        var offset:int = index * 3;
        if (offset >= this.worldVertices_.length) {
            return null;
        }
        return new Vector3D(
            this.worldVertices_[offset],
            this.worldVertices_[offset + 1],
            this.worldVertices_[offset + 2]);
    }

    public function draw(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, color:uint, texture:BitmapData):void {
        Utils3D.projectVectors(camera.wToS_, this.worldVertices_, this.screenVertices_, this.uvts_);
        for each (var face:ObjectFace3D in this.faces_) {
            face.draw(graphicsData, color, texture);
        }
    }

}
}
