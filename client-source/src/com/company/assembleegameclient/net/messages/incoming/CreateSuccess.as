package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Character creation succeeded.
 */
public class CreateSuccess extends ServerMessage {

    public var objectId_:int;
    public var charId_:int;

    public function CreateSuccess(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.objectId_ = data.readInt();
        this.charId_ = data.readInt();
    }

    override public function toString():String {
        return (formatToString("CREATE_SUCCESS", "objectId_", "charId_"));
    }

}
}
