package com.company.util {
public class Random {

    public static function randomSeed():uint {
        return Math.round((Math.random() * (uint.MAX_VALUE - 1)) + 1);
    }

    public function Random(seed:uint = 1) {
        this.seed = seed;
    }

    public var seed:uint;

    public function nextInt():uint {
        return this.next();
    }

    /** Uniform in [0, 1]. */
    public function nextDouble():Number {
        return this.next() / 2147483647;
    }

    /** Box-Muller normal distribution. */
    public function nextGaussian(mean:Number = 0, stdDev:Number = 1):Number {
        var u1:Number = this.next() / 2147483647;
        var u2:Number = this.next() / 2147483647;
        var z:Number = Math.sqrt(-2 * Math.log(u1)) * Math.cos((2 * u2) * Math.PI);
        return mean + (z * stdDev);
    }

    public function nextIntInRange(min:uint, max:uint):uint {
        return (min == max) ? min : (min + (this.next() % (max - min)));
    }

    public function nextDoubleInRange(min:Number, max:Number):Number {
        return min + ((max - min) * this.nextDouble());
    }

    /** Park-Miller LCG (multiplier 16807, modulus 2^31 - 1). */
    private function next():uint {
        var high:uint;
        var low:uint;
        low = 16807 * (this.seed & 0xFFFF);
        high = 16807 * (this.seed >> 16);
        low = low + ((high & 32767) << 16);
        low = low + (high >> 15);
        if (low > 2147483647) {
            low = low - 2147483647;
        }
        return (this.seed = low);
    }

}
}//package com.company.util
