package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class ChangeGuildRank extends OutgoingMessage {

        public var name_:String;
        public var guildRank_:int;

        public function ChangeGuildRank(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeUTF(this.name_);
            output.writeInt(this.guildRank_);
        }

        override public function toString():String {
            return formatToString("CHANGEGUILDRANK", "name_", "guildRank_");
        }

    }
}
