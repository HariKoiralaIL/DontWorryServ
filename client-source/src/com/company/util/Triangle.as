package com.company.util {
import flash.geom.Point;
import flash.geom.Rectangle;

public class Triangle {

    /** Barycentric point-in-triangle test. */
    public static function containsPoint(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, px:Number, py:Number):Boolean {
        var vx1:Number = x1 - x0;
        var vy1:Number = y1 - y0;
        var vx2:Number = x2 - x0;
        var vy2:Number = y2 - y0;
        var s:Number = (((px * vy2) - (py * vx2)) - ((x0 * vy2) - (y0 * vx2))) / ((vx1 * vy2) - (vy1 * vx2));
        var t:Number = -(((px * vy1) - (py * vx1)) - ((x0 * vy1) - (y0 * vx1))) / ((vx1 * vy2) - (vy1 * vx2));
        return s >= 0 && t >= 0 && (s + t) <= 1;
    }

    /** Triangle (x0..y2) vs. rectangle (left, top, right, bottom). */
    public static function triangleIntersectsRect(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, left:Number, top:Number, right:Number, bottom:Number):Boolean {
        if (((left > x0 && left > x1 && left > x2) || (right < x0 && right < x1 && right < x2)) || (top > y0 && top > y1 && top > y2) || (bottom < y0 && bottom < y1 && bottom < y2)) {
            return false;
        }
        if ((left < x0 && x0 < right && top < y0 && y0 < bottom) || (left < x1 && x1 < right && top < y1 && y1 < bottom) || (left < x2 && x2 < right && top < y2 && y2 < bottom)) {
            return true;
        }
        return edgeIntersectsRect(x0, y0, x1, y1, left, top, right, bottom)
                || edgeIntersectsRect(x1, y1, x2, y2, left, top, right, bottom)
                || edgeIntersectsRect(x2, y2, x0, y0, left, top, right, bottom);
    }

    private static function edgeIntersectsRect(ax:Number, ay:Number, bx:Number, by:Number, left:Number, top:Number, right:Number, bottom:Number):Boolean {
        var yAtLeft:Number;
        var yAtRight:Number;
        var edgeMinY:Number;
        var edgeMaxY:Number;
        var slope:Number = (by - ay) / (bx - ax);
        var intercept:Number = ay - (slope * ax);
        if (slope > 0) {
            yAtLeft = (slope * left) + intercept;
            yAtRight = (slope * right) + intercept;
        } else {
            yAtLeft = (slope * right) + intercept;
            yAtRight = (slope * left) + intercept;
        }
        if (ay < by) {
            edgeMinY = ay;
            edgeMaxY = by;
        } else {
            edgeMinY = by;
            edgeMaxY = ay;
        }
        var low:Number = (yAtLeft > edgeMinY) ? yAtLeft : edgeMinY;
        var high:Number = (yAtRight < edgeMaxY) ? yAtRight : edgeMaxY;
        return low < high && !(high < top || low > bottom);
    }

    public function Triangle(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number) {
        this.x0_ = x0;
        this.y0_ = y0;
        this.x1_ = x1;
        this.y1_ = y1;
        this.x2_ = x2;
        this.y2_ = y2;
        this.vx1_ = this.x1_ - this.x0_;
        this.vy1_ = this.y1_ - this.y0_;
        this.vx2_ = this.x2_ - this.x0_;
        this.vy2_ = this.y2_ - this.y0_;
    }

    public var x0_:Number;
    public var y0_:Number;
    public var x1_:Number;
    public var y1_:Number;
    public var x2_:Number;
    public var y2_:Number;
    public var vx1_:Number;
    public var vy1_:Number;
    public var vx2_:Number;
    public var vy2_:Number;

    public function getBounds():Rectangle {
        var minX:Number = Math.min(this.x0_, this.x1_, this.x2_);
        var maxX:Number = Math.max(this.x0_, this.x1_, this.x2_);
        var minY:Number = Math.min(this.y0_, this.y1_, this.y2_);
        var maxY:Number = Math.max(this.y0_, this.y1_, this.y2_);
        return new Rectangle(minX, minY, maxX - minX, maxY - minY);
    }

    public function getArea():Number {
        return Math.abs(((this.x0_ * (this.y1_ - this.y2_)) + (this.x1_ * (this.y2_ - this.y0_)) + (this.x2_ * (this.y0_ - this.y1_))) / 2);
    }

    /** Writes the incenter into `out`. */
    public function getIncenter(out:Point):void {
        var sideA:Number = PointUtil.distanceXY(this.x1_, this.y1_, this.x2_, this.y2_);
        var sideB:Number = PointUtil.distanceXY(this.x0_, this.y0_, this.x2_, this.y2_);
        var sideC:Number = PointUtil.distanceXY(this.x0_, this.y0_, this.x1_, this.y1_);
        out.x = ((sideA * this.x0_) + (sideB * this.x1_) + (sideC * this.x2_)) / (sideA + sideB + sideC);
        out.y = ((sideA * this.y0_) + (sideB * this.y1_) + (sideC * this.y2_)) / (sideA + sideB + sideC);
    }

    public function contains(px:Number, py:Number):Boolean {
        var s:Number = (((px * this.vy2_) - (py * this.vx2_)) - ((this.x0_ * this.vy2_) - (this.y0_ * this.vx2_))) / ((this.vx1_ * this.vy2_) - (this.vy1_ * this.vx2_));
        var t:Number = -(((px * this.vy1_) - (py * this.vx1_)) - ((this.x0_ * this.vy1_) - (this.y0_ * this.vx1_))) / ((this.vx1_ * this.vy2_) - (this.vy1_ * this.vx2_));
        return s >= 0 && t >= 0 && (s + t) <= 1;
    }

    /** 0 if inside, otherwise distance to the nearest edge. */
    public function distance(px:Number, py:Number):Number {
        if (this.contains(px, py)) {
            return 0;
        }
        return Math.min(
                LineUtil.distanceToSegment(px, py, this.x0_, this.y0_, this.x1_, this.y1_),
                LineUtil.distanceToSegment(px, py, this.x1_, this.y1_, this.x2_, this.y2_),
                LineUtil.distanceToSegment(px, py, this.x0_, this.y0_, this.x2_, this.y2_));
    }

    public function intersectsRect(left:Number, top:Number, right:Number, bottom:Number):Boolean {
        return Triangle.triangleIntersectsRect(this.x0_, this.y0_, this.x1_, this.y1_, this.x2_, this.y2_, left, top, right, bottom);
    }

}
}//package com.company.util
