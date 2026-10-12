package com.company.assembleegameclient.net.messages.data {
import flash.utils.IDataOutput;

/** One timestamped player position sample, sent to the server with move packets. */
public class MoveRecord {

    public var time_:int;
    public var x_:Number;
    public var y_:Number;

    public function MoveRecord(time:int, x:Number, y:Number) {
        this.time_ = time;
        this.x_ = x;
        this.y_ = y;
    }

    public function writeToOutput(output:IDataOutput):void {
        output.writeInt(this.time_);
        output.writeFloat(this.x_);
        output.writeFloat(this.y_);
    }

    public function toString():String {
        return "time_: " + this.time_ + " x_: " + this.x_ + " y_: " + this.y_;
    }

}
}
