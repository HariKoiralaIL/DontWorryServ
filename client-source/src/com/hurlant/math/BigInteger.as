package com.hurlant.math {
import com.hurlant.crypto.prng.Random;
import com.hurlant.util.Hex;
import com.hurlant.util.Memory;

import flash.utils.ByteArray;

use namespace bi_internal;

/**
 * Arbitrary-precision integer (port of jsbn). Digits are DB-bit limbs in `a`,
 * `t` is the limb count and `s` the sign extension (0 or -1).
 */
public class BigInteger {

    public static const DB:int = 30; // number of significant bits per chunk
    public static const DV:int = (1 << DB);
    public static const DM:int = (DV - 1); // Max value in a chunk

    public static const BI_FP:int = 52;
    public static const FV:Number = Math.pow(2, BI_FP);
    public static const F1:int = (BI_FP - DB); // 22
    public static const F2:int = ((2 * DB) - BI_FP); // 8

    public static const ZERO:BigInteger = nbv(0);
    public static const ONE:BigInteger = nbv(1);

    /** Primes below 512, used for trial division. */
    public static const lowprimes:Array = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509];
    public static const lplim:int = ((1 << 26) / lowprimes[(lowprimes.length - 1)]);

    /** Creates a BigInteger from a small int. */
    public static function nbv(value:int):BigInteger {
        var bn:BigInteger = new BigInteger();
        bn.fromInt(value);
        return bn;
    }

    public function BigInteger(value:* = null, radix:int = 0, unsigned:Boolean = false) {
        var array:ByteArray;
        var length:int;
        super();
        a = [];
        if (value is String) {
            if (radix && radix != 16) {
                throw new Error("BigInteger construction with radix!=16 is not supported.");
            }
            value = Hex.toArray(value);
            radix = 0;
        }
        if (value is ByteArray) {
            array = (value as ByteArray);
            length = (radix || (array.length - array.position));
            fromArray(array, length, unsigned);
        }
    }

    /** Number of limbs in use. */
    public var t:int;

    /** Overwrites the limbs with random bytes before releasing them. */
    public function dispose():void {
        var random:Random = new Random();
        var i:uint = 0;
        while (i < a.length) {
            a[i] = random.nextByte();
            delete a[i];
            i++;
        }
        a = null;
        t = 0;
        s = 0;
        Memory.gc();
    }

    public function toString(radix:Number = 16):String {
        var k:int;
        if (s < 0) {
            return "-" + negate().toString(radix);
        }
        switch (radix) {
            case 2:
                k = 1;
                break;
            case 4:
                k = 2;
                break;
            case 8:
                k = 3;
                break;
            case 16:
                k = 4;
                break;
            case 32:
                k = 5;
                break;
        }
        var km:int = (1 << k) - 1;
        var d:int = 0;
        var m:Boolean = false;
        var r:String = "";
        var i:int = t;
        var p:int = DB - ((i * DB) % k);
        if (i-- > 0) {
            if (p < DB && (d = (a[i] >> p)) > 0) {
                m = true;
                r = d.toString(36);
            }
            while (i >= 0) {
                if (p < k) {
                    d = (a[i] & ((1 << p) - 1)) << (k - p);
                    p += DB - k;
                    d |= a[--i] >> p;
                } else {
                    p -= k;
                    d = (a[i] >> p) & km;
                    if (p <= 0) {
                        p += DB;
                        i--;
                    }
                }
                if (d > 0) {
                    m = true;
                }
                if (m) {
                    r += d.toString(36);
                }
            }
        }
        return m ? r : "0";
    }

    /** Writes the magnitude as big-endian bytes; returns the byte count. */
    public function toArray(array:ByteArray):uint {
        var k:int = 8;
        var km:int = (1 << 8) - 1;
        var d:int = 0;
        var i:int = t;
        var p:int = DB - ((i * DB) % k);
        var m:Boolean = false;
        var c:int = 0;
        if (i-- > 0) {
            if (p < DB && (d = (a[i] >> p)) > 0) {
                m = true;
                array.writeByte(d);
                c++;
            }
            while (i >= 0) {
                if (p < k) {
                    d = (a[i] & ((1 << p) - 1)) << (k - p);
                    p += DB - k;
                    d |= a[--i] >> p;
                } else {
                    p -= k;
                    d = (a[i] >> p) & km;
                    if (p <= 0) {
                        p += DB;
                        i--;
                    }
                }
                if (d > 0) {
                    m = true;
                }
                if (m) {
                    array.writeByte(d);
                    c++;
                }
            }
        }
        return c;
    }

    public function valueOf():Number {
        if (s == -1) {
            return -negate().valueOf();
        }
        var coef:Number = 1;
        var value:Number = 0;
        var i:uint = 0;
        while (i < t) {
            value += a[i] * coef;
            coef *= DV;
            i++;
        }
        return value;
    }

    /** -this */
    public function negate():BigInteger {
        var r:BigInteger = nbi();
        ZERO.subTo(this, r);
        return r;
    }

    public function abs():BigInteger {
        return (s < 0) ? negate() : this;
    }

    /** Returns <0, 0 or >0. */
    public function compareTo(v:BigInteger):int {
        var r:int = s - v.s;
        if (r != 0) {
            return r;
        }
        var i:int = t;
        r = i - v.t;
        if (r != 0) {
            return r;
        }
        while (--i >= 0) {
            r = a[i] - v.a[i];
            if (r != 0) {
                return r;
            }
        }
        return 0;
    }

    /** Number of bits in the minimal two's-complement representation, excluding sign. */
    public function bitLength():int {
        if (t <= 0) {
            return 0;
        }
        return (DB * (t - 1)) + nbits(a[t - 1] ^ (s & DM));
    }

    /** this mod v (result always non-negative for positive v). */
    public function mod(v:BigInteger):BigInteger {
        var r:BigInteger = nbi();
        abs().divRemTo(v, null, r);
        if (s < 0 && r.compareTo(ZERO) > 0) {
            v.subTo(r, r);
        }
        return r;
    }

    /** this^e mod m for a small int exponent. */
    public function modPowInt(e:int, m:BigInteger):BigInteger {
        var reduction:IReduction;
        if (e < 256 || m.isEven()) {
            reduction = new ClassicReduction(m);
        } else {
            reduction = new MontgomeryReduction(m);
        }
        return exp(e, reduction);
    }

    public function clone():BigInteger {
        var r:BigInteger = new BigInteger();
        copyTo(r);
        return r;
    }

    public function intValue():int {
        if (s < 0) {
            if (t == 1) {
                return a[0] - DV;
            }
            if (t == 0) {
                return -1;
            }
        } else {
            if (t == 1) {
                return a[0];
            }
            if (t == 0) {
                return 0;
            }
        }
        // assumes 16 < DB < 32
        return ((a[1] & ((1 << (32 - DB)) - 1)) << DB) | a[0];
    }

    public function byteValue():int {
        return (t == 0) ? s : ((a[0] << 24) >> 24);
    }

    public function shortValue():int {
        return (t == 0) ? s : ((a[0] << 16) >> 16);
    }

    /** -1, 0 or 1. */
    public function signum():int {
        if (s < 0) {
            return -1;
        }
        if (t <= 0 || (t == 1 && a[0] <= 0)) {
            return 0;
        }
        return 1;
    }

    /** Two's-complement big-endian bytes. */
    public function toByteArray():ByteArray {
        var i:int = t;
        var r:ByteArray = new ByteArray();
        r[0] = s;
        var p:int = DB - ((i * DB) % 8);
        var d:int;
        var k:int = 0;
        if (i-- > 0) {
            if (p < DB && (d = (a[i] >> p)) != ((s & DM) >> p)) {
                r[k++] = d | (s << (DB - p));
            }
            while (i >= 0) {
                if (p < 8) {
                    d = (a[i] & ((1 << p) - 1)) << (8 - p);
                    p += DB - 8;
                    d |= a[--i] >> p;
                } else {
                    p -= 8;
                    d = (a[i] >> p) & 0xFF;
                    if (p <= 0) {
                        p += DB;
                        i--;
                    }
                }
                if ((d & 128) != 0) {
                    d |= -256;
                }
                if (k == 0 && (s & 128) != (d & 128)) {
                    k++;
                }
                if (k > 0 || d != s) {
                    r[k++] = d;
                }
            }
        }
        return r;
    }

    public function equals(v:BigInteger):Boolean {
        return compareTo(v) == 0;
    }

    public function min(v:BigInteger):BigInteger {
        return (compareTo(v) < 0) ? this : v;
    }

    public function max(v:BigInteger):BigInteger {
        return (compareTo(v) > 0) ? this : v;
    }

    public function and(v:BigInteger):BigInteger {
        var r:BigInteger = new BigInteger();
        bitwiseTo(v, op_and, r);
        return r;
    }

    public function or(v:BigInteger):BigInteger {
        var r:BigInteger = new BigInteger();
        bitwiseTo(v, op_or, r);
        return r;
    }

    public function xor(v:BigInteger):BigInteger {
        var r:BigInteger = new BigInteger();
        bitwiseTo(v, op_xor, r);
        return r;
    }

    public function andNot(v:BigInteger):BigInteger {
        var r:BigInteger = new BigInteger();
        bitwiseTo(v, op_andnot, r);
        return r;
    }

    public function not():BigInteger {
        var r:BigInteger = new BigInteger();
        var i:int = 0;
        while (i < t) {
            r.a[i] = DM & ~a[i]; // original wrote r[i] (a runtime error on a non-dynamic class)
            i++;
        }
        r.t = t;
        r.s = ~s;
        return r;
    }

    public function shiftLeft(n:int):BigInteger {
        var r:BigInteger = new BigInteger();
        if (n < 0) {
            rShiftTo(-n, r);
        } else {
            lShiftTo(n, r);
        }
        return r;
    }

    public function shiftRight(n:int):BigInteger {
        var r:BigInteger = new BigInteger();
        if (n < 0) {
            lShiftTo(-n, r);
        } else {
            rShiftTo(n, r);
        }
        return r;
    }

    /** Index of the lowest set bit, or -1 if this is 0. */
    public function getLowestSetBit():int {
        var i:int = 0;
        while (i < t) {
            if (a[i] != 0) {
                return (i * DB) + lbit(a[i]);
            }
            i++;
        }
        if (s < 0) {
            return t * DB;
        }
        return -1;
    }

    /** Number of set bits. */
    public function bitCount():int {
        var r:int = 0;
        var x:int = s & DM;
        var i:int = 0;
        while (i < t) {
            r += cbit(a[i] ^ x);
            i++;
        }
        return r;
    }

    public function testBit(n:int):Boolean {
        var j:int = Math.floor(n / DB);
        if (j >= t) {
            return s != 0;
        }
        return (a[j] & (1 << (n % DB))) != 0;
    }

    public function setBit(n:int):BigInteger {
        return changeBit(n, op_or);
    }

    public function clearBit(n:int):BigInteger {
        return changeBit(n, op_andnot);
    }

    public function flipBit(n:int):BigInteger {
        return changeBit(n, op_xor);
    }

    public function add(v:BigInteger):BigInteger {
        var r:BigInteger = new BigInteger();
        addTo(v, r);
        return r;
    }

    public function subtract(v:BigInteger):BigInteger {
        var r:BigInteger = new BigInteger();
        subTo(v, r);
        return r;
    }

    public function multiply(v:BigInteger):BigInteger {
        var r:BigInteger = new BigInteger();
        multiplyTo(v, r);
        return r;
    }

    public function divide(v:BigInteger):BigInteger {
        var r:BigInteger = new BigInteger();
        divRemTo(v, r, null);
        return r;
    }

    public function remainder(v:BigInteger):BigInteger {
        var r:BigInteger = new BigInteger();
        divRemTo(v, null, r);
        return r;
    }

    /** Returns [quotient, remainder]. */
    public function divideAndRemainder(v:BigInteger):Array {
        var q:BigInteger = new BigInteger();
        var r:BigInteger = new BigInteger();
        divRemTo(v, q, r);
        return [q, r];
    }

    public function pow(e:int):BigInteger {
        return exp(e, new NullReduction());
    }

    /** this^e mod m (sliding-window exponentiation). */
    public function modPow(e:BigInteger, m:BigInteger):BigInteger {
        var i:int = e.bitLength();
        var k:int;
        var r:BigInteger = nbv(1);
        var z:IReduction;
        if (i <= 0) {
            return r;
        }
        if (i < 18) {
            k = 1;
        } else {
            if (i < 48) {
                k = 3;
            } else {
                if (i < 144) {
                    k = 4;
                } else {
                    if (i < 768) {
                        k = 5;
                    } else {
                        k = 6;
                    }
                }
            }
        }
        if (i < 8) {
            z = new ClassicReduction(m);
        } else {
            if (m.isEven()) {
                z = new BarrettReduction(m);
            } else {
                z = new MontgomeryReduction(m);
            }
        }
        // precomputation
        var g:Array = [];
        var n:int = 3;
        var k1:int = k - 1;
        var km:int = (1 << k) - 1;
        g[1] = z.convert(this);
        if (k > 1) {
            var g2:BigInteger = new BigInteger();
            z.sqrTo(g[1], g2);
            while (n <= km) {
                g[n] = new BigInteger();
                z.mulTo(g2, g[n - 2], g[n]);
                n += 2;
            }
        }
        var j:int = e.t - 1;
        var w:int;
        var is1:Boolean = true;
        var r2:BigInteger = new BigInteger();
        var tmp:BigInteger;
        i = nbits(e.a[j]) - 1;
        while (j >= 0) {
            if (i >= k1) {
                w = (e.a[j] >> (i - k1)) & km;
            } else {
                w = (e.a[j] & ((1 << (i + 1)) - 1)) << (k1 - i);
                if (j > 0) {
                    w |= e.a[j - 1] >> ((DB + i) - k1);
                }
            }
            n = k;
            while ((w & 1) == 0) {
                w >>= 1;
                n--;
            }
            i -= n;
            if (i < 0) {
                i += DB;
                j--;
            }
            if (is1) {
                // r == 1, don't bother squaring or multiplying it
                g[w].copyTo(r);
                is1 = false;
            } else {
                while (n > 1) {
                    z.sqrTo(r, r2);
                    z.sqrTo(r2, r);
                    n -= 2;
                }
                if (n > 0) {
                    z.sqrTo(r, r2);
                } else {
                    tmp = r;
                    r = r2;
                    r2 = tmp;
                }
                z.mulTo(r2, g[w], r);
            }
            while (j >= 0 && (e.a[j] & (1 << i)) == 0) {
                z.sqrTo(r, r2);
                tmp = r;
                r = r2;
                r2 = tmp;
                if (--i < 0) {
                    i = DB - 1;
                    j--;
                }
            }
        }
        return z.revert(r);
    }

    public function gcd(v:BigInteger):BigInteger {
        var tmp:BigInteger;
        var x:BigInteger = (s < 0) ? negate() : clone();
        var y:BigInteger = (v.s < 0) ? v.negate() : v.clone();
        if (x.compareTo(y) < 0) {
            tmp = x;
            x = y;
            y = tmp;
        }
        var i:int = x.getLowestSetBit();
        var g:int = y.getLowestSetBit();
        if (g < 0) {
            return x;
        }
        if (i < g) {
            g = i;
        }
        if (g > 0) {
            x.rShiftTo(g, x);
            y.rShiftTo(g, y);
        }
        while (x.signum() > 0) {
            i = x.getLowestSetBit();
            if (i > 0) {
                x.rShiftTo(i, x);
            }
            i = y.getLowestSetBit();
            if (i > 0) {
                y.rShiftTo(i, y);
            }
            if (x.compareTo(y) >= 0) {
                x.subTo(y, x);
                x.rShiftTo(1, x);
            } else {
                y.subTo(x, y);
                y.rShiftTo(1, y);
            }
        }
        if (g > 0) {
            y.lShiftTo(g, y);
        }
        return y;
    }

    /** Modular inverse of this mod m, or ZERO if none exists. */
    public function modInverse(m:BigInteger):BigInteger {
        var ac:Boolean = m.isEven();
        if ((isEven() && ac) || m.signum() == 0) {
            return BigInteger.ZERO;
        }
        var u:BigInteger = m.clone();
        var v:BigInteger = clone();
        var a:BigInteger = nbv(1);
        var b:BigInteger = nbv(0);
        var c:BigInteger = nbv(0);
        var d:BigInteger = nbv(1);
        while (u.signum() != 0) {
            while (u.isEven()) {
                u.rShiftTo(1, u);
                if (ac) {
                    if (!a.isEven() || !b.isEven()) {
                        a.addTo(this, a);
                        b.subTo(m, b);
                    }
                    a.rShiftTo(1, a);
                } else {
                    if (!b.isEven()) {
                        b.subTo(m, b);
                    }
                }
                b.rShiftTo(1, b);
            }
            while (v.isEven()) {
                v.rShiftTo(1, v);
                if (ac) {
                    if (!c.isEven() || !d.isEven()) {
                        c.addTo(this, c);
                        d.subTo(m, d);
                    }
                    c.rShiftTo(1, c);
                } else {
                    if (!d.isEven()) {
                        d.subTo(m, d);
                    }
                }
                d.rShiftTo(1, d);
            }
            if (u.compareTo(v) >= 0) {
                u.subTo(v, u);
                if (ac) {
                    a.subTo(c, a);
                }
                b.subTo(d, b);
            } else {
                v.subTo(u, v);
                if (ac) {
                    c.subTo(a, c);
                }
                d.subTo(b, d);
            }
        }
        if (v.compareTo(BigInteger.ONE) != 0) {
            return BigInteger.ZERO;
        }
        if (d.compareTo(m) >= 0) {
            return d.subtract(m);
        }
        if (d.signum() < 0) {
            d.addTo(m, d);
        } else {
            return d;
        }
        if (d.signum() < 0) {
            return d.add(m);
        }
        return d;
    }

    /** Trial division by small primes, then `certainty`-based Miller-Rabin. */
    public function isProbablePrime(certainty:int):Boolean {
        var i:int;
        var m:int;
        var j:int;
        var x:BigInteger = abs();
        if (x.t == 1 && x.a[0] <= lowprimes[lowprimes.length - 1]) {
            i = 0;
            while (i < lowprimes.length) {
                if (x.a[0] == lowprimes[i]) { // original wrote x[0]
                    return true;
                }
                i++;
            }
            return false;
        }
        if (x.isEven()) {
            return false;
        }
        i = 1;
        while (i < lowprimes.length) {
            m = lowprimes[i];
            j = i + 1;
            while (j < lowprimes.length && m < lplim) {
                m = m * lowprimes[j++];
            }
            m = x.modInt(m);
            while (i < j) {
                if ((m % lowprimes[i++]) == 0) {
                    return false;
                }
            }
        }
        return x.millerRabin(certainty);
    }

    /** Turns this into a probable prime of `bits` bits. */
    public function primify(bits:int, certainty:int):void {
        if (!testBit(bits - 1)) {
            // force MSB set
            bitwiseTo(BigInteger.ONE.shiftLeft(bits - 1), op_or, this);
        }
        if (isEven()) {
            dAddOffset(1, 0); // force odd
        }
        while (!isProbablePrime(certainty)) {
            dAddOffset(2, 0);
            while (bitLength() > bits) {
                subTo(BigInteger.ONE.shiftLeft(bits - 1), this);
            }
        }
    }

    protected function nbi():BigInteger {
        return new BigInteger();
    }

    /** Digits of base `radix` that fit in one limb. */
    protected function chunkSize(radix:Number):int {
        return Math.floor((Math.LN2 * DB) / Math.log(radix));
    }

    protected function toRadix(radix:uint = 10):String {
        if (signum() == 0 || radix < 2 || radix > 32) {
            return "0";
        }
        var cs:int = chunkSize(radix);
        var d:Number = Math.pow(radix, cs);
        var y:BigInteger = nbv(d);
        var q:BigInteger = nbi();
        var z:BigInteger = nbi();
        var r:String = "";
        divRemTo(y, q, z);
        while (q.signum() > 0) {
            r = (d + z.intValue()).toString(radix).substr(1) + r;
            q.divRemTo(y, q, z);
        }
        return z.intValue().toString(radix) + r;
    }

    protected function fromRadix(str:String, radix:int = 10):void {
        var digit:int;
        fromInt(0);
        var cs:int = chunkSize(radix);
        var d:Number = Math.pow(radix, cs);
        var mi:Boolean = false;
        var j:int = 0;
        var w:int = 0;
        var i:int = 0;
        while (i < str.length) {
            digit = intAt(str, i);
            if (digit < 0) {
                if (str.charAt(i) == "-" && signum() == 0) {
                    mi = true;
                }
            } else {
                w = (radix * w) + digit;
                if (++j >= cs) {
                    dMultiply(d);
                    dAddOffset(w, 0);
                    j = 0;
                    w = 0;
                }
            }
            i++;
        }
        if (j > 0) {
            dMultiply(Math.pow(radix, j));
            dAddOffset(w, 0);
        }
        if (mi) {
            BigInteger.ZERO.subTo(this, this);
        }
    }

    /** r = this op v, limb by limb. */
    protected function bitwiseTo(v:BigInteger, op:Function, r:BigInteger):void {
        var i:int;
        var f:int;
        var m:int = Math.min(v.t, t);
        i = 0;
        while (i < m) {
            r.a[i] = op(a[i], v.a[i]);
            i++;
        }
        if (v.t < t) {
            f = v.s & DM;
            i = m;
            while (i < t) {
                r.a[i] = op(a[i], f);
                i++;
            }
            r.t = t;
        } else {
            f = s & DM;
            i = m;
            while (i < v.t) {
                r.a[i] = op(f, v.a[i]);
                i++;
            }
            r.t = v.t;
        }
        r.s = op(s, v.s);
        r.clamp();
    }

    /** this op (1 << n) */
    protected function changeBit(n:int, op:Function):BigInteger {
        var r:BigInteger = BigInteger.ONE.shiftLeft(n);
        bitwiseTo(r, op, r);
        return r;
    }

    /** r = this + v */
    protected function addTo(v:BigInteger, r:BigInteger):void {
        var i:int = 0;
        var c:int = 0;
        var m:int = Math.min(v.t, t);
        while (i < m) {
            c += a[i] + v.a[i];
            r.a[i++] = c & DM;
            c >>= DB;
        }
        if (v.t < t) {
            c += v.s;
            while (i < t) {
                c += a[i];
                r.a[i++] = c & DM;
                c >>= DB;
            }
            c += s;
        } else {
            c += s;
            while (i < v.t) {
                c += v.a[i];
                r.a[i++] = c & DM;
                c >>= DB;
            }
            c += v.s;
        }
        r.s = (c < 0) ? -1 : 0;
        if (c > 0) {
            r.a[i++] = c;
        } else {
            if (c < -1) {
                r.a[i++] = DV + c;
            }
        }
        r.t = i;
        r.clamp();
    }

    /** this mod n for a small int n. */
    protected function modInt(n:int):int {
        var i:int;
        if (n <= 0) {
            return 0;
        }
        var d:int = DV % n;
        var r:int = (s < 0) ? (n - 1) : 0;
        if (t > 0) {
            if (d == 0) {
                r = a[0] % n;
            } else {
                i = t - 1;
                while (i >= 0) {
                    r = ((d * r) + a[i]) % n;
                    i--;
                }
            }
        }
        return r;
    }

    protected function millerRabin(certainty:int):Boolean {
        var y:BigInteger;
        var j:int;
        var n1:BigInteger = subtract(BigInteger.ONE);
        var k:int = n1.getLowestSetBit();
        if (k <= 0) {
            return false;
        }
        var r:BigInteger = n1.shiftRight(k);
        certainty = (certainty + 1) >> 1;
        if (certainty > lowprimes.length) {
            certainty = lowprimes.length;
        }
        var a:BigInteger = new BigInteger();
        var i:int = 0;
        while (i < certainty) {
            a.fromInt(lowprimes[i]);
            y = a.modPow(r, this);
            if (y.compareTo(BigInteger.ONE) != 0 && y.compareTo(n1) != 0) {
                j = 1;
                while (j++ < k && y.compareTo(n1) != 0) {
                    y = y.modPowInt(2, this);
                    if (y.compareTo(BigInteger.ONE) == 0) {
                        return false;
                    }
                }
                if (y.compareTo(n1) != 0) {
                    return false;
                }
            }
            i++;
        }
        return true;
    }

    private function op_and(x:int, y:int):int {
        return x & y;
    }

    private function op_or(x:int, y:int):int {
        return x | y;
    }

    private function op_xor(x:int, y:int):int {
        return x ^ y;
    }

    private function op_andnot(x:int, y:int):int {
        return x & ~y;
    }

    /** Index of the lowest set bit of x (-1 if x == 0). */
    private function lbit(x:int):int {
        if (x == 0) {
            return -1;
        }
        var r:int = 0;
        if ((x & 0xFFFF) == 0) {
            x >>= 16;
            r += 16;
        }
        if ((x & 0xFF) == 0) {
            x >>= 8;
            r += 8;
        }
        if ((x & 15) == 0) {
            x >>= 4;
            r += 4;
        }
        if ((x & 3) == 0) {
            x >>= 2;
            r += 2;
        }
        if ((x & 1) == 0) {
            r++;
        }
        return r;
    }

    /** Population count of x. */
    private function cbit(x:int):int {
        var r:uint = 0;
        while (x != 0) {
            x &= x - 1;
            r++;
        }
        return r;
    }

    bi_internal var s:int;
    bi_internal var a:Array;

    /** Bit length of x. */
    bi_internal function nbits(x:int):int {
        var t:int;
        var r:int = 1;
        t = x >>> 16;
        if (t != 0) {
            x = t;
            r += 16;
        }
        t = x >> 8;
        if (t != 0) {
            x = t;
            r += 8;
        }
        t = x >> 4;
        if (t != 0) {
            x = t;
            r += 4;
        }
        t = x >> 2;
        if (t != 0) {
            x = t;
            r += 2;
        }
        t = x >> 1;
        if (t != 0) {
            x = t;
            r += 1;
        }
        return r;
    }

    bi_internal function copyTo(r:BigInteger):void {
        var i:int = t - 1;
        while (i >= 0) {
            r.a[i] = a[i];
            i--;
        }
        r.t = t;
        r.s = s;
    }

    bi_internal function fromInt(x:int):void {
        t = 1;
        s = (x < 0) ? -1 : 0;
        if (x > 0) {
            a[0] = x;
        } else {
            if (x < -1) {
                a[0] = x + DV;
            } else {
                t = 0;
            }
        }
    }

    bi_internal function fromArray(b:ByteArray, ln:int, unsigned:Boolean = false):void {
        var x:int;
        var p:int = b.position;
        var i:int = p + ln;
        var sh:int = 0;
        var k:int = 8;
        t = 0;
        s = 0;
        while (--i >= p) {
            x = (i < b.length) ? b[i] : 0;
            if (sh == 0) {
                a[t++] = x;
            } else {
                if ((sh + k) > DB) {
                    a[t - 1] |= (x & ((1 << (DB - sh)) - 1)) << sh;
                    a[t++] = x >> (DB - sh);
                } else {
                    a[t - 1] |= x << sh;
                }
            }
            sh += k;
            if (sh >= DB) {
                sh -= DB;
            }
        }
        if (!unsigned && (b[0] & 128) == 128) {
            s = -1;
            if (sh > 0) {
                a[t - 1] |= ((1 << (DB - sh)) - 1) << sh;
            }
        }
        clamp();
        b.position = Math.min(p + ln, b.length);
    }

    /** Drops leading limbs equal to the sign extension. */
    bi_internal function clamp():void {
        var c:int = s & DM;
        while (t > 0 && a[t - 1] == c) {
            t--;
        }
    }

    /** r = this << (n limbs) */
    bi_internal function dlShiftTo(n:int, r:BigInteger):void {
        var i:int;
        i = t - 1;
        while (i >= 0) {
            r.a[i + n] = a[i];
            i--;
        }
        i = n - 1;
        while (i >= 0) {
            r.a[i] = 0;
            i--;
        }
        r.t = t + n;
        r.s = s;
    }

    /** r = this >> (n limbs) */
    bi_internal function drShiftTo(n:int, r:BigInteger):void {
        var i:int;
        i = n;
        while (i < t) {
            r.a[i - n] = a[i];
            i++;
        }
        r.t = Math.max(t - n, 0);
        r.s = s;
    }

    /** r = this << n bits */
    bi_internal function lShiftTo(n:int, r:BigInteger):void {
        var i:int;
        var bs:int = n % DB;
        var cbs:int = DB - bs;
        var bm:int = (1 << cbs) - 1;
        var ds:int = n / DB;
        var c:int = (s << bs) & DM;
        i = t - 1;
        while (i >= 0) {
            r.a[i + ds + 1] = (a[i] >> cbs) | c;
            c = (a[i] & bm) << bs;
            i--;
        }
        i = ds - 1;
        while (i >= 0) {
            r.a[i] = 0;
            i--;
        }
        r.a[ds] = c;
        r.t = t + ds + 1;
        r.s = s;
        r.clamp();
    }

    /** r = this >> n bits */
    bi_internal function rShiftTo(n:int, r:BigInteger):void {
        var i:int;
        r.s = s;
        var ds:int = n / DB;
        if (ds >= t) {
            r.t = 0;
            return;
        }
        var bs:int = n % DB;
        var cbs:int = DB - bs;
        var bm:int = (1 << bs) - 1;
        r.a[0] = a[ds] >> bs;
        i = ds + 1;
        while (i < t) {
            r.a[i - ds - 1] |= (a[i] & bm) << cbs;
            r.a[i - ds] = a[i] >> bs;
            i++;
        }
        if (bs > 0) {
            r.a[t - ds - 1] |= (s & bm) << cbs;
        }
        r.t = t - ds;
        r.clamp();
    }

    /** r = this - v */
    bi_internal function subTo(v:BigInteger, r:BigInteger):void {
        var i:int = 0;
        var c:int = 0;
        var m:int = Math.min(v.t, t);
        while (i < m) {
            c += a[i] - v.a[i];
            r.a[i++] = c & DM;
            c >>= DB;
        }
        if (v.t < t) {
            c -= v.s;
            while (i < t) {
                c += a[i];
                r.a[i++] = c & DM;
                c >>= DB;
            }
            c += s;
        } else {
            c += s;
            while (i < v.t) {
                c -= v.a[i];
                r.a[i++] = c & DM;
                c >>= DB;
            }
            c -= v.s;
        }
        r.s = (c < 0) ? -1 : 0;
        if (c < -1) {
            r.a[i++] = DV + c;
        } else {
            if (c > 0) {
                r.a[i++] = c;
            }
        }
        r.t = i;
        r.clamp();
    }

    /**
     * w[j..j+n) += x * this[i..i+n) with carry-in c; returns the carry-out.
     * (Splits limbs into 15-bit halves to stay within 32-bit int math.)
     */
    bi_internal function am(i:int, x:int, w:BigInteger, j:int, c:int, n:int):int {
        var l:int;
        var h:int;
        var m:int;
        var xl:int = x & 0x7FFF;
        var xh:int = x >> 15;
        while (--n >= 0) {
            l = a[i] & 0x7FFF;
            h = a[i++] >> 15;
            m = (xh * l) + (h * xl);
            l = (((xl * l) + ((m & 0x7FFF) << 15)) + w.a[j]) + (c & 0x3FFFFFFF);
            c = (((l >>> 30) + (m >>> 15)) + (xh * h)) + (c >>> 30);
            w.a[j++] = l & 0x3FFFFFFF;
        }
        return c;
    }

    /** r = this * v */
    bi_internal function multiplyTo(v:BigInteger, r:BigInteger):void {
        var x:BigInteger = abs();
        var y:BigInteger = v.abs();
        var i:int = x.t;
        r.t = i + y.t;
        while (--i >= 0) {
            r.a[i] = 0;
        }
        i = 0;
        while (i < y.t) {
            r.a[i + x.t] = x.am(0, y.a[i], r, i, 0, x.t);
            i++;
        }
        r.s = 0;
        r.clamp();
        if (s != v.s) {
            ZERO.subTo(r, r);
        }
    }

    /** r = this^2 */
    bi_internal function squareTo(r:BigInteger):void {
        var c:int;
        var x:BigInteger = abs();
        var i:int = r.t = (2 * x.t);
        while (--i >= 0) {
            r.a[i] = 0;
        }
        i = 0;
        while (i < (x.t - 1)) {
            c = x.am(i, x.a[i], r, 2 * i, 0, 1);
            r.a[i + x.t] += x.am(i + 1, 2 * x.a[i], r, (2 * i) + 1, c, x.t - i - 1);
            if (r.a[i + x.t] >= DV) {
                r.a[i + x.t] -= DV;
                r.a[i + x.t + 1] = 1;
            }
            i++;
        }
        if (r.t > 0) {
            r.a[r.t - 1] += x.am(i, x.a[i], r, 2 * i, 0, 1);
        }
        r.s = 0;
        r.clamp();
    }

    /** q = this / m, r = this % m (either may be null). */
    bi_internal function divRemTo(m:BigInteger, q:BigInteger = null, r:BigInteger = null):void {
        var qd:int;
        var pm:BigInteger = m.abs();
        if (pm.t <= 0) {
            return;
        }
        var pt:BigInteger = abs();
        if (pt.t < pm.t) {
            if (q != null) {
                q.fromInt(0);
            }
            if (r != null) {
                copyTo(r);
            }
            return;
        }
        if (r == null) {
            r = nbi();
        }
        var y:BigInteger = nbi();
        var ts:int = s;
        var ms:int = m.s;
        var nsh:int = DB - nbits(pm.a[pm.t - 1]); // normalize modulus
        if (nsh > 0) {
            pm.lShiftTo(nsh, y);
            pt.lShiftTo(nsh, r);
        } else {
            pm.copyTo(y);
            pt.copyTo(r);
        }
        var ys:int = y.t;
        var y0:int = y.a[ys - 1];
        if (y0 == 0) {
            return;
        }
        var yt:Number = (y0 * (1 << F1)) + ((ys > 1) ? (y.a[ys - 2] >> F2) : 0);
        var d1:Number = FV / yt;
        var d2:Number = (1 << F1) / yt;
        var e:Number = 1 << F2;
        var i:int = r.t;
        var j:int = i - ys;
        var t:BigInteger = (q == null) ? nbi() : q;
        y.dlShiftTo(j, t);
        if (r.compareTo(t) >= 0) {
            r.a[r.t++] = 1;
            r.subTo(t, r);
        }
        ONE.dlShiftTo(ys, t);
        t.subTo(y, y); // "negative" y so we can replace sub with am later
        while (y.t < ys) {
            y.a[y.t++] = 0; // original decompiled as a garbage XML(y).(y.t++, 0) expression
        }
        while (--j >= 0) {
            // estimate quotient digit
            qd = (r.a[--i] == y0) ? DM : ((Number(r.a[i]) * d1) + ((Number(r.a[i - 1]) + e) * d2));
            r.a[i] += y.am(0, qd, r, j, 0, ys);
            if (r.a[i] < qd) {
                // try it out
                y.dlShiftTo(j, t);
                r.subTo(t, r);
                while (r.a[i] < --qd) {
                    r.subTo(t, r);
                }
            }
        }
        if (q != null) {
            r.drShiftTo(ys, q);
            if (ts != ms) {
                ZERO.subTo(q, q);
            }
        }
        r.t = ys;
        r.clamp();
        if (nsh > 0) {
            r.rShiftTo(nsh, r); // denormalize remainder
        }
        if (ts < 0) {
            ZERO.subTo(r, r);
        }
    }

    /** -1/this mod DV (Montgomery helper); 0 if this is even. */
    bi_internal function invDigit():int {
        if (t < 1) {
            return 0;
        }
        var x:int = a[0];
        if ((x & 1) == 0) {
            return 0;
        }
        var y:int = x & 3; // y == 1/x mod 2^2
        y = (y * (2 - ((x & 15) * y))) & 15; // y == 1/x mod 2^4
        y = (y * (2 - ((x & 0xFF) * y))) & 0xFF; // y == 1/x mod 2^8
        y = (y * (2 - (((x & 0xFFFF) * y) & 0xFFFF))) & 0xFFFF; // y == 1/x mod 2^16
        // last step - calculate inverse mod DV directly; assumes 16 < DB <= 32 and assumes ability to handle 48-bit ints
        y = (y * (2 - ((x * y) % DV))) % DV; // y == 1/x mod 2^32
        // we really want the negative inverse, and -DV < y < DV
        return (y > 0) ? (DV - y) : -y;
    }

    bi_internal function isEven():Boolean {
        return (((t > 0) ? (a[0] & 1) : s) == 0);
    }

    /** this^e using the given reduction strategy (square-and-multiply). */
    bi_internal function exp(e:int, z:IReduction):BigInteger {
        var tmp:BigInteger;
        if (e > 0xFFFFFFFF || e < 1) {
            return ONE;
        }
        var r:BigInteger = nbi();
        var r2:BigInteger = nbi();
        var g:BigInteger = z.convert(this);
        var i:int = nbits(e) - 1;
        g.copyTo(r);
        while (--i >= 0) {
            z.sqrTo(r, r2);
            if ((e & (1 << i)) > 0) {
                z.mulTo(r2, g, r);
            } else {
                tmp = r;
                r = r2;
                r2 = tmp;
            }
        }
        return z.revert(r);
    }

    /** Digit value (0..35) of str[index], or -1 if not alphanumeric. */
    bi_internal function intAt(str:String, index:int):int {
        return parseInt(str.charAt(index), 36);
    }

    /** this = this * n + 0 (n small, used by fromRadix) */
    bi_internal function dMultiply(n:int):void {
        a[t] = am(0, n - 1, this, 0, 0, t);
        t++;
        clamp();
    }

    /** this += n << (w limbs) */
    bi_internal function dAddOffset(n:int, w:int):void {
        while (t <= w) {
            a[t++] = 0;
        }
        a[w] += n;
        while (a[w] >= DV) {
            a[w] -= DV;
            if (++w >= t) {
                a[t++] = 0;
            }
            ++a[w];
        }
    }

    /** r = low n limbs of (this * v) */
    bi_internal function multiplyLowerTo(v:BigInteger, n:int, r:BigInteger):void {
        var j:int;
        var i:int = Math.min(t + v.t, n);
        r.s = 0; // assumes v and this >= 0
        r.t = i;
        while (i > 0) {
            r.a[--i] = 0;
        }
        j = r.t - t;
        while (i < j) {
            r.a[i + t] = am(0, v.a[i], r, i, 0, t);
            i++;
        }
        j = Math.min(v.t, n);
        while (i < j) {
            am(0, v.a[i], r, i, 0, n - i);
            i++;
        }
        r.clamp();
    }

    /** r = high limbs of (this * v), from limb n-1 on */
    bi_internal function multiplyUpperTo(v:BigInteger, n:int, r:BigInteger):void {
        n--;
        var i:int = r.t = ((t + v.t) - n);
        r.s = 0; // assumes v and this >= 0
        while (--i >= 0) {
            r.a[i] = 0;
        }
        i = Math.max(n - t, 0);
        while (i < v.t) {
            r.a[(t + i) - n] = am(n - i, v.a[i], r, 0, 0, (t + i) - n);
            i++;
        }
        r.clamp();
        r.drShiftTo(1, r);
    }

}
}//package com.hurlant.math
