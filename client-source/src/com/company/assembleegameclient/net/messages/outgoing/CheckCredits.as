package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class CheckCredits extends OutgoingMessage {

        public function CheckCredits(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
        }

        override public function toString():String {
            return formatToString("CHECKCREDITS");
        }

    }
}
