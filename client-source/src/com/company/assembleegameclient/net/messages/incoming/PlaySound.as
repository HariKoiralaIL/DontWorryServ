package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Play a sound effect at an object.
 */
public class PlaySound extends ServerMessage {

    public var ownerId_:int;
    public var soundId_:int;

    public function PlaySound(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.ownerId_ = data.readInt();
        this.soundId_ = data.readUnsignedByte();
    }

    override public function toString():String {
        return (formatToString("PLAYSOUND", "ownerId_", "soundId_"));
    }

}
}
