package client.game {
import com.company.assembleegameclient.net.Server;

import flash.utils.ByteArray;

/** Parameters needed to connect to a game server and enter a game. */
public class GameInitData {

    /** Server to connect to. */
    public var server:Server;

    /** Id of the game to join. */
    public var gameId:int;

    /** True when a new character should be created instead of using an existing one. */
    public var createCharacter:Boolean;

    /** Id of the character to play. */
    public var charId:int;

    /** Time value associated with {@link #key}. */
    public var keyTime:int;

    /** Key sent to the game server when connecting. */
    public var key:ByteArray;

    /** True when this is a new game rather than a reconnect. */
    public var isNewGame:Boolean;

}
}
