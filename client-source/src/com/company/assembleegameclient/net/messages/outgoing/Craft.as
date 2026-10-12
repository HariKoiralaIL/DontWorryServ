package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class Craft extends OutgoingMessage {

        public var objectId_:int;

        public function Craft(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.objectId_);
        }

        override public function toString():String {
            return formatToString("CRAFT", "objectId_");
        }

    }
}
