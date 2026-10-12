package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class CancelTrade extends OutgoingMessage {

        public var objectId_:int;

        public function CancelTrade(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
        }

        override public function toString():String {
            return formatToString("CANCELTRADE");
        }

    }
}
