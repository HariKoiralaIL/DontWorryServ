package com.company.assembleegameclient.net.messages.outgoing {

    import com.company.assembleegameclient.net.messages.data._Q_0;

    import flash.utils.IDataOutput;

    public class PlayerShoot extends OutgoingMessage {

        public var time_:int;
        public var bulletId_:uint;
        public var containerType_:int;
        public var startingPos_:_Q_0;
        public var angle_:Number;

        public function PlayerShoot(id:uint) {
            this.startingPos_ = new _Q_0();
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.time_);
            output.writeByte(this.bulletId_);
            output.writeShort(this.containerType_);
            this.startingPos_.writeToOutput(output);
            output.writeFloat(this.angle_);
        }

        override public function toString():String {
            return formatToString("PLAYERSHOOT", "time_", "bulletId_", "containerType_", "startingPos_", "angle_");
        }

    }
}
