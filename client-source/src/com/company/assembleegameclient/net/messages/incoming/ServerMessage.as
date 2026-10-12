package com.company.assembleegameclient.net.messages.incoming {
import com.company.net.NetworkMessage;

import flash.utils.IDataOutput;

/**
 * Base class for every message the server sends to the client.
 * Incoming messages are only ever parsed, never written, so serialising one is an error.
 */
public class ServerMessage extends NetworkMessage {

    public function ServerMessage(id:uint) {
        super(id);
    }

    final override public function writeToOutput(data:IDataOutput):void {
        throw (new Error(("Client should not send " + id_) + " messages"));
    }

}
}
