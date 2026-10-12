package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Result code of an inventory operation.
 */
public class InvResult extends ServerMessage {

    public var result_:int;

    public function InvResult(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.result_ = data.readInt();
    }

    override public function toString():String {
        return (formatToString("INVRESULT", "result_"));
    }

}
}
