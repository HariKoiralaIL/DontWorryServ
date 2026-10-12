package com.company.assembleegameclient.net.messages.outgoing {

    import com.company.assembleegameclient.net.messages.data._Q_0;

    import flash.utils.IDataOutput;

    public class AoeAck extends OutgoingMessage {

        public var time_:int;
        public var position_:_Q_0;

        public function AoeAck(id:uint) {
            this.position_ = new _Q_0();
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.time_);
            this.position_.writeToOutput(output);
        }

        override public function toString():String {
            return formatToString("AOEACK", "time_", "position_");
        }

    }
}
