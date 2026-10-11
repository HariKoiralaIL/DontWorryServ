package matchers {
import flash.errors.IllegalOperationError;

public class BaseDescription implements Description {

    private static const ESCAPED_CHARS:Object = {
        '"': '\\"',
        "\n": "\\n",
        "\r": "\\r",
        "\t": "\\t"
    };

    public function toString():String {
        throw new IllegalOperationError("BaseDescription#toString is abstract and must be overriden by a subclass");
    }

    public function appendText(text:String):Description {
        append(text);
        return this;
    }

    public function appendDescriptionOf(value:SelfDescribing):Description {
        value.describeTo(this);
        return this;
    }

    public function appendMismatchOf(matcher:Matcher, value:*):Description {
        matcher.describeMismatch(value, this);
        return this;
    }

    public function appendValue(value:Object):Description {
        if (value == null) {
            append("null");
        } else if (value is String) {
            append('"');
            appendEscapedString(value);
            append('"');
        } else if (value is Number) {
            append("<");
            append(value);
            append(">");
        } else if (value is Array) {
            appendValueList("[", ",", "]", value as Array);
        } else if (value is XML) {
            append(XML(value).toXMLString());
        } else if (value is Date) {
            appendDate(value as Date);
        } else if (value is Function) {
            append("<Function>");
        } else {
            append("<");
            append(value);
            append(">");
        }
        return this;
    }

    public function appendValueList(start:String, separator:String, end:String, list:Array):Description {
        return appendList(start, separator, end, list.map(toSelfDescribingValue));
    }

    public function appendList(start:String, separator:String, end:String, list:Array):Description {
        var item:Object;
        var separate:Boolean;
        append(start);
        for each (item in list) {
            if (separate) {
                append(separator);
            }
            if (item is SelfDescribing) {
                appendDescriptionOf(item as SelfDescribing);
            } else {
                appendValue(item);
            }
            separate = true;
        }
        append(end);
        return this;
    }

    protected function append(value:Object):void {
        throw new IllegalOperationError("BaseDescription#append is abstract and must be overriden by a subclass");
    }

    private function appendDate(date:Date):void {
        append("<");
        append(date.fullYear);
        append("-");
        append(pad2(date.month + 1));
        append("-");
        append(pad2(date.date));
        append("T");
        append(pad2(date.hours));
        append(":");
        append(pad2(date.minutes));
        append(":");
        append(pad2(date.seconds));
        append(".");
        append(pad3(date.milliseconds));
        append(">");
    }

    private function pad2(n:int):String {
        return n < 10 ? "0" + n.toString(10) : n.toString(10);
    }

    private function pad3(n:int):String {
        if (n < 10) {
            return "00" + n.toString(10);
        }
        return n < 100 ? "0" + n.toString(10) : n.toString(10);
    }

    private function toSelfDescribingValue(item:Object, index:int = 0, list:Array = null):SelfDescribingValue {
        return new SelfDescribingValue(item);
    }

    private function appendEscapedString(value:Object):void {
        String(value).split("").forEach(appendEscapedChar);
    }

    private function appendEscapedChar(char:String, index:int = 0, list:Array = null):void {
        append(ESCAPED_CHARS[char] || char);
    }

}
}

import matchers.Description;
import matchers.SelfDescribing;

class SelfDescribingValue implements SelfDescribing {

    internal var _value:Object;

    public function SelfDescribingValue(value:Object) {
        _value = value;
    }

    public function describeTo(description:Description):void {
        description.appendValue(_value);
    }

}
