package com.company.util {
import flash.geom.Point;

public class LineUtil {

    /** Intersection of segments (x1,y1)-(x2,y2) and (x3,y3)-(x4,y4), or null if none / parallel. */
    public static function segmentIntersection(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, x4:Number, y4:Number):Point {
        var denominator:Number = ((y4 - y3) * (x2 - x1)) - ((x4 - x3) * (y2 - y1));
        if (denominator == 0) {
            return null;
        }
        var ua:Number = (((x4 - x3) * (y1 - y3)) - ((y4 - y3) * (x1 - x3))) / denominator;
        var ub:Number = (((x2 - x1) * (y1 - y3)) - ((y2 - y1) * (x1 - x3))) / denominator;
        if (ua > 1 || ua < 0 || ub > 1 || ub < 0) {
            return null;
        }
        return new Point(x1 + (ua * (x2 - x1)), y1 + (ua * (y2 - y1)));
    }

    /** Shortest distance from point (px,py) to segment (x1,y1)-(x2,y2). */
    public static function distanceToSegment(px:Number, py:Number, x1:Number, y1:Number, x2:Number, y2:Number):Number {
        var closestX:Number;
        var closestY:Number;
        var t:Number;
        var segmentX:Number = x2 - x1;
        var segmentY:Number = y2 - y1;
        var lengthSquared:Number = (segmentX * segmentX) + (segmentY * segmentY);
        if (lengthSquared < 0.001) {
            closestX = x1;
            closestY = y1;
        } else {
            t = (((px - x1) * segmentX) + ((py - y1) * segmentY)) / lengthSquared;
            if (t < 0) {
                closestX = x1;
                closestY = y1;
            } else {
                if (t > 1) {
                    closestX = x2;
                    closestY = y2;
                } else {
                    closestX = x1 + (t * segmentX);
                    closestY = y1 + (t * segmentY);
                }
            }
        }
        var dx:Number = px - closestX;
        var dy:Number = py - closestY;
        return Math.sqrt((dx * dx) + (dy * dy));
    }

}
}//package com.company.util
