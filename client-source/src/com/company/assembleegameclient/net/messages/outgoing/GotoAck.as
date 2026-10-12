package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class GotoAck extends OutgoingMessage {

        public var time_:int;

        public function GotoAck(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.time_);
        }

        override public function toString():String {
            return formatToString("GOTOACK", "time_");
        }

    }
}
