package com.company.util {
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Vector3D;

public class ConversionUtil {

    public static function toIntArray(value:Object, separator:String = ","):Array {
        if (value == null) {
            return [];
        }
        return value.toString().split(separator).map(mapParseInt);
    }

    public static function toFloatArray(value:Object, separator:String = ","):Array {
        if (value == null) {
            return [];
        }
        return value.toString().split(separator).map(mapParseFloat);
    }

    public static function toIntVector(value:Object, separator:String = ","):Vector.<int> {
        if (value == null) {
            return new Vector.<int>();
        }
        return Vector.<int>(value.toString().split(separator).map(mapParseInt));
    }

    public static function toNumberVector(value:Object, separator:String = ","):Vector.<Number> {
        if (value == null) {
            return new Vector.<Number>();
        }
        return Vector.<Number>(value.toString().split(separator).map(mapParseFloat));
    }

    public static function toStringArray(value:Object, separator:String = ","):Array {
        if (value == null) {
            return [];
        }
        return value.toString().split(separator);
    }

    public static function toRectangle(value:Object, separator:String = ","):Rectangle {
        if (value == null) {
            return new Rectangle();
        }
        var parts:Array = value.toString().split(separator).map(mapParseFloat);
        return (parts == null || parts.length < 4) ? new Rectangle() : new Rectangle(parts[0], parts[1], parts[2], parts[3]);
    }

    public static function toPoint(value:Object, separator:String = ","):Point {
        if (value == null) {
            return new Point();
        }
        var parts:Array = value.toString().split(separator).map(ConversionUtil.mapParseFloat);
        return (parts == null || parts.length < 2) ? new Point() : new Point(parts[0], parts[1]);
    }

    /** "x1,y1,x2,y2" -> [Point, Point] (zeroed points on bad input). */
    public static function toPointPair(value:Object, separator:String = ","):Array {
        var result:Array = [];
        if (value == null) {
            result.push(new Point());
            result.push(new Point());
            return result;
        }
        var parts:Array = value.toString().split(separator).map(ConversionUtil.mapParseFloat);
        if (parts == null || parts.length < 4) {
            result.push(new Point());
            result.push(new Point());
            return result;
        }
        result.push(new Point(parts[0], parts[1]));
        result.push(new Point(parts[2], parts[3]));
        return result;
    }

    public static function toVector3D(value:Object, separator:String = ","):Vector3D {
        if (value == null) {
            return new Vector3D();
        }
        var parts:Array = value.toString().split(separator).map(ConversionUtil.mapParseFloat);
        return (parts == null || parts.length < 3) ? new Vector3D() : new Vector3D(parts[0], parts[1], parts[2]);
    }

    /** Maps each token to its first character code. */
    public static function toCharCodeVector(value:Object, separator:String = ","):Vector.<int> {
        if (value == null) {
            return new Vector.<int>();
        }
        return Vector.<int>(value.toString().split(separator).map(mapCharCode));
    }

    public static function appendToNumberVector(value:Object, target:Vector.<Number>, separator:String = ","):void {
        if (value == null) {
            return;
        }
        var parts:Array = value.toString().split(separator).map(mapParseFloat);
        for each (var number:Number in parts) {
            target.push(number);
        }
    }

    /** Note: parses tokens as floats, then truncates on push (original behavior). */
    public static function appendToIntVector(value:Object, target:Vector.<int>, separator:String = ","):void {
        if (value == null) {
            return;
        }
        var parts:Array = value.toString().split(separator).map(mapParseFloat);
        for each (var number:int in parts) {
            target.push(number);
        }
    }

    public static function mapParseFloat(item:*, ...rest):Number {
        return parseFloat(item);
    }

    public static function mapParseInt(item:*, ...rest):Number {
        return parseInt(item);
    }

    public static function mapCharCode(item:*, ...rest):Number {
        return String(item).charCodeAt();
    }

    public static function vector3DToArray(vector:Vector3D):Array {
        return [vector.x, vector.y, vector.z];
    }

    public function ConversionUtil(enforcer:StaticEnforcer) {
    }

}
}//package com.company.util

class StaticEnforcer {

}
