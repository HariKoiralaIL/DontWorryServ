package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class Pong extends OutgoingMessage {

        public var serial_:int;
        public var time_:int;

        public function Pong(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.serial_);
            output.writeInt(this.time_);
        }

        override public function toString():String {
            return formatToString("PONG", "serial_", "time_");
        }

    }
}
