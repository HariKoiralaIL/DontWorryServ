package easing {

/**
 * Sine easing functions.
 *
 * All functions share the usual four-parameter easing signature
 * (t, b, c, d) so they can be passed around as tween easing callbacks,
 * but only `t` is used: it is the normalized progress, 0 (start) to 1 (end),
 * and the result is the eased progress in the same range. `b`, `c` and `d`
 * are ignored.
 */
public class SineEase {

    public static function easeIn(t:Number, b:Number, c:Number, d:Number):Number {
        return 1 - Math.cos(t * (Math.PI / 2));
    }

    public static function easeOut(t:Number, b:Number, c:Number, d:Number):Number {
        return Math.sin(t * (Math.PI / 2));
    }

    public static function easeInOut(t:Number, b:Number, c:Number, d:Number):Number {
        return -0.5 * (Math.cos(t * Math.PI) - 1);
    }

}
}
