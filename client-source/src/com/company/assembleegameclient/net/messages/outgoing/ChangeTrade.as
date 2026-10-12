package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class ChangeTrade extends OutgoingMessage {

        public var offer_:Vector.<Boolean>;

        public function ChangeTrade(id:uint) {
            this.offer_ = new Vector.<Boolean>();
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeShort(this.offer_.length);
            for (var i:int = 0; i < this.offer_.length; i++) {
                output.writeBoolean(this.offer_[i]);
            }
        }

        override public function toString():String {
            return formatToString("CHANGETRADE", "offer_");
        }

    }
}
