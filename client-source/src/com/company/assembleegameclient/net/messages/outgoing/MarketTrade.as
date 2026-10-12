package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class MarketTrade extends OutgoingMessage {

        public var tradeId_:int;

        public function MarketTrade(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.tradeId_);
        }

        override public function toString():String {
            return formatToString("MARKETTRADE", "tradeId_");
        }

    }
}
