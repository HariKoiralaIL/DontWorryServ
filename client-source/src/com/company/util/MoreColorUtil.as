package com.company.util {
import flash.geom.ColorTransform;

public class MoreColorUtil {

    // Color matrices (for ColorMatrixFilter)
    public static const GRAYSCALE_MATRIX:Array = [0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0];
    public static const LUMINANCE_TO_RED_MATRIX:Array = [0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0];

    // Base / alpha
    public static const identity:ColorTransform = new ColorTransform();
    public static const invisible:ColorTransform = new ColorTransform(1, 1, 1, 0, 0, 0, 0, 0);
    public static const ALPHA_30:ColorTransform = new ColorTransform(1, 1, 1, 0.3, 0, 0, 0, 0);
    public static const ALPHA_70:ColorTransform = new ColorTransform(1, 1, 1, 0.7, 0, 0, 0, 0);

    // Green tints
    public static const GREEN_TINT:ColorTransform = new ColorTransform(0.6, 1, 0.6, 1, 0, 0, 0, 0);
    public static const GREEN_TINT_LIGHT:ColorTransform = new ColorTransform(0.8, 1, 0.8, 1, 0, 0, 0, 0);
    public static const GREEN_TINT_STRONG:ColorTransform = new ColorTransform(0.2, 1, 0.2, 1, 0, 100, 0, 0);
    public static const GREEN_TINT_ALPHA_30:ColorTransform = new ColorTransform(0.5, 1, 0.5, 0.3, 0, 0, 0, 0);
    public static const GREEN_TINT_ALPHA_50:ColorTransform = new ColorTransform(0.3, 1, 0.3, 0.5, 0, 0, 0, 0);

    // Red tints
    public static const RED_TINT:ColorTransform = new ColorTransform(1, 0.5, 0.5, 1, 0, 0, 0, 0);
    public static const RED_TINT_LIGHT:ColorTransform = new ColorTransform(1, 0.7, 0.7, 1, 0, 0, 0, 0);
    public static const RED_TINT_STRONG:ColorTransform = new ColorTransform(1, 0.2, 0.2, 1, 100, 0, 0, 0);
    public static const RED_TINT_ALPHA_30:ColorTransform = new ColorTransform(1, 0.5, 0.5, 0.3, 0, 0, 0, 0);
    public static const RED_TINT_ALPHA_50:ColorTransform = new ColorTransform(1, 0.3, 0.3, 0.5, 0, 0, 0, 0);

    // Blue tints
    public static const BLUE_TINT:ColorTransform = new ColorTransform(0.5, 0.5, 1, 1, 0, 0, 0, 0);
    public static const BLUE_TINT_LIGHT:ColorTransform = new ColorTransform(0.7, 0.7, 1, 1, 0, 0, 100, 0);
    public static const BLUE_TINT_STRONG:ColorTransform = new ColorTransform(0.3, 0.3, 1, 1, 0, 0, 100, 0);
    public static const BLUE_TINT_ALPHA_30:ColorTransform = new ColorTransform(0.5, 0.5, 1, 0.3, 0, 0, 0, 0);
    public static const BLUE_TINT_ALPHA_50:ColorTransform = new ColorTransform(0.3, 0.3, 1, 0.5, 0, 0, 0, 0);

    // Magenta tints
    public static const MAGENTA_TINT:ColorTransform = new ColorTransform(1, 0.5, 1, 1, 0, 0, 0, 0);
    public static const MAGENTA_TINT_STRONG:ColorTransform = new ColorTransform(1, 0.2, 1, 1, 100, 0, 100, 0);

    // Gray / white
    public static const GRAY_60:ColorTransform = new ColorTransform(0.6, 0.6, 0.6, 1, 0, 0, 0, 0);
    public static const GRAY_40:ColorTransform = new ColorTransform(0.4, 0.4, 0.4, 1, 0, 0, 0, 0);
    public static const WHITE:ColorTransform = new ColorTransform(1, 1, 1, 1, 0xFF, 0xFF, 0xFF, 0);

    /** hue in degrees, saturation/value in 0..1; returns 0xRRGGBB. */
    public static function hsvToRgb(hue:Number, saturation:Number, value:Number):int {
        var r:Number;
        var g:Number;
        var b:Number;
        var sector:int = int(hue / 60) % 6;
        var fraction:Number = (hue / 60) - Math.floor(hue / 60);
        var p:Number = value * (1 - saturation);
        var q:Number = value * (1 - (fraction * saturation));
        var t:Number = value * (1 - ((1 - fraction) * saturation));
        switch (sector) {
            case 0:
                r = value;
                g = t;
                b = p;
                break;
            case 1:
                r = q;
                g = value;
                b = p;
                break;
            case 2:
                r = p;
                g = value;
                b = t;
                break;
            case 3:
                r = p;
                g = q;
                b = value;
                break;
            case 4:
                r = t;
                g = p;
                b = value;
                break;
            case 5:
                r = value;
                g = p;
                b = q;
                break;
        }
        return (int(Math.min(0xFF, Math.floor(r * 0xFF))) << 16) | (int(Math.min(0xFF, Math.floor(g * 0xFF))) << 8) | int(Math.min(0xFF, Math.floor(b * 0xFF)));
    }

    /** Random 0xRRGGBB (no alpha). */
    public static function randomColor():uint {
        return uint(0xFFFFFF * Math.random());
    }

    /** Random 0xFFRRGGBB. */
    public static function randomColor32():uint {
        return uint(0xFFFFFF * Math.random()) | 0xFF000000;
    }

    /** Applies a ColorTransform's RGB part to a 0xRRGGBB color. */
    public static function applyColorTransform(transform:ColorTransform, color:uint):uint {
        var r:int = (((color & 0xFF0000) >> 16) * transform.redMultiplier) + transform.redOffset;
        var g:int = (((color & 0xFF00) >> 8) * transform.greenMultiplier) + transform.greenOffset;
        var b:int = ((color & 0xFF) * transform.blueMultiplier) + transform.blueOffset;
        return (clampByte(r) << 16) | (clampByte(g) << 8) | clampByte(b);
    }

    public static function cloneColorTransform(source:ColorTransform):ColorTransform {
        return new ColorTransform(source.redMultiplier, source.greenMultiplier, source.blueMultiplier, source.alphaMultiplier, source.redOffset, source.greenOffset, source.blueOffset, source.alphaOffset);
    }

    /** Component-wise blend: a * (1 - t) + b * t. Null counts as identity. */
    public static function lerpColorTransform(a:ColorTransform, b:ColorTransform, t:Number):ColorTransform {
        if (a == null) {
            a = identity;
        }
        if (b == null) {
            b = identity;
        }
        var inverse:Number = 1 - t;
        return new ColorTransform(
                (a.redMultiplier * inverse) + (b.redMultiplier * t),
                (a.greenMultiplier * inverse) + (b.greenMultiplier * t),
                (a.blueMultiplier * inverse) + (b.blueMultiplier * t),
                (a.alphaMultiplier * inverse) + (b.alphaMultiplier * t),
                (a.redOffset * inverse) + (b.redOffset * t),
                (a.greenOffset * inverse) + (b.greenOffset * t),
                (a.blueOffset * inverse) + (b.blueOffset * t),
                (a.alphaOffset * inverse) + (b.alphaOffset * t));
    }

    /** Per-channel ARGB blend between two colors. */
    public static function lerpColor(colorA:uint, colorB:uint, t:Number):uint {
        var inverse:Number = 1 - t;
        var aA:uint = (colorA >> 24) & 0xFF;
        var rA:uint = (colorA >> 16) & 0xFF;
        var gA:uint = (colorA >> 8) & 0xFF;
        var bA:uint = colorA & 0xFF;
        var aB:uint = (colorB >> 24) & 0xFF;
        var rB:uint = (colorB >> 16) & 0xFF;
        var gB:uint = (colorB >> 8) & 0xFF;
        var bB:uint = colorB & 0xFF;
        var a:uint = (aA * inverse) + (aB * t);
        var r:uint = (rA * inverse) + (rB * t);
        var g:uint = (gA * inverse) + (gB * t);
        var b:uint = (bA * inverse) + (bB * t);
        return (a << 24) | (r << 16) | (g << 8) | b;
    }

    /** Alpha (0..1) after applying the transform's alpha multiplier/offset. */
    public static function transformAlpha(transform:ColorTransform, alpha:Number):Number {
        var scaled:uint = alpha * 0xFF;
        var result:uint = (scaled * transform.alphaMultiplier) + transform.alphaOffset;
        result = (result < 0) ? 0 : ((result > 0xFF) ? 0xFF : result);
        return result / 0xFF;
    }

    /** Multiplies each RGB channel by factor (clamped); alpha is dropped. */
    public static function multiplyColor(color:uint, factor:Number):uint {
        var r:int = ((color & 0xFF0000) >> 16) * factor;
        var g:int = ((color & 0xFF00) >> 8) * factor;
        var b:int = (color & 0xFF) * factor;
        return (clampByte(r) << 16) | (clampByte(g) << 8) | clampByte(b);
    }

    /** Adds amount * 255 to each RGB channel (clamped); alpha is kept. */
    public static function offsetColor(color:uint, amount:Number):uint {
        var alpha:uint = color & 0xFF000000;
        var r:int = ((color & 0xFF0000) >> 16) + (amount * 0xFF);
        var g:int = ((color & 0xFF00) >> 8) + (amount * 0xFF);
        var b:int = (color & 0xFF) + (amount * 0xFF);
        return alpha | (clampByte(r) << 16) | (clampByte(g) << 8) | clampByte(b);
    }

    /** [r, g, b, a] with RGB premultiplied by alpha, each in 0..1. */
    public static function toPremultipliedArray(color:uint):Array {
        var alpha:Number = ((color >> 24) & 0xFF) / 0x0100;
        return [
            alpha * (((color >> 16) & 0xFF) / 0x0100),
            alpha * (((color >> 8) & 0xFF) / 0x0100),
            alpha * ((color & 0xFF) / 0x0100),
            alpha];
    }

    public static function toGrayscale(color:uint):uint {
        var luminance:uint = ((((color & 0xFF0000) >> 16) * 0.3) + (((color & 0xFF00) >> 8) * 0.59)) + ((color & 0xFF) * 0.11);
        return ((color && 0xFF000000) | (luminance << 16)) | (luminance << 8) | luminance;
    }

    /** ColorMatrixFilter matrix that paints everything in a single solid color (alpha kept). */
    public static function solidColorMatrix(color:uint):Array {
        return [0, 0, 0, 0, ((color & 0xFF0000) >> 16), 0, 0, 0, 0, ((color & 0xFF00) >> 8), 0, 0, 0, 0, (color & 0xFF), 0, 0, 0, 1, 0];
    }

    private static function clampByte(value:int):int {
        return (value < 0) ? 0 : ((value > 0xFF) ? 0xFF : value);
    }

    public function MoreColorUtil(enforcer:StaticEnforcer) {
    }

}
}//package com.company.util

class StaticEnforcer {

}
