package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class PlayerHit extends OutgoingMessage {

        public var bulletId_:uint;
        public var objectId_:int;

        public function PlayerHit(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeByte(this.bulletId_);
            output.writeInt(this.objectId_);
        }

        override public function toString():String {
            return formatToString("PLAYERHIT", "bulletId_", "objectId_");
        }

    }
}
