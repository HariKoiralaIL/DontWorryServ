package com.company.assembleegameclient.ui {
import client.ui.frames.Frame;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;

/**
 * Shows a Frame on top of a dimmed full-screen backdrop and removes itself
 * when the frame completes.
 *
 * Formerly: _y3
 */
public class FrameHolder extends Sprite {

    private static const DIM_ALPHA:Number = 0.8;

    private var dimScreen:Shape;
    private var frame:Frame;

    public function FrameHolder(frame:Frame) {
        super();
        this.dimScreen = new Shape();
        var g:Graphics = this.dimScreen.graphics;
        g.clear();
        g.beginFill(0, DIM_ALPHA);
        g.drawRect(0 - (projectblogo.sWidth - 800), 0 - (projectblogo.sHeight - 600), projectblogo.sWidth * 2, projectblogo.sHeight * 2);
        g.endFill();
        addChild(this.dimScreen);
        this.frame = frame;
        this.frame.addEventListener(Event.COMPLETE, this.onComplete);
        addChild(this.frame);
    }

    private function onComplete(event:Event):void {
        parent.removeChild(this);
    }
}
}
