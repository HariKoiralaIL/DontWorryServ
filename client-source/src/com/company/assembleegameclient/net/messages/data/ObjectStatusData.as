package com.company.assembleegameclient.net.messages.data {
import com.company.assembleegameclient.util._wW_;

import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class ObjectStatusData {

    public var objectId_:int;
    public var pos_:LocationData;
    public var stats_:Vector.<StatData>;

    public function ObjectStatusData() {
        this.pos_ = new LocationData();
        this.stats_ = new Vector.<StatData>();
    }

    public function parseFromInput(input:IDataInput):void {
        this.objectId_ = input.readInt();
        this.pos_.parseFromInput(input);
        var count:int = input.readShort();
        var i:int;
        // Recycle surplus StatData objects, then grow the list from the pool as needed.
        for (i = count; i < this.stats_.length; i++) {
            _wW_._ay(this.stats_[i]);
        }
        this.stats_.length = Math.min(count, this.stats_.length);
        while (this.stats_.length < count) {
            this.stats_.push(_wW_._B_1(StatData) as StatData);
        }
        for (i = 0; i < count; i++) {
            this.stats_[i].parseFromInput(input);
        }
    }

    public function writeToOutput(output:IDataOutput):void {
        output.writeInt(this.objectId_);
        this.pos_.writeToOutput(output);
        output.writeShort(this.stats_.length);
        for (var i:int = 0; i < this.stats_.length; i++) {
            this.stats_[i].writeToOutput(output);
        }
    }

    public function toString():String {
        return "objectId_: " + this.objectId_ + " pos_: " + this.pos_ + " stats_: " + this.stats_;
    }

}
}
