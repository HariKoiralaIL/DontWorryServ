package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class OtherHit extends OutgoingMessage {

        public var time_:int;
        public var bulletId_:uint;
        public var objectId_:int;
        public var targetId_:int;

        public function OtherHit(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.time_);
            output.writeByte(this.bulletId_);
            output.writeInt(this.objectId_);
            output.writeInt(this.targetId_);
        }

        override public function toString():String {
            return formatToString("OTHERHIT", "time_", "bulletId_", "objectId_", "targetId_");
        }

    }
}
