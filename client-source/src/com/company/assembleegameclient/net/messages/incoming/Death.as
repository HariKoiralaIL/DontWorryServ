package com.company.assembleegameclient.net.messages.incoming {
import flash.display.BitmapData;
import flash.utils.IDataInput;

/**
 * Player death notice.
 */
public class Death extends ServerMessage {

    public var accountId_:int;
    public var charId_:int;
    public var killedBy_:String;
    /** Set by the client after parsing; not part of the wire format. */
    public var background:BitmapData;

    public function Death(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.accountId_ = data.readInt();
        this.charId_ = data.readInt();
        this.killedBy_ = data.readUTF();
    }

    override public function toString():String {
        return (formatToString("DEATH", "accountId_", "charId_", "killedBy_"));
    }

}
}
