package com.company.assembleegameclient.net {
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.Event;
import flash.filters.DropShadowFilter;
import flash.utils.getTimer;

/** On-screen label showing network jitter (std deviation of tick intervals over the last N ticks). */
public class NetJitterDisplay extends Sprite {

    private static const MAX_SAMPLES:int = 50;

    private var text_:SimpleText = null;
    private var lastTickTime_:int = -1;
    private var intervals_:Vector.<int>;
    private var intervalSum_:int;

    public function NetJitterDisplay() {
        this.intervals_ = new Vector.<int>();
        super();
        this.text_ = new SimpleText(14, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.text_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.text_);
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    /** Call once per server tick. */
    public function onTick():void {
        var now:int = getTimer();
        if (this.lastTickTime_ == -1) {
            this.lastTickTime_ = now;
            return;
        }
        var interval:int = now - this.lastTickTime_;
        this.intervals_.push(interval);
        this.intervalSum_ += interval;
        if (this.intervals_.length > MAX_SAMPLES) {
            this.intervalSum_ -= this.intervals_.shift();
        }
        this.lastTickTime_ = now;
    }

    private function calcStdDev():Number {
        var count:int = this.intervals_.length;
        if (count == 0) {
            return 0;
        }
        var mean:Number = this.intervalSum_ / count;
        var sumSquares:Number = 0;
        for each (var interval:int in this.intervals_) {
            sumSquares += (interval - mean) * (interval - mean);
        }
        return Math.sqrt(sumSquares / count);
    }

    private function onAddedToStage(e:Event):void {
        stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onRemovedFromStage(e:Event):void {
        stage.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onEnterFrame(e:Event):void {
        this.text_.text = "net jitter: " + int(this.calcStdDev());
        this.text_._08S_();
    }

}
}
