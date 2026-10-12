package com.company.assembleegameclient.net.messages.data {
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class SlotObjectData {

    public var objectId_:int;
    public var slotId_:int;
    public var objectType_:int;

    public function parseFromInput(input:IDataInput):void {
        this.objectId_ = input.readInt();
        this.slotId_ = input.readUnsignedByte();
        this.objectType_ = input.readShort();
    }

    public function writeToOutput(output:IDataOutput):void {
        output.writeInt(this.objectId_);
        output.writeByte(this.slotId_);
        output.writeShort(this.objectType_);
    }

    public function toString():String {
        return "objectId_: " + this.objectId_ + " slotId_: " + this.slotId_ + " objectType_: " + this.objectType_;
    }

}
}
