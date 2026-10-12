package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class SquareHit extends OutgoingMessage {

        public var time_:int;
        public var bulletId_:uint;
        public var objectId_:int;

        public function SquareHit(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.time_);
            output.writeByte(this.bulletId_);
            output.writeInt(this.objectId_);
        }

        override public function toString():String {
            return formatToString("SQUAREHIT", "time_", "bulletId_", "objectId_");
        }

    }
}
