package spriteeditor {
import flash.events.Event;

/** Requests a batch of pixel changes (e.g. from "clear"). */
public class SetPixelsEvent extends Event {

    public static const SET_PIXELS_EVENT:String = "SET_PIXELS_EVENT";

    public function SetPixelsEvent(changes:Vector.<PixelChange>) {
        super(SET_PIXELS_EVENT, true);
        this.changes_ = changes;
    }
    public var changes_:Vector.<PixelChange>;
}
}
