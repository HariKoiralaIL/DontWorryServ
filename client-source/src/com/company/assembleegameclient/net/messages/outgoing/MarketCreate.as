package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class MarketCreate extends OutgoingMessage {

        public var includedSlots_:Vector.<int>;
        public var requestItems_:Vector.<int>;
        public var requestData_:Vector.<Object>;

        public function MarketCreate(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.includedSlots_.length);
            for each (var slot:int in this.includedSlots_) {
                output.writeInt(slot);
            }
            output.writeInt(this.requestItems_.length);
            for each (var item:int in this.requestItems_) {
                output.writeInt(item);
            }
            output.writeInt(this.requestData_.length);
            for each (var data:Object in this.requestData_) {
                output.writeUTF(JSON.stringify(data));
            }
        }

        override public function toString():String {
            return formatToString("MARKETCREATE", "includedSlots_", "requestItems_", "requestData_");
        }

    }
}
