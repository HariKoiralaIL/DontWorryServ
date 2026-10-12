package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class EnemyHit extends OutgoingMessage {

        public var time_:int;
        public var bulletId_:uint;
        public var targetId_:int;
        public var kill_:Boolean;
        public var dmg_:int;

        public function EnemyHit(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.time_);
            output.writeByte(this.bulletId_);
            output.writeInt(this.targetId_);
            output.writeBoolean(this.kill_);
            output.writeInt(this.dmg_);
        }

        override public function toString():String {
            return formatToString("ENEMYHIT", "time_", "bulletId_", "targetId_", "kill_", "dmg_");
        }

    }
}
