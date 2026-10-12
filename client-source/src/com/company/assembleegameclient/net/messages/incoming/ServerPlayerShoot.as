package com.company.assembleegameclient.net.messages.incoming {
import com.company.assembleegameclient.net.messages.data._Q_0;
import flash.utils.IDataInput;

/**
 * Another player's bullet, fired from the server's point of view.
 */
public class ServerPlayerShoot extends ServerMessage {

    public var bulletId_:uint;
    public var ownerId_:int;
    public var containerType_:int;
    public var startingPos_:_Q_0;
    public var angle_:Number;
    public var damage_:int;

    public function ServerPlayerShoot(id:uint) {
        this.startingPos_ = new _Q_0();
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.bulletId_ = data.readUnsignedByte();
        this.ownerId_ = data.readInt();
        this.containerType_ = data.readShort();
        this.startingPos_.parseFromInput(data);
        this.angle_ = data.readFloat();
        this.damage_ = data.readShort();
    }

    override public function toString():String {
        return (formatToString("SERVERPLAYERSHOOT", "bulletId_", "ownerId_", "containerType_", "startingPos_", "angle_", "damage_"));
    }

}
}
