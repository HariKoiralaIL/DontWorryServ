package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Server heartbeat; the client answers with the same serial.
 */
public class Ping extends ServerMessage {

    public var serial_:int;

    public function Ping(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.serial_ = data.readInt();
    }

    override public function toString():String {
        return (formatToString("PING", "serial_"));
    }

}
}
