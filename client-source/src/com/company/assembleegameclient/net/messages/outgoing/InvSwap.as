package com.company.assembleegameclient.net.messages.outgoing {

    import com.company.assembleegameclient.net.messages.data._0_3;
    import com.company.assembleegameclient.net.messages.data._Q_0;

    import flash.utils.IDataOutput;

    public class InvSwap extends OutgoingMessage {

        public var time_:int;
        public var position_:_Q_0;
        public var slotObject1_:_0_3;
        public var slotObject2_:_0_3;

        public function InvSwap(id:uint) {
            this.position_ = new _Q_0();
            this.slotObject1_ = new _0_3();
            this.slotObject2_ = new _0_3();
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.time_);
            this.position_.writeToOutput(output);
            this.slotObject1_.writeToOutput(output);
            this.slotObject2_.writeToOutput(output);
        }

        override public function toString():String {
            return formatToString("INVSWAP", "time_", "position_", "slotObject1_", "slotObject2_");
        }

    }
}
