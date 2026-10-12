package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class RequestTrade extends OutgoingMessage {

        public var name_:String;

        public function RequestTrade(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeUTF(this.name_);
        }

        override public function toString():String {
            return formatToString("REQUESTTRADE", "name_");
        }

    }
}
