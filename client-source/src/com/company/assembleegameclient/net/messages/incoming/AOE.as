package com.company.assembleegameclient.net.messages.incoming {
import com.company.assembleegameclient.net.messages.data.LocationData;
import flash.utils.IDataInput;

/**
 * Area-of-effect hit at a position.
 */
public class AOE extends ServerMessage {

    public var pos_:LocationData;
    public var radius_:Number;
    public var damage_:int;
    public var effect_:int;
    public var duration_:Number;
    public var origType_:int;

    public function AOE(id:uint) {
        this.pos_ = new LocationData();
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.pos_.parseFromInput(data);
        this.radius_ = data.readFloat();
        this.damage_ = data.readUnsignedShort();
        this.effect_ = data.readUnsignedByte();
        this.duration_ = data.readFloat();
        this.origType_ = data.readUnsignedShort();
    }

    override public function toString():String {
        return (formatToString("AOE", "pos_", "radius_", "damage_", "effect_", "duration_", "origType_"));
    }

}
}
