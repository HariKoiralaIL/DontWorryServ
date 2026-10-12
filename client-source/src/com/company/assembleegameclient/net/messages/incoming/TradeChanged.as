package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * The other player's trade offer changed.
 */
public class TradeChanged extends ServerMessage {

    public var offer_:Vector.<Boolean>;

    public function TradeChanged(id:uint) {
        this.offer_ = new Vector.<Boolean>();
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        var count:int;
        var i:int;
        this.offer_.length = 0;
        count = data.readShort();
        for (i = 0; i < count; i++) {
            this.offer_.push(data.readBoolean());
        }
    }

    override public function toString():String {
        return (formatToString("TRADECHANGED", "offer_"));
    }

}
}
