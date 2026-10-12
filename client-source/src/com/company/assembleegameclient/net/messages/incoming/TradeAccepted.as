package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Both sides' accepted-offer flags.
 */
public class TradeAccepted extends ServerMessage {

    public var myOffer_:Vector.<Boolean>;
    public var yourOffer_:Vector.<Boolean>;

    public function TradeAccepted(id:uint) {
        this.myOffer_ = new Vector.<Boolean>();
        this.yourOffer_ = new Vector.<Boolean>();
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        var count:int;
        var i:int;
        this.myOffer_.length = 0;
        count = data.readShort();
        for (i = 0; i < count; i++) {
            this.myOffer_.push(data.readBoolean());
        }
        this.yourOffer_.length = 0;
        count = data.readShort();
        for (i = 0; i < count; i++) {
            this.yourOffer_.push(data.readBoolean());
        }
    }

    override public function toString():String {
        return (formatToString("TRADEACCEPTED", "myOffer_", "yourOffer_"));
    }

}
}
