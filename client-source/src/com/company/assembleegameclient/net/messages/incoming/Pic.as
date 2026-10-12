package com.company.assembleegameclient.net.messages.incoming {
import flash.display.BitmapData;
import flash.utils.ByteArray;
import flash.utils.IDataInput;

/**
 * Raw RGBA bitmap sent by the server.
 */
public class Pic extends ServerMessage {

    public var bitmapData_:BitmapData = null;

    public function Pic(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        var width:int = data.readInt();
        var height:int = data.readInt();
        var pixels:ByteArray = new ByteArray();
        data.readBytes(pixels, 0, ((width * height) * 4));
        this.bitmapData_ = new BitmapData(width, height);
        this.bitmapData_.setPixels(this.bitmapData_.rect, pixels);
    }

    override public function toString():String {
        return (formatToString("PIC", "bitmapData_"));
    }

}
}
