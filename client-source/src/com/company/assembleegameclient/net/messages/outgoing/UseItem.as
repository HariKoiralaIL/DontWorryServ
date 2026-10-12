package com.company.assembleegameclient.net.messages.outgoing {

    import com.company.assembleegameclient.net.messages.data.SlotObjectData;
    import com.company.assembleegameclient.net.messages.data.LocationData;

    import flash.utils.IDataOutput;

    public class UseItem extends OutgoingMessage {

        public var time_:int;
        public var slotObject_:SlotObjectData;
        public var itemUsePos_:LocationData;

        public function UseItem(id:uint) {
            this.slotObject_ = new SlotObjectData();
            this.itemUsePos_ = new LocationData();
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.time_);
            this.slotObject_.writeToOutput(output);
            this.itemUsePos_.writeToOutput(output);
        }

        override public function toString():String {
            return formatToString("USEITEM", "slotObject_", "itemUsePos_");
        }

    }
}
