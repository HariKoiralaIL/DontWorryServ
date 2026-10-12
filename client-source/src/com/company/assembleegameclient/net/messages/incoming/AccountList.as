package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * List of account ids belonging to a named list (e.g. friends / ignored).
 */
public class AccountList extends ServerMessage {

    public var accountListId_:int;
    public var accountIds_:Vector.<int>;

    public function AccountList(id:uint) {
        this.accountIds_ = new Vector.<int>();
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        var count:int;
        var i:int;
        this.accountListId_ = data.readInt();
        this.accountIds_.length = 0;
        count = data.readShort();
        for (i = 0; i < count; i++) {
            this.accountIds_.push(data.readInt());
        }
    }

    override public function toString():String {
        return (formatToString("ACCOUNTLIST", "accountListId_", "accountIds_"));
    }

}
}
