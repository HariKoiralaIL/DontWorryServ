package com.company.assembleegameclient.util {
import flash.system.Capabilities;

/** Generates a pseudo-unique ID: an upper-case SHA-1 hash of time, system info, a random number and a counter. */
public class GUID {

    private static var counter:Number = 0;

    public static function create():String {
        var now:Date = new Date();
        var timeMs:Number = now.time;
        var randomValue:Number = (Math.random() * Number.MAX_VALUE);
        var serverString:String = Capabilities.serverString;
        return sha1Hex((((timeMs + serverString) + randomValue) + counter++)).toUpperCase();
    }

    private static function sha1Hex(input:String):String {
        return wordsToHex(computeSha1(stringToWords(input), (input.length * 8)));
    }

    private static function computeSha1(words:Array, bitLength:Number):Array {
        var prevA:Number;
        var prevB:Number;
        var prevC:Number;
        var prevD:Number;
        var prevE:Number;
        var round:Number;
        var temp:Number;
        words[(bitLength >> 5)] = (words[(bitLength >> 5)] | (128 << (24 - (bitLength % 32))));
        words[((((bitLength + 64) >> 9) << 4) + 15)] = bitLength;
        var schedule:Array = new Array(80);
        var a:Number = 1732584193;
        var b:Number = -271733879;
        var c:Number = -1732584194;
        var d:Number = 271733878;
        var e:Number = -1009589776;
        var blockStart:Number = 0;
        while (blockStart < words.length) {
            prevA = a;
            prevB = b;
            prevC = c;
            prevD = d;
            prevE = e;
            round = 0;
            while (round < 80) {
                if (round < 16) {
                    schedule[round] = words[(blockStart + round)];
                } else {
                    schedule[round] = rol((((schedule[(round - 3)] ^ schedule[(round - 8)]) ^ schedule[(round - 14)]) ^ schedule[(round - 16)]), 1);
                }
                temp = safeAdd(safeAdd(rol(a, 5), sha1_ft(round, b, c, d)), safeAdd(safeAdd(e, schedule[round]), sha1_kt(round)));
                e = d;
                d = c;
                c = rol(b, 30);
                b = a;
                a = temp;
                round++;
            }
            a = safeAdd(a, prevA);
            b = safeAdd(b, prevB);
            c = safeAdd(c, prevC);
            d = safeAdd(d, prevD);
            e = safeAdd(e, prevE);
            blockStart = (blockStart + 16);
        }
        return [a, b, c, d, e];
    }

    private static function sha1_ft(round:Number, b:Number, c:Number, d:Number):Number {
        if (round < 20) {
            return (((b & c) | (~(b) & d)));
        }
        if (round < 40) {
            return (((b ^ c) ^ d));
        }
        if (round < 60) {
            return ((((b & c) | (b & d)) | (c & d)));
        }
        return (((b ^ c) ^ d));
    }

    private static function sha1_kt(round:Number):Number {
        return ((((round) < 20) ? 1518500249 : (((round) < 40) ? 1859775393 : (((round) < 60) ? -1894007588 : -899497514))));
    }

    /** 32-bit addition that wraps on overflow. */
    private static function safeAdd(x:Number, y:Number):Number {
        var lowSum:Number = ((x & 0xFFFF) + (y & 0xFFFF));
        var highSum:Number = (((x >> 16) + (y >> 16)) + (lowSum >> 16));
        return (((highSum << 16) | (lowSum & 0xFFFF)));
    }

    /** Rotate left. */
    private static function rol(value:Number, bits:Number):Number {
        return (((value << bits) | (value >>> (32 - bits))));
    }

    /** Packs the low byte of each character into big-endian 32-bit words. */
    private static function stringToWords(input:String):Array {
        var words:Array = [];
        var mask:Number = ((1 << 8) - 1);
        var bitIndex:Number = 0;
        while (bitIndex < (input.length * 8)) {
            words[(bitIndex >> 5)] = (words[(bitIndex >> 5)] | ((input.charCodeAt((bitIndex / 8)) & mask) << (24 - (bitIndex % 32))));
            bitIndex = (bitIndex + 8);
        }
        return words;
    }

    private static function wordsToHex(words:Array):String {
        var hex:String = String("");
        var digits:String = String("0123456789abcdef");
        var i:Number = 0;
        while (i < (words.length * 4)) {
            hex = (hex + (digits.charAt(((words[(i >> 2)] >> (((3 - (i % 4)) * 8) + 4)) & 15)) + digits.charAt(((words[(i >> 2)] >> ((3 - (i % 4)) * 8)) & 15))));
            i++;
        }
        return hex;
    }

}
}
