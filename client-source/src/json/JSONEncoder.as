package json {
import flash.utils.describeType;

public class JSONEncoder {

    private var jsonString:String;

    public function JSONEncoder(value:*) {
        jsonString = convertToString(value);
    }

    public function getString():String {
        return jsonString;
    }

    private function convertToString(value:*):String {
        if (value is String) {
            return escapeString(value as String);
        }
        if (value is Number) {
            return isFinite(value as Number) ? value.toString() : "null";
        }
        if (value is Boolean) {
            return value ? "true" : "false";
        }
        if (value is Array) {
            return arrayToString(value as Array);
        }
        if (value is Object && value != null) {
            return objectToString(value);
        }
        return "null";
    }

    private function escapeString(str:String):String {
        var ch:String;
        var hex:String;
        var pad:String;
        var out:String = "";
        var len:Number = str.length;
        var i:int = 0;
        while (i < len) {
            ch = str.charAt(i);
            switch (ch) {
                case '"':
                    out += '\\"';
                    break;
                case "\\":
                    out += "\\\\";
                    break;
                case "\b":
                    out += "\\b";
                    break;
                case "\f":
                    out += "\\f";
                    break;
                case "\n":
                    out += "\\n";
                    break;
                case "\r":
                    out += "\\r";
                    break;
                case "\t":
                    out += "\\t";
                    break;
                default:
                    if (ch < " ") {
                        hex = ch.charCodeAt(0).toString(16);
                        pad = (hex.length == 2) ? "00" : "000";
                        out += "\\u" + pad + hex;
                    } else {
                        out += ch;
                    }
            }
            i++;
        }
        return '"' + out + '"';
    }

    private function arrayToString(a:Array):String {
        var s:String = "";
        var i:int = 0;
        while (i < a.length) {
            if (s.length > 0) {
                s += ",";
            }
            s += convertToString(a[i]);
            i++;
        }
        return "[" + s + "]";
    }

    private function objectToString(o:Object):String {
        var value:Object;
        var key:String;
        var v:XML;
        var s:String = "";
        var classInfo:XML = describeType(o);
        if (classInfo.@name.toString() == "Object") {
            for (key in o) {
                value = o[key];
                if (!(value is Function)) {
                    if (s.length > 0) {
                        s += ",";
                    }
                    s += escapeString(key) + ":" + convertToString(value);
                }
            }
        } else {
            for each (v in classInfo..*.((name() == "variable") || (name() == "accessor"))) {
                if (s.length > 0) {
                    s += ",";
                }
                s += escapeString(v.@name.toString()) + ":" + convertToString(o[v.@name]);
            }
        }
        return "{" + s + "}";
    }

}
}
