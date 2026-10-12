package com.company.assembleegameclient.net.messages.data {
import flash.geom.Point;
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class LocationData {

    public var x_:Number;
    public var y_:Number;

    public function toPoint():Point {
        return new Point(this.x_, this.y_);
    }

    public function parseFromInput(input:IDataInput):void {
        this.x_ = input.readFloat();
        this.y_ = input.readFloat();
    }

    public function writeToOutput(output:IDataOutput):void {
        output.writeFloat(this.x_);
        output.writeFloat(this.y_);
    }

    public function toString():String {
        return "x_: " + this.x_ + " y_: " + this.y_;
    }

}
}
