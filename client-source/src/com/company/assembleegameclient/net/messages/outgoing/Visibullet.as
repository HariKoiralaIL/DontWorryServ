package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class Visibullet extends OutgoingMessage {

        public var damage_:int;
        public var enemyId_:int;
        public var bulletId_:uint;
        public var armorPiercing_:Boolean;

        public function Visibullet(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.damage_);
            output.writeInt(this.enemyId_);
            output.writeByte(this.bulletId_);
            output.writeBoolean(this.armorPiercing_);
        }

        override public function toString():String {
            return formatToString("VISIBULLET", "damage_", "enemyId_", "bulletId_", "armorPiercing_");
        }

    }
}
