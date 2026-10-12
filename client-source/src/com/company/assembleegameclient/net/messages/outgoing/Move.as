package com.company.assembleegameclient.net.messages.outgoing {

    import com.company.assembleegameclient.net.messages.data._Q_0;
    import com.company.assembleegameclient.net.messages.data._jg;

    import flash.utils.IDataOutput;

    public class Move extends OutgoingMessage {

        public var tickId_:int;
        public var time_:int;
        public var newPosition_:_Q_0;
        public var records_:Vector.<_jg>;

        public function Move(id:uint) {
            this.newPosition_ = new _Q_0();
            this.records_ = new Vector.<_jg>();
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.tickId_);
            output.writeInt(this.time_);
            this.newPosition_.writeToOutput(output);
            output.writeShort(this.records_.length);
            for (var i:int = 0; i < this.records_.length; i++) {
                this.records_[i].writeToOutput(output);
            }
        }

        override public function toString():String {
            return formatToString("MOVE", "tickId_", "time_", "newPosition_", "records_");
        }

    }
}
