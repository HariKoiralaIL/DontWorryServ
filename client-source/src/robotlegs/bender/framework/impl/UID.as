package robotlegs.bender.framework.impl {
import flash.utils.getQualifiedClassName;

/**
 * Generates unique identifier strings, optionally prefixed with a class name.
 */
public class UID {

    private static var _i:uint;

    public static function create(source:* = null):String {
        var prefix:* = source;
        if (source is Class) {
            prefix = getQualifiedClassName(source).split("::").pop();
        }
        return (prefix ? prefix + "-" : "") + (_i++).toString(16) + "-" + (Math.random() * 0xFF).toString(16);
    }

}
}
