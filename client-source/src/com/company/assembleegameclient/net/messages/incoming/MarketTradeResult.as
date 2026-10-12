package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Result of a market trade request.
 */
public class MarketTradeResult extends ServerMessage {

    public var success_:Boolean;
    public var errorText_:String;

    public function MarketTradeResult(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.success_ = data.readBoolean();
        this.errorText_ = data.readUTF();
    }

    override public function toString():String {
        return (formatToString("MARKETTRADERESULT", "success_", "errorText_"));
    }

}
}
