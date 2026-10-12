package com.company.assembleegameclient.net.messages.outgoing {

    import com.company.assembleegameclient.net.messages.data.SlotObjectData;

    import flash.utils.IDataOutput;

    public class InvDrop extends OutgoingMessage {

        public var slotObject_:SlotObjectData;

        public function InvDrop(id:uint) {
            this.slotObject_ = new SlotObjectData();
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            this.slotObject_.writeToOutput(output);
        }

        override public function toString():String {
            return formatToString("INVDROP", "slotObject_");
        }

    }
}
