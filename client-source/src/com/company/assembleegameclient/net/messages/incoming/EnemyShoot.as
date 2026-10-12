package com.company.assembleegameclient.net.messages.incoming {
import com.company.assembleegameclient.net.messages.data.LocationData;
import flash.utils.IDataInput;

/**
 * Enemy fires one or more bullets.
 */
public class EnemyShoot extends ServerMessage {

    public var bulletId_:uint;
    public var ownerId_:int;
    public var bulletType_:int;
    public var startingPos_:LocationData;
    public var angle_:Number;
    public var damage_:int;
    public var numShots_:int;
    public var angleInc_:Number;

    public function EnemyShoot(id:uint) {
        this.startingPos_ = new LocationData();
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.bulletId_ = data.readUnsignedByte();
        this.ownerId_ = data.readInt();
        this.bulletType_ = data.readUnsignedByte();
        this.startingPos_.parseFromInput(data);
        this.angle_ = data.readFloat();
        this.damage_ = data.readShort();
        if (data.bytesAvailable > 0) {
            this.numShots_ = data.readUnsignedByte();
            this.angleInc_ = data.readFloat();
        } else {
            this.numShots_ = 1;
            this.angleInc_ = 0;
        }
    }

    override public function toString():String {
        return (formatToString("ENEMYSHOOT", "bulletId_", "ownerId_", "bulletType_", "startingPos_", "angle_", "damage_", "numShots_", "angleInc_"));
    }

}
}
