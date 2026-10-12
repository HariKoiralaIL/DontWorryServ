package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class ShootAck extends OutgoingMessage {

        public var time_:int;

        public function ShootAck(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.time_);
        }

        override public function toString():String {
            return formatToString("SHOOTACK", "time_");
        }

    }
}
