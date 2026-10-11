package mapeditor {
import client.ui.frames.Frame;
import client.ui.frames.TextInput;

import flash.events.Event;
import flash.events.MouseEvent;

/** Dialog frame with a single "Object Name" input, used by the Edit tool. */
public class TilePropertiesFrame extends Frame {

    public function TilePropertiesFrame(objectName:String) {
        super("Tile properties", "Cancel", "Save", null);
        this.nameInput_ = new TextInput("Object Name", false, "");
        if (objectName != null) {
            this.nameInput_.inputText_.text = objectName;
        }
        addInput(this.nameInput_);
        Button1.addEventListener(MouseEvent.CLICK, this.onCancel);
        Button2.addEventListener(MouseEvent.CLICK, this.onSave);
    }
    public var nameInput_:TextInput;

    private function onCancel(event:MouseEvent):void {
        dispatchEvent(new Event(Event.CANCEL));
    }

    private function onSave(event:MouseEvent):void {
        dispatchEvent(new Event(Event.COMPLETE));
    }

}
}
