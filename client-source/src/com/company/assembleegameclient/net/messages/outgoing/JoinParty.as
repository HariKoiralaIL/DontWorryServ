package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class JoinParty extends OutgoingMessage {

        public var partyID_:int;

        public function JoinParty(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.partyID_);
        }

        override public function toString():String {
            return formatToString("JOINPARTY", "partyID_");
        }

    }
}
