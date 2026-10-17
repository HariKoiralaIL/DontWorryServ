package client.util.color {
import com.company.util.MoreColorUtil;

/**
 * Colour in HSV space: hue in degrees (0-359), saturation and value from 0 to 1.
 * Constructor arguments are clamped to those ranges.
 */
public class HSV {

    public var h:Number;
    public var s:Number;
    public var v:Number;

    public function HSV(h:Number = 0, s:Number = 0, v:Number = 0) {
        this.h = Math.max(0, Math.min(359, int(h)));
        this.s = Math.max(0, Math.min(1, s));
        this.v = Math.max(0, Math.min(1, v));
    }

    public static function random():HSV {
        var rgb:RGB = RGB.fromHex(MoreColorUtil.randomColor());
        return rgb.toHSV();
    }

    public function clone():HSV {
        return new HSV(h, s, v);
    }

    public function equals(other:HSV):Boolean {
        return other != null && h == other.h && s == other.s && v == other.v;
    }

    public function toRGB():RGB {
        var r:Number;
        var g:Number;
        var b:Number;
        var sector:int = int(h / 60) % 6;
        var fraction:Number = h / 60 - Math.floor(h / 60);
        var p:Number = v * (1 - s);
        var q:Number = v * (1 - fraction * s);
        var t:Number = v * (1 - (1 - fraction) * s);
        switch (sector) {
            case 0:
                r = v;
                g = t;
                b = p;
                break;
            case 1:
                r = q;
                g = v;
                b = p;
                break;
            case 2:
                r = p;
                g = v;
                b = t;
                break;
            case 3:
                r = p;
                g = q;
                b = v;
                break;
            case 4:
                r = t;
                g = p;
                b = v;
                break;
            case 5:
                r = v;
                g = p;
                b = q;
                break;
        }
        return new RGB(r, g, b);
    }

    public function toString():String {
        return "HSV(" + h + ", " + s + ", " + v + ")";
    }

}
}
