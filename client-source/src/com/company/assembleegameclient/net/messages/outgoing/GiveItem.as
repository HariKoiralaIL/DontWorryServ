package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class GiveItem extends OutgoingMessage {

        public var itemType_:int;
        public var itemData_:Object;

        public function GiveItem(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.itemType_);
            output.writeUTF(JSON.stringify(this.itemData_));
        }

        override public function toString():String {
            return formatToString("GIVEITEM", "itemType_", "itemData_");
        }

    }
}
