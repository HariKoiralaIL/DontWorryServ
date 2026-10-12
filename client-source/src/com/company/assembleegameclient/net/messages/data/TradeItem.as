package com.company.assembleegameclient.net.messages.data {
import flash.utils.IDataInput;

public class TradeItem {

    public var item_:int;
    public var data_:String;
    public var slotType_:int;
    public var tradeable_:Boolean;
    public var included_:Boolean;

    public function parseFromInput(input:IDataInput):void {
        this.item_ = input.readInt();
        this.data_ = input.readUTF();
        this.slotType_ = input.readInt();
        this.tradeable_ = input.readBoolean();
        this.included_ = input.readBoolean();
    }

    public function toString():String {
        return "item: " + this.item_ + " data: " + this.data_ + " slotType: " + this.slotType_
                + " tradeable: " + this.tradeable_ + " included:" + this.included_;
    }

}
}
