package com.company.util {
import flash.geom.Matrix;
import flash.geom.Point;

public class IntPoint {

    public static function runUnitTest():void {
        var test:UnitTest = new UnitTest();
    }

    public static function fromPoint(point:Point):IntPoint {
        return new IntPoint(Math.round(point.x), Math.round(point.y));
    }

    public function IntPoint(x:int = 0, y:int = 0) {
        this.x_ = x;
        this.y_ = y;
    }

    public var x_:int;
    public var y_:int;

    public function x():int {
        return this.x_;
    }

    public function y():int {
        return this.y_;
    }

    public function setX(value:int):void {
        this.x_ = value;
    }

    public function setY(value:int):void {
        this.y_ = value;
    }

    public function clone():IntPoint {
        return new IntPoint(this.x_, this.y_);
    }

    public function equals(other:IntPoint):Boolean {
        return this.x_ == other.x_ && this.y_ == other.y_;
    }

    /** Euclidean distance, rounded to the nearest int. */
    public function distanceToRounded(other:IntPoint):int {
        var dx:int = other.x_ - this.x_;
        var dy:int = other.y_ - this.y_;
        return Math.round(Math.sqrt((dx * dx) + (dy * dy)));
    }

    public function distanceTo(other:IntPoint):Number {
        var dx:int = other.x_ - this.x_;
        var dy:int = other.y_ - this.y_;
        return Math.sqrt((dx * dx) + (dy * dy));
    }

    /** Distance to a Point; deltas are truncated to int (original behavior). */
    public function distanceToPoint(point:Point):Number {
        var dx:int = point.x - this.x_;
        var dy:int = point.y - this.y_;
        return Math.sqrt((dx * dx) + (dy * dy));
    }

    public function trunc1000():IntPoint {
        return new IntPoint(int(this.x_ / 1000) * 1000, int(this.y_ / 1000) * 1000);
    }

    public function round1000():IntPoint {
        return new IntPoint(Math.round(this.x_ / 1000) * 1000, Math.round(this.y_ / 1000) * 1000);
    }

    public function distanceSquaredTo(other:IntPoint):int {
        var dx:int = other.x() - this.x_;
        var dy:int = other.y() - this.y_;
        return (dx * dx) + (dy * dy);
    }

    public function toPoint():Point {
        return new Point(this.x_, this.y_);
    }

    public function transform(matrix:Matrix):IntPoint {
        var transformed:Point = matrix.transformPoint(this.toPoint());
        return new IntPoint(Math.round(transformed.x), Math.round(transformed.y));
    }

    public function toString():String {
        return "(" + this.x_ + ", " + this.y_ + ")";
    }

}
}//package com.company.util

import com.company.util.IntPoint;

class UnitTest {

    public function UnitTest() {
        trace("STARTING UNITTEST: IntPoint");
        checkRound(1, 999, 1001, 1000, 1000);
        checkRound(2, 500, 400, 1000, 0);
        checkRound(3, -400, -500, 0, 0);
        checkRound(4, -501, -999, -1000, -1000);
        checkRound(5, -1000, -1001, -1000, -1000);
        checkTrunc(6, 999, 1001, 0, 1000);
        checkTrunc(7, 500, 400, 0, 0);
        checkTrunc(8, -400, -500, 0, 0);
        checkTrunc(9, -501, -999, 0, 0);
        checkTrunc(10, -1000, -1001, -1000, -1000);
        checkIntCast(40, 0.9999998);
        checkIntCast(41, 0.5);
        checkIntCast(42, 0.499999);
        checkIntCast(43, -0.499999);
        checkIntCast(44, -0.5);
        checkIntCast(45, -0.99999);
        trace("FINISHED UNITTEST: IntPoint");
    }

    private function checkRound(id:int, x:int, y:int, expectedX:int, expectedY:int):void {
        var result:IntPoint = new IntPoint(x, y).round1000();
        if (result.x() != expectedX || result.y() != expectedY) {
            trace("ERROR IN UNITTEST: IntPoint" + id);
        }
    }

    private function checkTrunc(id:int, x:int, y:int, expectedX:int, expectedY:int):void {
        var result:IntPoint = new IntPoint(x, y).trunc1000();
        if (result.x() != expectedX || result.y() != expectedY) {
            trace("ERROR IN UNITTEST: IntPoint" + id);
        }
    }

    private function checkIntCast(id:int, value:Number):void {
        if (int(value) != 0) {
            trace("ERROR IN UNITTEST: IntPoint" + id);
        }
    }
}
