package com.company.util {
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

public class BitmapUtil {

    /** Horizontally flips the first mirrorWidth columns (0 = whole width). */
    public static function mirror(source:BitmapData, mirrorWidth:int = 0):BitmapData {
        if (mirrorWidth == 0) {
            mirrorWidth = source.width;
        }
        var result:BitmapData = new BitmapData(source.width, source.height, true, 0);
        var x:int = 0;
        while (x < mirrorWidth) {
            var y:int = 0;
            while (y < source.height) {
                result.setPixel32((mirrorWidth - x) - 1, y, source.getPixel32(x, y));
                y++;
            }
            x++;
        }
        return result;
    }

    /** Rotates by quarterTurns * 90 degrees; output dimensions are swapped. */
    public static function rotate90(source:BitmapData, quarterTurns:int):BitmapData {
        var matrix:Matrix = new Matrix();
        matrix.translate(-source.width / 2, -source.height / 2);
        matrix.rotate((quarterTurns * Math.PI) / 2);
        matrix.translate(source.height / 2, source.width / 2);
        var result:BitmapData = new BitmapData(source.height, source.width, true, 0);
        result.draw(source, matrix);
        return result;
    }

    public static function crop(source:BitmapData, x:int, y:int, width:int, height:int):BitmapData {
        var result:BitmapData = new BitmapData(width, height);
        result.copyPixels(source, new Rectangle(x, y, width, height), new Point(0, 0));
        return result;
    }

    /** Fraction (0..1) of pixels with alpha == 0. */
    public static function getTransparentFraction(source:BitmapData):Number {
        var transparentCount:int = 0;
        var x:int = 0;
        while (x < source.width) {
            var y:int = 0;
            while (y < source.height) {
                var alpha:int = source.getPixel32(x, y) & 0xFF000000;
                if (alpha == 0) {
                    transparentCount++;
                }
                y++;
            }
            x++;
        }
        return transparentCount / (source.width * source.height);
    }

    /** Most frequent non-transparent color; ties go to the larger color value. */
    public static function getDominantColor(source:BitmapData):uint {
        var color:uint;
        var counts:Dictionary = new Dictionary();
        var x:int = 0;
        while (x < source.width) {
            var y:int = 0;
            while (y < source.width) { // NOTE: bound is width (not height) in the original
                color = source.getPixel32(x, y);
                if ((color & 0xFF000000) != 0) {
                    if (!counts.hasOwnProperty(String(color))) {
                        counts[color] = 1;
                    } else {
                        counts[color] = counts[color] + 1;
                    }
                }
                y++;
            }
            x++;
        }
        var bestColor:uint = 0;
        var bestCount:uint = 0;
        for (var key:String in counts) {
            color = uint(key);
            var count:int = counts[key];
            if (count > bestCount || (count == bestCount && color > bestColor)) {
                bestColor = color;
                bestCount = count;
            }
        }
        return bestColor;
    }

    /**
     * Walks a Bresenham line between two points; returns false as soon as it
     * hits a pixel whose RGB is 0, true if the whole (clipped) line is filled.
     */
    public static function isLineFilled(bitmapData:BitmapData, from:IntPoint, to:IntPoint):Boolean {
        var tmp:int;
        var width:int = bitmapData.width;
        var height:int = bitmapData.height;
        var x0:int = from.x();
        var y0:int = from.y();
        var x1:int = to.x();
        var y1:int = to.y();
        var steep:Boolean = ((y0 > y1) ? (y0 - y1) : (y1 - y0)) > ((x0 > x1) ? (x0 - x1) : (x1 - x0));
        if (steep) {
            tmp = x0; x0 = y0; y0 = tmp;
            tmp = x1; x1 = y1; y1 = tmp;
            tmp = width; width = height; height = tmp;
        }
        if (x0 > x1) {
            tmp = x0; x0 = x1; x1 = tmp;
            tmp = y0; y0 = y1; y1 = tmp;
        }
        var dx:int = x1 - x0;
        var dy:int = (y0 > y1) ? (y0 - y1) : (y1 - y0);
        var error:int = -(dx + 1) / 2;
        var yStep:int = (y0 > y1) ? -1 : 1;
        var xEnd:int = (x1 > (width - 1)) ? (width - 1) : x1;
        var y:int = y0;
        var x:int = x0;
        var steps:int;
        if (x < 0) {
            error = error + (dy * -x);
            if (error >= 0) {
                steps = (error / dx) + 1;
                y = y + (yStep * steps);
                error = error - (steps * dx);
            }
            x = 0;
        }
        if ((yStep > 0 && y < 0) || (yStep < 0 && y >= height)) {
            var yClip:int = (yStep > 0) ? (-y - 1) : (y - height);
            error = error - (dx * yClip);
            var xSkip:int = -error / dy;
            x = x + xSkip;
            error = error + (xSkip * dy);
            y = y + (yClip * yStep);
        }
        while (x <= xEnd) {
            if ((yStep > 0 && y >= height) || (yStep < 0 && y < 0)) {
                break;
            }
            if (steep) {
                if (y >= 0 && y < height && bitmapData.getPixel(y, x) == 0) {
                    return false;
                }
            } else {
                if (y >= 0 && y < height && bitmapData.getPixel(x, y) == 0) {
                    return false;
                }
            }
            error = error + dy;
            if (error >= 0) {
                y = y + yStep;
                error = error - dx;
            }
            x++;
        }
        return true;
    }

    public function BitmapUtil(enforcer:StaticEnforcer) {
    }

}
}//package com.company.util

class StaticEnforcer {

}
