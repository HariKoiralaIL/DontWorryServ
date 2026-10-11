package _tg {
import flash.display.BitmapData;
import flash.events.Event;

// Formerly _E_C_. Bubbling event asking for a picture to be added.
public class AddPictureEvent extends Event {

    public static const ADD_PICTURE_EVENT:String = "ADD_PICTURE_EVENT";

    public var bitmapData_:BitmapData;

    public function AddPictureEvent(bitmapData:BitmapData) {
        super(ADD_PICTURE_EVENT, true);
        this.bitmapData_ = bitmapData;
    }

    override public function clone():Event {
        return new AddPictureEvent(this.bitmapData_);
    }
}
}
