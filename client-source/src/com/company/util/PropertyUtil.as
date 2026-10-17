package com.company.util {
public class PropertyUtil {

    /** Copies all enumerable properties of source onto target. */
    public static function copyProperties(target:Object, source:Object):void {
        for (var key:String in source) {
            target[key] = source[key];
        }
    }

}
}//package com.company.util
