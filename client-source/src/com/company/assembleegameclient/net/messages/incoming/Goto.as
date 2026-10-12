package com.company.assembleegameclient.net.messages.incoming {
import com.company.assembleegameclient.net.messages.data.LocationData;
import flash.utils.IDataInput;

/**
 * Move an object to a position.
 */
public class Goto extends ServerMessage {

    public var objectId_:int;
    public var pos_:LocationData;

    public function Goto(id:uint) {
        this.pos_ = new LocationData();
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.objectId_ = data.readInt();
        this.pos_.parseFromInput(data);
    }

    override public function toString():String {
        return (formatToString("GOTO", "objectId_", "pos_"));
    }

}
}
