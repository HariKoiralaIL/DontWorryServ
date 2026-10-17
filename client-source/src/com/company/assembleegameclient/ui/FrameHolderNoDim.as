package com.company.assembleegameclient.ui {
import client.ui.frames.Frame;

import flash.display.Sprite;
import flash.events.Event;

/**
 * Shows a Frame without a backdrop and removes itself when the frame completes.
 *
 * Formerly: _y3 (variant)
 */
public class FrameHolderNoDim extends Sprite {

    private var frame:Frame;

    public function FrameHolderNoDim(frame:Frame) {
        super();
        this.frame = frame;
        this.frame.addEventListener(Event.COMPLETE, this.onComplete);
        addChild(this.frame);
    }

    private function onComplete(event:Event):void {
        parent.removeChild(this);
    }
}
}
