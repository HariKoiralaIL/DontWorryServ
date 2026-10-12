package com.company.assembleegameclient.engine3d {
import flash.geom.Vector3D;

public class Plane {

    public static const NONE:int = 0;
    public static const FRONT:int = 1;
    public static const BACK:int = 2;
    public static const ON_PLANE:int = 3;

    private static const EPSILON:Number = 0.001;

    /** Writes the unit normal of triangle (p0, p1, p2) into out. */
    public static function computeNormal(p0:Vector3D, p1:Vector3D, p2:Vector3D, out:Vector3D):void {
        var ax:Number = p1.x - p0.x;
        var ay:Number = p1.y - p0.y;
        var az:Number = p1.z - p0.z;
        var bx:Number = p2.x - p0.x;
        var by:Number = p2.y - p0.y;
        var bz:Number = p2.z - p0.z;
        out.x = ay * bz - az * by;
        out.y = az * bx - ax * bz;
        out.z = ax * by - ay * bx;
        out.normalize();
    }

    /** Same as computeNormal, using the first three vertices of a flat [x,y,z,...] vector. */
    public static function computeNormalFromVertices(vertices:Vector.<Number>, out:Vector3D):void {
        var ax:Number = vertices[3] - vertices[0];
        var ay:Number = vertices[4] - vertices[1];
        var az:Number = vertices[5] - vertices[2];
        var bx:Number = vertices[6] - vertices[0];
        var by:Number = vertices[7] - vertices[1];
        var bz:Number = vertices[8] - vertices[2];
        out.x = ay * bz - az * by;
        out.y = az * bx - ax * bz;
        out.z = ax * by - ay * bx;
        out.normalize();
    }

    public var normal_:Vector3D;
    public var d_:Number;

    public function Plane(p0:Vector3D = null, p1:Vector3D = null, p2:Vector3D = null) {
        if (p0 != null && p1 != null && p2 != null) {
            this.normal_ = new Vector3D();
            computeNormal(p0, p1, p2, this.normal_);
            this.d_ = -this.normal_.dotProduct(p0);
        }
    }

    /** Classifies a point as FRONT, BACK or ON_PLANE. */
    public function classifyPoint(point:Vector3D):int {
        var distance:Number = this.normal_.dotProduct(point) + this.d_;
        if (distance > EPSILON) {
            return FRONT;
        }
        if (distance < -EPSILON) {
            return BACK;
        }
        return ON_PLANE;
    }

    /** Parameter t at which the line (v0 + t*(v1-v0)) crosses the plane; NaN if parallel. */
    public function getLineIntersection(line:Line3D):Number {
        var n:Vector3D = this.normal_;
        var numerator:Number = -this.d_ - n.x * line.v0_.x - n.y * line.v0_.y - n.z * line.v0_.z;
        var denominator:Number = n.x * (line.v1_.x - line.v0_.x)
                               + n.y * (line.v1_.y - line.v0_.y)
                               + n.z * (line.v1_.z - line.v0_.z);
        if (denominator == 0) {
            return NaN;
        }
        return numerator / denominator;
    }

    public function getZ(x:Number, y:Number):Number {
        return -(this.d_ + this.normal_.x * x + this.normal_.y * y) / this.normal_.z;
    }

    public function toString():String {
        return "Plane(n = " + this.normal_ + ", d = " + this.d_ + ")";
    }

}
}
