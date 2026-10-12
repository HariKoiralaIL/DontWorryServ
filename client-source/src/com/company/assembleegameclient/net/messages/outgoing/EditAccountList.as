package com.company.assembleegameclient.net.messages.outgoing {

    import flash.utils.IDataOutput;

    public class EditAccountList extends OutgoingMessage {

        public var accountListId_:int;
        public var add_:Boolean;
        public var objectId_:int;

        public function EditAccountList(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(this.accountListId_);
            output.writeBoolean(this.add_);
            output.writeInt(this.objectId_);
        }

        override public function toString():String {
            return formatToString("EDITACCOUNTLIST", "accountListId_", "add_", "objectId_");
        }

    }
}
