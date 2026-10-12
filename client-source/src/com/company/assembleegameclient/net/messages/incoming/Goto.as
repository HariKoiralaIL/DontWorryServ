package com.company.assembleegameclient.net.messages.incoming {
import com.company.assembleegameclient.net.messages.data._Q_0;
import flash.utils.IDataInput;

/**
 * Move an object to a position.
 */
public class Goto extends ServerMessage {

    public var objectId_:int;
    public var pos_:_Q_0;

    public function Goto(id:uint) {
        this.pos_ = new _Q_0();
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
