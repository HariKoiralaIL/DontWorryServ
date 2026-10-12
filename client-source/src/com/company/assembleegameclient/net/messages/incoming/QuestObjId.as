package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Id of the object currently marked as the quest target.
 */
public class QuestObjId extends ServerMessage {

    public var objectId_:int;

    public function QuestObjId(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.objectId_ = data.readInt();
    }

    override public function toString():String {
        return (formatToString("QUESTOBJID", "objectId_"));
    }

}
}
