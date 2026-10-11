package matchers {

/** A Description that discards everything appended to it. */
public class NullDescription implements Description {

    public function toString():String {
        return "";
    }

    public function appendText(text:String):Description {
        return this;
    }

    public function appendDescriptionOf(value:SelfDescribing):Description {
        return this;
    }

    public function appendMismatchOf(matcher:Matcher, value:*):Description {
        return this;
    }

    public function appendValue(value:Object):Description {
        return this;
    }

    public function appendList(start:String, separator:String, end:String, list:Array):Description {
        return this;
    }

}
}
