package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Server-wide notification (type + text).
 */
public class GlobalNotification extends ServerMessage {

    public var _type:int;
    public var text:String;

    public function GlobalNotification(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this._type = data.readInt();
        this.text = data.readUTF();
    }

    override public function toString():String {
        return (formatToString("GLOBAL_NOTIFICATION", "_type", "text"));
    }

}
}
