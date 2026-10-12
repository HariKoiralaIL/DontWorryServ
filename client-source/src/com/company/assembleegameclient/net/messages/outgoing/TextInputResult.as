package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class TextInputResult extends OutgoingMessage {

        public var success_:Boolean;
        public var action_:String;
        public var input_:String;

        public function TextInputResult(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeBoolean(this.success_);
            output.writeUTF(this.action_);
            output.writeUTF(this.input_);
        }

        override public function toString():String {
            return formatToString("TEXTINPUTRESULT", "success_", "action_", "input_");
        }

    }
}
