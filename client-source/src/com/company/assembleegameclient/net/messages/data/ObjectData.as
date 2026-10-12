package com.company.assembleegameclient.net.messages.data {
import flash.utils.IDataInput;

public class ObjectData {

    public var objectType_:int;
    public var status_:ObjectStatusData;

    public function ObjectData() {
        this.status_ = new ObjectStatusData();
    }

    public function parseFromInput(input:IDataInput):void {
        this.objectType_ = input.readShort();
        this.status_.parseFromInput(input);
    }

    public function toString():String {
        return "objectType_: " + this.objectType_ + " status_: " + this.status_;
    }

}
}
