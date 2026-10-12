package com.company.assembleegameclient.engine3d {

/** One polygon of a MeshModel, referencing vertices by index. */
public class ModelFace {

    /** Sort comparator: faces with a lower min z (then lower max z) sort later. */
    public static function compareDepth(a:ModelFace, b:ModelFace):Number {
        var minA:Number = getMinZ(a);
        var minB:Number = getMinZ(b);
        if (minB > minA) {
            return -1;
        }
        if (minB < minA) {
            return 1;
        }
        var maxA:Number = getMaxZ(a);
        var maxB:Number = getMaxZ(b);
        if (maxB > maxA) {
            return -1;
        }
        if (maxB < maxA) {
            return 1;
        }
        return 0;
    }

    private static function getMinZ(face:ModelFace):Number {
        var min:Number = Number.MAX_VALUE;
        for each (var index:int in face.vertexIndices_) {
            var z:Number = face.model_.vertices_[index * 3 + 2];
            min = z < min ? z : min;
        }
        return min;
    }

    private static function getMaxZ(face:ModelFace):Number {
        var max:Number = Number.MIN_VALUE;
        for each (var index:int in face.vertexIndices_) {
            var z:Number = face.model_.vertices_[index * 3 + 2];
            max = z > max ? z : max;
        }
        return max;
    }

    public var model_:MeshModel;
    public var vertexIndices_:Vector.<int>;
    public var textured_:Boolean;

    public function ModelFace(model:MeshModel, vertexIndices:Vector.<int>, textured:Boolean) {
        this.model_ = model;
        this.vertexIndices_ = vertexIndices;
        this.textured_ = textured;
    }

}
}
