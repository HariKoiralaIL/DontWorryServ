package com.company.assembleegameclient.net.messages.outgoing {

    import com.company.assembleegameclient.net.messages.data._0_3;

    import flash.utils.IDataOutput;

    public class InvDrop extends OutgoingMessage {

        public var slotObject_:_0_3;

        public function InvDrop(id:uint) {
            this.slotObject_ = new _0_3();
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
