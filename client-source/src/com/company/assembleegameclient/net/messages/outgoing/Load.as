package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class Load extends OutgoingMessage {

        public var charId_:int;

        public function Load(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.charId_);
        }

        override public function toString():String {
            return formatToString("LOAD", "charId_");
        }

    }
}
