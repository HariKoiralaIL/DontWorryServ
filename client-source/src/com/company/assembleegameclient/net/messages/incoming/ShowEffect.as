package com.company.assembleegameclient.net.messages.incoming {
import com.company.assembleegameclient.net.messages.data.LocationData;
import flash.utils.IDataInput;

/**
 * Visual effect at an object or between two positions.
 */
public class ShowEffect extends ServerMessage {

    public static const UNKNOWN_EFFECT:int = 0;
    public static const HEAL_EFFECT:int = 1;
    public static const TELEPORT_EFFECT:int = 2;
    public static const STREAM_EFFECT:int = 3;
    public static const THROW_EFFECT:int = 4;
    public static const NOVA_EFFECT:int = 5;
    public static const POISON_EFFECT:int = 6;
    public static const LINE_EFFECT:int = 7;
    public static const BURST_EFFECT:int = 8;
    public static const FLOW_EFFECT:int = 9;
    public static const RING_EFFECT:int = 10;
    public static const LIGHTNING_EFFECT:int = 11;
    public static const COLLAPSE_EFFECT:int = 12;
    public static const CONEBLAST_EFFECT:int = 13;
    public static const JITTER_EFFECT:int = 14;
    public static const FLASH_EFFECT:int = 15;
    public static const THROW_PROJECTILE_EFFECT:int = 16;

    public var effectType_:uint;
    public var targetObjectId_:int;
    public var pos1_:LocationData;
    public var pos2_:LocationData;
    public var color_:int;

    public function ShowEffect(id:uint) {
        this.pos1_ = new LocationData();
        this.pos2_ = new LocationData();
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.effectType_ = data.readUnsignedByte();
        this.targetObjectId_ = data.readInt();
        this.pos1_.parseFromInput(data);
        this.pos2_.parseFromInput(data);
        this.color_ = data.readInt();
    }

    override public function toString():String {
        return (formatToString("SHOW_EFFECT", "effectType_", "targetObjectId_", "pos1_", "pos2_", "color_"));
    }

}
}
