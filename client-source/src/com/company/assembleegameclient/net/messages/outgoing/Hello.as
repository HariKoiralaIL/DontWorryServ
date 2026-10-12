package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.ByteArray;
    import flash.utils.IDataOutput;

    public class Hello extends OutgoingMessage {

        public var copyright_:String;
        public var _5c2_:String;
        public var buildVersion_:String;
        public var gameId_:int = 0;
        public var guid_:String;
        public var password_:String;
        public var secret_:String;
        public var keyTime_:int = 0;
        public var key_:ByteArray;
        public var mapJSON_:String;
        public var _8U_:String = "";
        public var _yt:String = "";
        public var _J_k:String = "";
        public var playPlatform:String = "";

        public function Hello(id:uint) {
            this.copyright_ = "";
            this._5c2_ = "";
            this.buildVersion_ = "";
            this.guid_ = "";
            this.password_ = "";
            this.secret_ = "";
            this.key_ = new ByteArray();
            this.mapJSON_ = "";
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeUTF(this.copyright_);
            output.writeUTF(this._5c2_);
            output.writeUTF(this.buildVersion_);
            output.writeInt(this.gameId_);
            output.writeUTF(this.guid_);
            output.writeUTF(this.password_);
            output.writeUTF(this.secret_);
            output.writeInt(this.keyTime_);
            output.writeShort(this.key_.length);
            output.writeBytes(this.key_);
            output.writeInt(this.mapJSON_.length);
            output.writeUTFBytes(this.mapJSON_);
            output.writeUTF(this._8U_);
            output.writeUTF(this._yt);
            output.writeUTF(this._J_k);
            output.writeUTF(this.playPlatform);
        }

        override public function toString():String {
            return formatToString("HELLO", "copyright_", "_5c2_", "buildVersion_", "gameId_", "guid_", "password_", "secret_");
        }

    }
}
