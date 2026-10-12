package com.company.assembleegameclient.net.messages.incoming {
import com.company.net._098;

import flash.utils.IDataOutput;

/**
 * Base class for every message the server sends to the client.
 * Incoming messages are only ever parsed, never written, so serialising one is an error.
 */
public class ServerMessage extends _098 {

    public function ServerMessage(id:uint) {
        super(id);
    }

    final override public function writeToOutput(data:IDataOutput):void {
        throw (new Error(("Client should not send " + id_) + " messages"));
    }

}
}
