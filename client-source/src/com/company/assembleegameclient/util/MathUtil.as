package com.company.assembleegameclient.util {

public class MathUtil {

    private static const SECONDS_PER_DAY:int = 60 * 60 * 24;

    /** Returns a random number in the range [-range, range). */
    public static function randomSpread(range:Number):Number {
        return Math.random() * range * 2 - range;
    }

    /** Converts a duration in seconds to a number of days, rounded up. */
    public static function secondsToDaysCeil(seconds:Number):int {
        return Math.ceil(seconds / SECONDS_PER_DAY);
    }

}
}
