package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Damage dealt to a target.
 */
public class Damage extends ServerMessage {

    public var targetId_:int;
    public var effects_:Vector.<uint>;
    public var damageAmount_:int;
    public var kill_:Boolean;
    public var bulletId_:uint;
    public var objectId_:int;

    public function Damage(id:uint) {
        this.effects_ = new Vector.<uint>();
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        var effectCount:int;
        var i:uint;
        this.targetId_ = data.readInt();
        this.effects_.length = 0;
        effectCount = data.readUnsignedByte();
        for (i = 0; i < effectCount; i++) {
            this.effects_.push(data.readUnsignedByte());
        }
        this.damageAmount_ = data.readUnsignedShort();
        this.kill_ = data.readBoolean();
        this.bulletId_ = data.readUnsignedByte();
        this.objectId_ = data.readInt();
    }

    override public function toString():String {
        return (formatToString("DAMAGE", "targetId_", "effects_", "damageAmount_", "kill_", "bulletId_", "objectId_"));
    }

}
}
