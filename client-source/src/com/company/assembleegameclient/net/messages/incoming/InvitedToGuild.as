package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Guild invitation.
 */
public class InvitedToGuild extends ServerMessage {

    public var name_:String;
    public var guildName_:String;

    public function InvitedToGuild(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.name_ = data.readUTF();
        this.guildName_ = data.readUTF();
    }

    override public function toString():String {
        return (formatToString("INVITEDTOGUILD", "name_", "guildName_"));
    }

}
}
