package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Party invitation.
 */
public class InvitedToParty extends ServerMessage {

    public var name_:String;
    public var partyID_:int;

    public function InvitedToParty(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.name_ = data.readUTF();
        this.partyID_ = data.readInt();
    }

    override public function toString():String {
        return (formatToString("INVITEDTOPARTY", "name_", "partyID_"));
    }

}
}
