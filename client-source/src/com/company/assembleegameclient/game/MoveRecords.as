package com.company.assembleegameclient.game {

import com.company.assembleegameclient.net.messages.data._jg;

/**
 * Keeps a short history of the player's position, at most one record per
 * 100 ms "slot" (slots 1..10) since the last clear. For each slot the sample
 * closest to the slot's ideal time wins.
 *
 * Public API is unchanged: lastClearTime_, records_, _F_5() (= addRecord), clear().
 */
public class MoveRecords {

    private static const SLOT_MS:int = 100;
    private static const MAX_SLOT:int = 10;

    public var lastClearTime_:int = -1;
    public var records_:Vector.<_jg>;

    public function MoveRecords() {
        this.records_ = new Vector.<_jg>();
    }

    /** Adds a position sample taken at `time`. (Original name: _F_5) */
    public function _F_5(time:int, x:Number, y:Number):void {
        if (this.lastClearTime_ < 0) {
            return;
        }
        var slot:int = this.getSlot(time);
        if (slot < 1 || slot > MAX_SLOT) {
            return;
        }
        var last:_jg = (this.records_.length > 0) ? this.records_[this.records_.length - 1] : null;
        if (last == null || slot != this.getSlot(last.time_)) {
            this.records_.push(new _jg(time, x, y));
            return;
        }
        // Same slot as the previous record: keep whichever sample is closer to the slot centre.
        if (this.getSlotError(slot, time) < this.getSlotError(slot, last.time_)) {
            last.time_ = time;
            last.x_ = x;
            last.y_ = y;
        }
    }

    public function clear(time:int):void {
        this.records_.length = 0;
        this.lastClearTime_ = time;
    }

    /** Rounds the time since the last clear to the nearest 100 ms slot. (Original: _0E_8) */
    private function getSlot(time:int):int {
        return int((time - this.lastClearTime_ + SLOT_MS / 2) / SLOT_MS);
    }

    /** Distance in ms between `time` and the ideal time for `slot`. (Original: _0F_a) */
    private function getSlotError(slot:int, time:int):int {
        return int(Math.abs((time - this.lastClearTime_) - slot * SLOT_MS));
    }

}
}
