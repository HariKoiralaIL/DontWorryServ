package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class Escape extends OutgoingMessage {

        public function Escape(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
        }

        override public function toString():String {
            return formatToString("ESCAPE");
        }

    }
}
