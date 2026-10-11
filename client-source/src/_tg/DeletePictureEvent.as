package _tg {
import flash.events.Event;

// Formerly _32. Bubbling event asking for a picture to be deleted.
public class DeletePictureEvent extends Event {

    public static const DELETE_PICTURE_EVENT:String = "DELETE_PICTURE_EVENT";

    public var name_:String;
    public var id_:int;

    public function DeletePictureEvent(name:String, id:int) {
        super(DELETE_PICTURE_EVENT, true);
        this.name_ = name;
        this.id_ = id;
    }

    override public function clone():Event {
        return new DeletePictureEvent(this.name_, this.id_);
    }
}
}
