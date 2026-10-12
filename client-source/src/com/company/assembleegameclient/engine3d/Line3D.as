package com.company.assembleegameclient.engine3d {
import flash.geom.Vector3D;

public class Line3D {

    private static const EPSILON:Number = 0.001;

    public static function runUnitTests():Boolean {
        return UnitTest.run();
    }

    public var v0_:Vector3D;
    public var v1_:Vector3D;

    public function Line3D(v0:Vector3D, v1:Vector3D) {
        this.v0_ = v0;
        this.v1_ = v1;
    }

    /**
     * Compares depth (z) where this line and the other cross in the xy-plane.
     * Returns Order.ABOVE if this line is higher, Order.BELOW if lower,
     * Order.INDETERMINATE if they don't cross or are parallel/coincident.
     */
    public function compareDepth(other:Line3D):int {
        var denominator:Number = (other.v1_.y - other.v0_.y) * (this.v1_.x - this.v0_.x)
                               - (other.v1_.x - other.v0_.x) * (this.v1_.y - this.v0_.y);
        if (isNearZero(denominator)) {
            return Order.INDETERMINATE;
        }
        var dx:Number = this.v0_.x - other.v0_.x;
        var dy:Number = this.v0_.y - other.v0_.y;
        var numeratorThis:Number = (other.v1_.x - other.v0_.x) * dy - (other.v1_.y - other.v0_.y) * dx;
        var numeratorOther:Number = (this.v1_.x - this.v0_.x) * dy - (this.v1_.y - this.v0_.y) * dx;
        if (isNearZero(numeratorThis) && isNearZero(numeratorOther)) {
            return Order.INDETERMINATE;
        }
        var tThis:Number = numeratorThis / denominator;
        var tOther:Number = numeratorOther / denominator;
        if (tThis > 1 || tThis < 0 || tOther > 1 || tOther < 0) {
            return Order.INDETERMINATE;
        }
        var zThis:Number = this.v0_.z + tThis * (this.v1_.z - this.v0_.z);
        var zOther:Number = other.v0_.z + tOther * (other.v1_.z - other.v0_.z);
        var dz:Number = zThis - zOther;
        if (isNearZero(dz)) {
            return Order.INDETERMINATE;
        }
        return dz > 0 ? Order.ABOVE : Order.BELOW;
    }

    public function pointAt(t:Number):Vector3D {
        return new Vector3D(
            this.v0_.x + (this.v1_.x - this.v0_.x) * t,
            this.v0_.y + (this.v1_.y - this.v0_.y) * t,
            this.v0_.z + (this.v1_.z - this.v0_.z) * t);
    }

    public function toString():String {
        return "(" + this.v0_ + ", " + this.v1_ + ")";
    }

    private static function isNearZero(value:Number):Boolean {
        return value < EPSILON && value > -EPSILON;
    }

}
}

import com.company.assembleegameclient.engine3d.Line3D;
import com.company.assembleegameclient.engine3d.Order;

import flash.geom.Vector3D;

class UnitTest {

    internal static function testCrossZ():Boolean {
        var a:Line3D = new Line3D(new Vector3D(0, 0, 0), new Vector3D(0, 100, 0));
        var b:Line3D = new Line3D(new Vector3D(10, 0, 10), new Vector3D(-10, 100, -100));
        if (a.compareDepth(b) != Order.ABOVE) {
            return false;
        }
        if (b.compareDepth(a) != Order.BELOW) {
            return false;
        }
        a = new Line3D(new Vector3D(1, 1, 200), new Vector3D(6, 6, 200));
        b = new Line3D(new Vector3D(3, 1, -100), new Vector3D(1, 3, -100));
        if (a.compareDepth(b) != Order.ABOVE) {
            return false;
        }
        if (b.compareDepth(a) != Order.BELOW) {
            return false;
        }
        return true;
    }

    public static function run():Boolean {
        return testCrossZ();
    }

}
