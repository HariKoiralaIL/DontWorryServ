package client.events {
import com.company.assembleegameclient.net.Server;

import flash.events.Event;
import flash.utils.ByteArray;

/** Requests a reconnect to a game server. Carries the same data as GameInitData. */
public class ReconnectEvent extends Event {

    public static const RECONNECT:String = "RECONNECT_EVENT";

    public var server_:Server;
    public var gameId_:int;
    public var createCharacter_:Boolean;
    public var charId_:int;
    public var keyTime_:int;
    public var key_:ByteArray;

    public function ReconnectEvent(server:Server, gameId:int, createCharacter:Boolean, charId:int, keyTime:int, key:ByteArray) {
        super(RECONNECT);
        server_ = server;
        gameId_ = gameId;
        createCharacter_ = createCharacter;
        charId_ = charId;
        keyTime_ = keyTime;
        key_ = key;
    }

    override public function clone():Event {
        return new ReconnectEvent(server_, gameId_, createCharacter_, charId_, keyTime_, key_);
    }

    override public function toString():String {
        return formatToString(RECONNECT, "server_", "gameId_", "charId_", "keyTime_", "key_");
    }

}
}
