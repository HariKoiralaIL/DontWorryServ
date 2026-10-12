package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Asks the client to prompt the player for text.
 */
public class GetTextInput extends ServerMessage {

    public var name_:String;
    public var action_:String;

    public function GetTextInput(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.name_ = data.readUTF();
        this.action_ = data.readUTF();
    }

    override public function toString():String {
        return (formatToString("GETTEXTINPUT", "name_", "action_"));
    }

}
}
