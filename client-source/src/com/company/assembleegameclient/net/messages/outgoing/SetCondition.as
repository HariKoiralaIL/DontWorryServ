package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class SetCondition extends OutgoingMessage {

        public var conditionEffect_:uint;
        public var conditionDuration_:Number;

        public function SetCondition(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeByte(this.conditionEffect_);
            output.writeFloat(this.conditionDuration_);
        }

        override public function toString():String {
            return formatToString("SETCONDITION", "conditionEffect_", "conditionDuration_");
        }

    }
}
