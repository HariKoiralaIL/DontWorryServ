package com.company.assembleegameclient.net.messages.outgoing {

    import com.company.assembleegameclient.net.messages.data._0_3;
    import com.company.assembleegameclient.net.messages.data._Q_0;

    import flash.utils.IDataOutput;

    public class UseItem extends OutgoingMessage {

        public var time_:int;
        public var slotObject_:_0_3;
        public var itemUsePos_:_Q_0;

        public function UseItem(id:uint) {
            this.slotObject_ = new _0_3();
            this.itemUsePos_ = new _Q_0();
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.time_);
            this.slotObject_.writeToOutput(output);
            this.itemUsePos_.writeToOutput(output);
        }

        override public function toString():String {
            return formatToString("USEITEM", "slotObject_", "itemUsePos_");
        }

    }
}
