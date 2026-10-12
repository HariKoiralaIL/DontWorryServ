package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Result of a guild creation request.
 */
public class CreateGuildResult extends ServerMessage {

    public var success_:Boolean;
    public var errorText_:String;

    public function CreateGuildResult(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.success_ = data.readBoolean();
        this.errorText_ = data.readUTF();
    }

    override public function toString():String {
        return (formatToString("CREATEGUILDRESULT", "success_", "errorText_"));
    }

}
}
