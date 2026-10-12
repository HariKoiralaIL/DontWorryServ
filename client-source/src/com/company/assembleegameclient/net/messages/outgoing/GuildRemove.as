package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class GuildRemove extends OutgoingMessage {

        public var name_:String;

        public function GuildRemove(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeUTF(this.name_);
        }

        override public function toString():String {
            return formatToString("GUILDREMOVE", "name_");
        }

    }
}
