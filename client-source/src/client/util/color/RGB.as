package client.util.color {

/**
 * Colour in RGB space with each channel from 0 to 1.
 * Constructor arguments are clamped to that range.
 */
public class RGB {

    public var r:Number;
    public var g:Number;
    public var b:Number;

    /** Creates an RGB colour from a 0xRRGGBB value. */
    public static function fromHex(hex:uint):RGB {
        return new RGB(((hex >> 16) & 0xFF) / 0xFF, ((hex >> 8) & 0xFF) / 0xFF, (hex & 0xFF) / 0xFF);
    }

    private static function toByte(channel:Number):int {
        return int(Math.min(0xFF, Math.floor(channel * 0xFF)));
    }

    private static function toHexPair(value:int):String {
        return value <= 15 ? "0" + value.toString(16) : value.toString(16);
    }

    public function RGB(r:Number, g:Number, b:Number) {
        this.r = Math.max(0, Math.min(1, r));
        this.g = Math.max(0, Math.min(1, g));
        this.b = Math.max(0, Math.min(1, b));
    }

    public function toHSV():HSV {
        var hue:Number;
        var min:Number = Math.min(r, g, b);
        var max:Number = Math.max(r, g, b);
        var delta:Number = max - min;
        if (max == 0) {
            return new HSV(0, 0, 0);
        }
        var saturation:Number = delta / max;
        if (r == max) {
            hue = (g - b) / delta;
        } else if (g == max) {
            hue = 2 + (b - r) / delta;
        } else {
            hue = 4 + (r - g) / delta;
        }
        hue *= 60;
        if (hue < 0) {
            hue += 360;
        }
        return new HSV(hue, saturation, max);
    }

    /** Returns the colour as a 0xRRGGBB value. */
    public function toHex():uint {
        return (toByte(r) << 16) | (toByte(g) << 8) | toByte(b);
    }

    /** Returns the colour as a six-digit hex string without a prefix, e.g. "ff0070". */
    public function toString():String {
        return toHexPair(toByte(r)) + toHexPair(toByte(g)) + toHexPair(toByte(b));
    }

}
}
