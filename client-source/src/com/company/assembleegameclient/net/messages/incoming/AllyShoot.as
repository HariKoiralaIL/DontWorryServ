package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * An ally's bullet.
 */
public class AllyShoot extends ServerMessage {

    public var bulletId_:uint;
    public var ownerId_:int;
    public var containerType_:int;
    public var angle_:Number;
    public var dmg_:int;

    public function AllyShoot(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.bulletId_ = data.readUnsignedByte();
        this.ownerId_ = data.readInt();
        this.containerType_ = data.readShort();
        this.angle_ = data.readFloat();
        this.dmg_ = data.readInt();
    }

    override public function toString():String {
        return (formatToString("ALLYSHOOT", "bulletId_", "ownerId_", "containerType_", "angle_", "dmg_"));
    }

}
}
