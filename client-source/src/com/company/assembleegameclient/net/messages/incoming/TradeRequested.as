package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Another player asked to trade.
 */
public class TradeRequested extends ServerMessage {

    public var name_:String;

    public function TradeRequested(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.name_ = data.readUTF();
    }

    override public function toString():String {
        return (formatToString("TRADEREQUESTED", "name_"));
    }

}
}
