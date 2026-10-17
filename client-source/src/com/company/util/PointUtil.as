package com.company.util {
import flash.geom.Point;

public class PointUtil {

    public static const ORIGIN:Point = new Point(0, 0);

    public static function roundPoint(point:Point):Point {
        var result:Point = point.clone();
        result.x = Math.round(result.x);
        result.y = Math.round(result.y);
        return result;
    }

    public static function distanceSquared(a:Point, b:Point):Number {
        return distanceSquaredXY(a.x, a.y, b.x, b.y);
    }

    public static function distanceSquaredXY(x1:Number, y1:Number, x2:Number, y2:Number):Number {
        var dx:Number = x2 - x1;
        var dy:Number = y2 - y1;
        return (dx * dx) + (dy * dy);
    }

    public static function distanceXY(x1:Number, y1:Number, x2:Number, y2:Number):Number {
        var dx:Number = x2 - x1;
        var dy:Number = y2 - y1;
        return Math.sqrt((dx * dx) + (dy * dy));
    }

    /** Linear interpolation between (x1,y1) and (x2,y2). */
    public static function lerp(x1:Number, y1:Number, x2:Number, y2:Number, t:Number):Point {
        return new Point(x1 + ((x2 - x1) * t), y1 + ((y2 - y1) * t));
    }

    public static function angleBetween(from:Point, to:Point):Number {
        return Math.atan2(to.y - from.y, to.x - from.x);
    }

    public static function pointAtAngle(origin:Point, angle:Number, distance:Number):Point {
        var result:Point = new Point();
        result.x = origin.x + (distance * Math.cos(angle));
        result.y = origin.y + (distance * Math.sin(angle));
        return result;
    }

    public function PointUtil(enforcer:StaticEnforcer) {
    }

}
}//package com.company.util

class StaticEnforcer {

}
