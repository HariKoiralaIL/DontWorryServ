package com.company.assembleegameclient.net.messages.data {
import flash.utils.IDataInput;

public class GroundTileData {

    public var x_:int;
    public var y_:int;
    public var type_:uint;

    public function parseFromInput(input:IDataInput):void {
        this.x_ = input.readShort();
        this.y_ = input.readShort();
        this.type_ = input.readUnsignedByte();
    }

    public function toString():String {
        return "x_: " + this.x_ + " y_: " + this.y_ + " type_:" + this.type_;
    }

}
}
