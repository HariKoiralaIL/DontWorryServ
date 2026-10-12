package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Floating text notification above an object.
 */
public class Notification extends ServerMessage {

    public var objectId_:int;
    public var text_:String;
    public var color_:int;

    public function Notification(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.objectId_ = data.readInt();
        this.text_ = data.readUTF();
        this.color_ = data.readInt();
    }

    override public function toString():String {
        return (formatToString("NOTIFICATION", "objectId_", "text_", "color_"));
    }

}
}
