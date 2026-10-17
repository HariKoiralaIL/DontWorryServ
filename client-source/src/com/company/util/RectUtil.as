package com.company.util {
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

public class RectUtil {

    /** Distance from (px,py) to the rectangle (0 if inside). */
    public static function distanceToPoint(rect:Rectangle, px:Number, py:Number):Number {
        var clampedX:Number = px;
        var clampedY:Number = py;
        if (clampedX < rect.x) {
            clampedX = rect.x;
        } else {
            if (clampedX > rect.right) {
                clampedX = rect.right;
            }
        }
        if (clampedY < rect.y) {
            clampedY = rect.y;
        } else {
            if (clampedY > rect.bottom) {
                clampedY = rect.bottom;
            }
        }
        if (clampedX == px && clampedY == py) {
            return 0;
        }
        return PointUtil.distanceXY(clampedX, clampedY, px, py);
    }

    /** Point in/on the rectangle closest to (px,py). */
    public static function closestPoint(rect:Rectangle, px:Number, py:Number):Point {
        var clampedX:Number = px;
        var clampedY:Number = py;
        if (clampedX < rect.x) {
            clampedX = rect.x;
        } else {
            if (clampedX > rect.right) {
                clampedX = rect.right;
            }
        }
        if (clampedY < rect.y) {
            clampedY = rect.y;
        } else {
            if (clampedY > rect.bottom) {
                clampedY = rect.bottom;
            }
        }
        return new Point(clampedX, clampedY);
    }

    /** Segment (x0,y0)-(x1,y1) vs. rectangle. */
    public static function segmentIntersectsRect(rect:Rectangle, x0:Number, y0:Number, x1:Number, y1:Number):Boolean {
        var yAtLeft:Number;
        var yAtRight:Number;
        var segmentMinY:Number;
        var segmentMaxY:Number;
        if (((rect.left > x0 && rect.left > x1) || (rect.right < x0 && rect.right < x1)) || (rect.top > y0 && rect.top > y1) || (rect.bottom < y0 && rect.bottom < y1)) {
            return false;
        }
        if ((rect.left < x0 && x0 < rect.right && rect.top < y0 && y0 < rect.bottom) || (rect.left < x1 && x1 < rect.right && rect.top < y1 && y1 < rect.bottom)) {
            return true;
        }
        var slope:Number = (y1 - y0) / (x1 - x0);
        var intercept:Number = y0 - (slope * x0);
        if (slope > 0) {
            yAtLeft = (slope * rect.left) + intercept;
            yAtRight = (slope * rect.right) + intercept;
        } else {
            yAtLeft = (slope * rect.right) + intercept;
            yAtRight = (slope * rect.left) + intercept;
        }
        if (y0 < y1) {
            segmentMinY = y0;
            segmentMaxY = y1;
        } else {
            segmentMinY = y1;
            segmentMaxY = y0;
        }
        var low:Number = (yAtLeft > segmentMinY) ? yAtLeft : segmentMinY;
        var high:Number = (yAtRight < segmentMaxY) ? yAtRight : segmentMaxY;
        return low < high && !(high < rect.top || low > rect.bottom);
    }

    /** Where segment (x0,y0)->(x1,y1) crosses a rect edge, written to `out`; false if none found. */
    public static function findEdgeCrossing(rect:Rectangle, x0:Number, y0:Number, x1:Number, y1:Number, out:Point):Boolean {
        var slope:Number;
        var intercept:Number;
        var crossY:Number;
        var crossX:Number;
        if (x1 <= rect.x) {
            slope = (y1 - y0) / (x1 - x0);
            intercept = y0 - (x0 * slope);
            crossY = (slope * rect.x) + intercept;
            if (crossY >= rect.y && crossY <= (rect.y + rect.height)) {
                out.x = rect.x;
                out.y = crossY;
                return true;
            }
        } else {
            if (x1 >= (rect.x + rect.width)) {
                slope = (y1 - y0) / (x1 - x0);
                intercept = y0 - (x0 * slope);
                crossY = (slope * (rect.x + rect.width)) + intercept;
                if (crossY >= rect.y && crossY <= (rect.y + rect.height)) {
                    out.x = rect.x + rect.width;
                    out.y = crossY;
                    return true;
                }
            }
        }
        if (y1 <= rect.y) {
            slope = (x1 - x0) / (y1 - y0);
            intercept = x0 - (y0 * slope);
            crossX = (slope * rect.y) + intercept;
            if (crossX >= rect.x && crossX <= (rect.x + rect.width)) {
                out.x = crossX;
                out.y = rect.y;
                return true;
            }
        } else {
            if (y1 >= (rect.y + rect.height)) {
                slope = (x1 - x0) / (y1 - y0);
                intercept = x0 - (y0 * slope);
                crossX = (slope * (rect.y + rect.height)) + intercept;
                if (crossX >= rect.x && crossX <= (rect.x + rect.width)) {
                    out.x = crossX;
                    out.y = rect.y + rect.height;
                    return true;
                }
            }
        }
        return false;
    }

    /** Same as findEdgeCrossing but takes IntPoints and returns the crossing (or null). */
    public static function findEdgeCrossingPoint(rect:Rectangle, from:IntPoint, to:IntPoint):Point {
        var slope:Number;
        var intercept:Number;
        var crossY:Number;
        var crossX:Number;
        if (to.x() <= rect.x) {
            slope = (to.y() - from.y()) / (to.x() - from.x());
            intercept = from.y() - (from.x() * slope);
            crossY = (slope * rect.x) + intercept;
            if (crossY >= rect.y && crossY <= (rect.y + rect.height)) {
                return new Point(rect.x, crossY);
            }
        } else {
            if (to.x() >= (rect.x + rect.width)) {
                slope = (to.y() - from.y()) / (to.x() - from.x());
                intercept = from.y() - (from.x() * slope);
                crossY = (slope * (rect.x + rect.width)) + intercept;
                if (crossY >= rect.y && crossY <= (rect.y + rect.height)) {
                    return new Point(rect.x + rect.width, crossY);
                }
            }
        }
        if (to.y() <= rect.y) {
            slope = (to.x() - from.x()) / (to.y() - from.y());
            intercept = from.x() - (from.y() * slope);
            crossX = (slope * rect.y) + intercept;
            if (crossX >= rect.x && crossX <= (rect.x + rect.width)) {
                return new Point(crossX, rect.y);
            }
        } else {
            if (to.y() >= (rect.y + rect.height)) {
                slope = (to.x() - from.x()) / (to.y() - from.y());
                intercept = from.x() - (from.y() * slope);
                crossX = (slope * (rect.y + rect.height)) + intercept;
                if (crossX >= rect.x && crossX <= (rect.x + rect.width)) {
                    return new Point(crossX, rect.y + rect.height);
                }
            }
        }
        return null;
    }

    /** Axis-aligned bounds of a width x height rect centered at (x,y) and rotated by `rotation` radians. */
    public static function getRotatedBounds(x:Number, y:Number, rotation:Number, width:Number, height:Number):BoundingBox {
        var corner:Point;
        var matrix:Matrix = new Matrix();
        matrix.translate(-width / 2, -height / 2);
        matrix.rotate(rotation);
        matrix.translate(x, y);
        var bounds:BoundingBox = new BoundingBox();
        var local:Point = new Point();
        var i:int = 0;
        while (i <= 1) {
            var j:int = 0;
            while (j <= 1) {
                local.x = i * width;
                local.y = j * height;
                corner = matrix.transformPoint(local);
                bounds.add(corner.x, corner.y);
                j++;
            }
            i++;
        }
        return bounds;
    }

}
}//package com.company.util
