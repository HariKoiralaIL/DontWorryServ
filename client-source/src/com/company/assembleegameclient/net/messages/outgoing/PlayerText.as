package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class PlayerText extends OutgoingMessage {

        public var text_:String;

        public function PlayerText(id:uint) {
            this.text_ = "";
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeUTF(this.text_);
        }

        override public function toString():String {
            return formatToString("PLAYERTEXT", "text_");
        }

    }
}
