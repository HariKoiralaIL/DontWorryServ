package com.company.util {
import flash.display.CapsStyle;
import flash.display.GraphicsEndFill;
import flash.display.GraphicsPath;
import flash.display.GraphicsPathCommand;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.geom.Matrix;

public class GraphicHelper {

    public static const END_FILL:GraphicsEndFill = new GraphicsEndFill();
    public static const RECT_COMMANDS:Vector.<int> = new <int>[GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO];
    public static const DEBUG_STROKE:GraphicsStroke = new GraphicsStroke(1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, new GraphicsSolidFill(0xFF0000));
    public static const NO_STROKE:GraphicsStroke = new GraphicsStroke();
    public static const ALL_CORNERS:Array = [true, true, true, true];
    private static const TWO_PI:Number = 2 * Math.PI;

    public static function clearPath(path:GraphicsPath):void {
        path.commands.length = 0;
        path.data.length = 0;
    }

    public static function createRectPath(x:int, y:int, width:int, height:int):GraphicsPath {
        return new GraphicsPath(RECT_COMMANDS, new <Number>[x, y, x + width, y, x + width, y + height, x, y + height]);
    }

    public static function createGradientMatrix(width:Number, height:Number, rotation:Number = 0, tx:Number = 0, ty:Number = 0):Matrix {
        var matrix:Matrix = new Matrix();
        matrix.createGradientBox(width, height, rotation, tx, ty);
        return matrix;
    }

    public static function drawRect(x:int, y:int, width:int, height:int, path:GraphicsPath):void {
        path.moveTo(x, y);
        path.lineTo(x + width, y);
        path.lineTo(x + width, y + height);
        path.lineTo(x, y + height);
    }

    /** Approximates a circle with `segments` quadratic curves. */
    public static function drawCircle(centerX:Number, centerY:Number, radius:Number, path:GraphicsPath, segments:int = 8):void {
        var controlScale:Number = 1 + (1 / (segments * 1.75));
        path.moveTo(centerX + radius, centerY);
        var i:int = 1;
        while (i <= segments) {
            var angle:Number = (TWO_PI * i) / segments;
            var controlAngle:Number = (TWO_PI * (i - 0.5)) / segments;
            var endX:Number = centerX + (radius * Math.cos(angle));
            var endY:Number = centerY + (radius * Math.sin(angle));
            var controlX:Number = centerX + ((radius * controlScale) * Math.cos(controlAngle));
            var controlY:Number = centerY + ((radius * controlScale) * Math.sin(controlAngle));
            path.curveTo(controlX, controlY, endX, endY);
            i++;
        }
    }

    /** Rect with optional chamfered corners; corner order: TL, TR, BR, BL. */
    public static function drawUI(x:int, y:int, width:int, height:int, cornerRadius:int, corner:Array, data:GraphicsPath):void {
        if (corner[0] != 0) {
            data.moveTo(x, y + cornerRadius);
            data.lineTo(x + cornerRadius, y);
        } else {
            data.moveTo(x, y);
        }
        if (corner[1] != 0) {
            data.lineTo((x + width) - cornerRadius, y);
            data.lineTo(x + width, y + cornerRadius);
        } else {
            data.lineTo(x + width, y);
        }
        if (corner[2] != 0) {
            data.lineTo(x + width, (y + height) - cornerRadius);
            data.lineTo((x + width) - cornerRadius, y + height);
        } else {
            data.lineTo(x + width, y + height);
        }
        if (corner[3] != 0) {
            data.lineTo(x + cornerRadius, y + height);
            data.lineTo(x, (y + height) - cornerRadius);
        } else {
            data.lineTo(x, y + height);
        }
        if (corner[0] != 0) {
            data.lineTo(x, y + cornerRadius);
        } else {
            data.lineTo(x, y);
        }
    }

    public static function drawSpacer(x:Number, y:Number, cornerRadius:Number, data:GraphicsPath):void {
        data.moveTo(x, y - cornerRadius);
        data.lineTo(x + cornerRadius, y);
        data.lineTo(x, y + cornerRadius);
        data.lineTo(x - cornerRadius, y);
    }

    public static function darkenColor(hexColor:Number, percent:Number):Number {
        if (isNaN(percent)) {
            percent = 0;
        }
        if (percent > 100) {
            percent = 100;
        }
        if (percent < 0) {
            percent = 0;
        }
        var factor:Number = 1 - (percent / 100);
        var rgb:Object = hexToRgb(hexColor);
        rgb.r *= factor;
        rgb.b *= factor;
        rgb.g *= factor;
        return rgbToHex(Math.round(rgb.r), Math.round(rgb.g), Math.round(rgb.b));
    }

    public static function rgbToHex(r:Number, g:Number, b:Number):Number {
        return (r << 16) | (g << 8) | b;
    }

    public static function hexToRgb(hex:Number):Object {
        return {r: (hex & 0xFF0000) >> 16, g: (hex & 0x00FF00) >> 8, b: hex & 0x0000FF};
    }

}
}//package com.company.util
