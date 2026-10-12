package com.company.assembleegameclient.net.messages.incoming {
import com.company.assembleegameclient.net.messages.data.ObjectStatusData;
import com.company.assembleegameclient.util._wW_;
import flash.utils.IDataInput;

/**
 * Per-tick batch of object status updates.
 */
public class NewTick extends ServerMessage {

    public var tickId_:int;
    public var tickTime_:int;
    public var statuses_:Vector.<ObjectStatusData>;

    public function NewTick(id:uint) {
        this.statuses_ = new Vector.<ObjectStatusData>();
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        var count:int;
        var i:int;
        this.tickId_ = data.readInt();
        this.tickTime_ = data.readInt();
        count = data.readShort();
        for (i = count; i < this.statuses_.length; i++) {
            _wW_._ay(this.statuses_[i]);
        }
        this.statuses_.length = Math.min(count, this.statuses_.length);
        while (this.statuses_.length < count) {
            this.statuses_.push((_wW_._B_1(ObjectStatusData) as ObjectStatusData));
        }
        for (i = 0; i < count; i++) {
            this.statuses_[i].parseFromInput(data);
        }
    }

    override public function toString():String {
        return (formatToString("NEW_TICK", "tickId_", "tickTime_", "statuses_"));
    }

}
}
