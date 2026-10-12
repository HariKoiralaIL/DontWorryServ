package com.company.assembleegameclient.net.messages.outgoing {

    import com.company.net._098;

    import flash.utils.IDataInput;

    /**
     * Base class for every message the client sends to the server.
     * Outgoing messages are write-only, so parsing is disabled.
     */
    public class OutgoingMessage extends _098 {

        public function OutgoingMessage(id:uint) {
            super(id);
        }

        final override public function parseFromInput(input:IDataInput):void {
            throw new Error("Client should not receive " + id_ + " messages");
        }

    }
}
