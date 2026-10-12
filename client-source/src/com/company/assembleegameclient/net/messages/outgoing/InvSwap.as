package com.company.assembleegameclient.net.messages.outgoing {

    import com.company.assembleegameclient.net.messages.data.SlotObjectData;
    import com.company.assembleegameclient.net.messages.data.LocationData;

    import flash.utils.IDataOutput;

    public class InvSwap extends OutgoingMessage {

        public var time_:int;
        public var position_:LocationData;
        public var slotObject1_:SlotObjectData;
        public var slotObject2_:SlotObjectData;

        public function InvSwap(id:uint) {
            this.position_ = new LocationData();
            this.slotObject1_ = new SlotObjectData();
            this.slotObject2_ = new SlotObjectData();
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
