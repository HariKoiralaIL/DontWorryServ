package com.company.util {
import flash.utils.ByteArray;

public class StringUtil {

    /** "0A1B..." -> bytes. */
    public static function hexToBytes(hex:String):ByteArray {
        var bytes:ByteArray = new ByteArray();
        var i:int = 0;
        while (i < hex.length) {
            bytes.writeByte(parseInt(hex.substr(i, 2), 16));
            i = i + 2;
        }
        return bytes;
    }

    public static function compare(a:String, b:String):Number {
        return a.localeCompare(b);
    }

}
}//package com.company.util
