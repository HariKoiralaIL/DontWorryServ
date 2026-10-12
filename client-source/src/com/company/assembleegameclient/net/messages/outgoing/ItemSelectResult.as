package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class ItemSelectResult extends OutgoingMessage {

        public var slot_:int;

        public function ItemSelectResult(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.slot_);
        }

        override public function toString():String {
            return formatToString("ITEMSELECTRESULT", "slot_");
        }

    }
}
