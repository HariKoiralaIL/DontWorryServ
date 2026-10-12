package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class Create extends OutgoingMessage {

        public var objectType_:int;

        public function Create(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeShort(this.objectType_);
        }

        override public function toString():String {
            return formatToString("CREATE", "objectType_");
        }

    }
}
