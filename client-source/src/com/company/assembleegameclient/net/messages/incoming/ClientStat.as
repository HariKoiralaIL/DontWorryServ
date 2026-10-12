package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Name/value stat update.
 */
public class ClientStat extends ServerMessage {

    public var name_:String;
    public var value_:int;

    public function ClientStat(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.name_ = data.readUTF();
        this.value_ = data.readInt();
    }

    override public function toString():String {
        return (formatToString("CLIENTSTAT", "name_", "value_"));
    }

}
}
