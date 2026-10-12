package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class JoinGuild extends OutgoingMessage {

        public var guildName_:String;

        public function JoinGuild(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeUTF(this.guildName_);
        }

        override public function toString():String {
            return formatToString("JOINGUILD", "guildName_");
        }

    }
}
