package _tg {
import flash.display.BitmapData;
import flash.events.Event;

// Formerly _07k. Dispatched when a picture has finished loading.
public class LoadCompleteEvent extends Event {

    public static const LOAD_COMPLETE_EVENT:String = "LOAD_COMPLETE_EVENT";

    public var name_:String;
    public var type_:int;
    public var extraText_:String;   // formerly _0D_z (purpose unclear from this file alone; rename once known)
    public var bitmapData_:BitmapData;

    public function LoadCompleteEvent(name:String, type:int, extraText:String, bitmapData:BitmapData) {
        super(LOAD_COMPLETE_EVENT);
        this.name_ = name;
        this.type_ = type;
        this.extraText_ = extraText;
        this.bitmapData_ = bitmapData;
    }

    override public function clone():Event {
        return new LoadCompleteEvent(this.name_, this.type_, this.extraText_, this.bitmapData_);
    }
}
}
