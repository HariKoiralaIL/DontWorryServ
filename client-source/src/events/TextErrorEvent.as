package events {
import flash.events.Event;

/** Event carrying an error message; the source value is converted to a string ("null" if null). */
public class TextErrorEvent extends Event {

    public static const TEXT_ERROR:String = "TEXT_ERROR";

    public var text:String;

    public function TextErrorEvent(error:Object) {
        super(TEXT_ERROR);
        text = error != null ? error.toString() : "null";
    }

    override public function clone():Event {
        return new TextErrorEvent(text);
    }

    override public function toString():String {
        return formatToString("TextErrorEvent", "type", "text");
    }

}
}
