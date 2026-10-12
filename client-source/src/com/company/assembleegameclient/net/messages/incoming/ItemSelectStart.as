package com.company.assembleegameclient.net.messages.incoming {
import com.company.assembleegameclient.net.messages.data.TradeItem;
import com.company.assembleegameclient.util._wW_;
import flash.utils.IDataInput;

/**
 * Item selection window opened with the player's items.
 */
public class ItemSelectStart extends ServerMessage {

    public var myItems_:Vector.<TradeItem>;

    public function ItemSelectStart(id:uint) {
        this.myItems_ = new Vector.<TradeItem>();
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        var count:int;
        var i:int;
        count = data.readShort();
        for (i = count; i < this.myItems_.length; i++) {
            _wW_._ay(this.myItems_[i]);
        }
        this.myItems_.length = Math.min(count, this.myItems_.length);
        while (this.myItems_.length < count) {
            this.myItems_.push((_wW_._B_1(TradeItem) as TradeItem));
        }
        for (i = 0; i < count; i++) {
            this.myItems_[i].parseFromInput(data);
        }
    }

    override public function toString():String {
        return (formatToString("ITEMSELECTSTART", "myItems_"));
    }

}
}
