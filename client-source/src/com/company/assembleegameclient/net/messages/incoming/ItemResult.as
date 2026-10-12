package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Item lookup result (item id + serialised data).
 */
public class ItemResult extends ServerMessage {

    public var item_:int;
    public var data_:String;

    public function ItemResult(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.item_ = data.readInt();
        this.data_ = data.readUTF();
    }

    override public function toString():String {
        return (formatToString("ITEMRESULT", "item_", "data_"));
    }

}
}
