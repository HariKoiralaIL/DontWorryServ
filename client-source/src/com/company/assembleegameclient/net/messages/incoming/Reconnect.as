package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.ByteArray;
import flash.utils.IDataInput;

/**
 * Instructs the client to reconnect to another host / game.
 */
public class Reconnect extends ServerMessage {

    public var name_:String;
    public var host_:String;
    public var port_:int;
    public var gameId_:int;
    public var keyTime_:int;
    public var key_:ByteArray;

    public function Reconnect(id:uint) {
        this.key_ = new ByteArray();
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.name_ = data.readUTF();
        this.host_ = data.readUTF();
        this.port_ = data.readInt();
        this.gameId_ = data.readInt();
        this.keyTime_ = data.readInt();
        var keyLength:int = data.readShort();
        this.key_.length = 0;
        data.readBytes(this.key_, 0, keyLength);
    }

    override public function toString():String {
        return (formatToString("RECONNECT", "name_", "host_", "port_", "gameId_", "keyTime_", "key_"));
    }

}
}
