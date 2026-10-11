package events {
import flash.events.Event;

/** Event carrying an arbitrary data object. */
public class GenericDataEvent extends Event {

    public static const GENERIC_DATA:String = "GENERIC_DATA";

    public var data:Object;

    public function GenericDataEvent(data:Object) {
        super(GENERIC_DATA);
        this.data = data;
    }

    override public function clone():Event {
        return new GenericDataEvent(data);
    }

    override public function toString():String {
        return formatToString("GenericDataEvent", "type", "data");
    }

}
}
