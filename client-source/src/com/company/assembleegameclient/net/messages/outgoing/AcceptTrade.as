package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class AcceptTrade extends OutgoingMessage {

        public var myOffer_:Vector.<Boolean>;
        public var yourOffer_:Vector.<Boolean>;

        public function AcceptTrade(id:uint) {
            this.myOffer_ = new Vector.<Boolean>();
            this.yourOffer_ = new Vector.<Boolean>();
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            var i:int;
            output.writeShort(this.myOffer_.length);
            for (i = 0; i < this.myOffer_.length; i++) {
                output.writeBoolean(this.myOffer_[i]);
            }
            output.writeShort(this.yourOffer_.length);
            for (i = 0; i < this.yourOffer_.length; i++) {
                output.writeBoolean(this.yourOffer_[i]);
            }
        }

        override public function toString():String {
            return formatToString("ACCEPTTRADE", "myOffer_", "yourOffer_");
        }

    }
}
