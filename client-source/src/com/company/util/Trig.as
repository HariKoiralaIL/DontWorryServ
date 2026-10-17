package com.company.util {
public class Trig {

    public static const RAD_TO_DEG:Number = 180 / Math.PI;
    public static const DEG_TO_RAD:Number = Math.PI / 180;

    /** Interpolates between two radian angles along the shortest arc. */
    public static function lerpAngle(from:Number, to:Number, t:Number):Number {
        var result:Number = Number.MAX_VALUE;
        if (from > to) {
            if ((from - to) > Math.PI) {
                result = (from * (1 - t)) + ((to + (2 * Math.PI)) * t);
            } else {
                result = (from * (1 - t)) + (to * t);
            }
        } else {
            if ((to - from) > Math.PI) {
                result = ((from + (2 * Math.PI)) * (1 - t)) + (to * t);
            } else {
                result = (from * (1 - t)) + (to * t);
            }
        }
        if (result < -Math.PI || result > Math.PI) {
            result = normalizeRadians(result);
        }
        return result;
    }

    /** Smallest absolute difference between two radian angles. */
    public static function angleDifference(a:Number, b:Number):Number {
        if (a > b) {
            if ((a - b) > Math.PI) {
                return (b + (2 * Math.PI)) - a;
            }
            return a - b;
        }
        if ((b - a) > Math.PI) {
            return (a + (2 * Math.PI)) - b;
        }
        return b - a;
    }

    /** Fast parabolic sine approximation. */
    public static function sin(x:Number):Number {
        var y:Number;
        if (x < -Math.PI || x > Math.PI) {
            x = normalizeRadians(x);
        }
        if (x < 0) {
            y = (1.27323954 * x) + ((0.405284735 * x) * x);
        } else {
            y = (1.27323954 * x) - ((0.405284735 * x) * x);
        }
        if (y < 0) {
            y = (0.225 * ((y * -y) - y)) + y;
        } else {
            y = (0.225 * ((y * y) - y)) + y;
        }
        return y;
    }

    public static function cos(x:Number):Number {
        return sin(x + (Math.PI / 2));
    }

    /** Series-based atan2 approximation (note: argument order is y, x). */
    public static function atan2(y:Number, x:Number):Number {
        var result:Number;
        if (x == 0) {
            if (y < 0) {
                return -Math.PI / 2;
            }
            if (y > 0) {
                return Math.PI / 2;
            }
            return NaN; // original returned undefined
        }
        if (y == 0) {
            if (x < 0) {
                return Math.PI;
            }
            return 0;
        }
        if (((x > 0) ? x : -x) > ((y > 0) ? y : -y)) {
            result = ((x < 0) ? -Math.PI : 0) + atan2Helper(y, x);
        } else {
            result = ((y > 0) ? (Math.PI / 2) : (-Math.PI / 2)) - atan2Helper(x, y);
        }
        if (result < -Math.PI || result > Math.PI) {
            result = normalizeRadians(result);
        }
        return result;
    }

    /** Truncated arctan Taylor series for numerator / denominator. */
    public static function atan2Helper(numerator:Number, denominator:Number):Number {
        var ratio:Number = numerator / denominator;
        var sum:Number = ratio;
        var power:Number = ratio;
        var divisor:Number = 1;
        var sign:int = 1;
        do {
            divisor = divisor + 2;
            sign = (sign > 0) ? -1 : 1;
            power = (power * ratio) * ratio;
            sum = sum + ((sign * power) / divisor);
        } while ((power > 0.01 || power < -0.01) && divisor <= 11);
        return sum;
    }

    /** Wraps radians into [-PI, PI]. */
    public static function normalizeRadians(angle:Number):Number {
        var turns:int;
        if (angle < -Math.PI) {
            turns = (int(angle / -Math.PI) + 1) / 2;
            angle = angle + ((turns * 2) * Math.PI);
        } else {
            if (angle > Math.PI) {
                turns = (int(angle / Math.PI) + 1) / 2;
                angle = angle - ((turns * 2) * Math.PI);
            }
        }
        return angle;
    }

    /** Wraps degrees into [-180, 180]. */
    public static function normalizeDegrees(angle:Number):Number {
        var turns:int;
        if (angle < -180) {
            turns = (int(angle / -180) + 1) / 2;
            angle = angle + (turns * 360);
        } else {
            if (angle > 180) {
                turns = (int(angle / 180) + 1) / 2;
                angle = angle - (turns * 360);
            }
        }
        return angle;
    }

    public static function runUnitTest():Boolean {
        trace("STARTING UNITTEST: Trig");
        var passed:Boolean = testFunc1(Math.sin, sin) && testFunc1(Math.cos, cos) && testFunc2(Math.atan2, atan2);
        if (!passed) {
            trace("Trig Unit Test FAILED!");
        }
        trace("FINISHED UNITTEST: Trig");
        return passed;
    }

    public static function testFunc1(reference:Function, approximation:Function):Boolean {
        var random:Random = new Random();
        var i:int = 0;
        while (i < 1000) {
            var x:Number = ((random.nextInt() % 2000) - 1000) + random.nextDouble();
            var error:Number = Math.abs(reference(x) - approximation(x));
            if (error > 0.1) {
                return false;
            }
            i++;
        }
        return true;
    }

    public static function testFunc2(reference:Function, approximation:Function):Boolean {
        var random:Random = new Random();
        var i:int = 0;
        while (i < 1000) {
            var y:Number = ((random.nextInt() % 2000) - 1000) + random.nextDouble();
            var x:Number = ((random.nextInt() % 2000) - 1000) + random.nextDouble();
            var error:Number = Math.abs(reference(y, x) - approximation(y, x));
            if (error > 0.1) {
                return false;
            }
            i++;
        }
        return true;
    }

    public function Trig(enforcer:StaticEnforcer) {
    }

}
}//package com.company.util

class StaticEnforcer {

}
