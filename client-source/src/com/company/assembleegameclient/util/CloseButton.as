package com.company.assembleegameclient.util {
import flash.display.Sprite;
import flash.events.MouseEvent;

import signals.Signal;

import zerorealms.rotmg.assets.EmbeddedAssets_btnEmbed_;

/** One-shot close button: dispatches `event` on the first click, then stops listening. */
public class CloseButton extends Sprite {

    public static var buttonGraphic_:Class = EmbeddedAssets_btnEmbed_;

    public const event:Signal = new Signal();

    public var disabled:Boolean = false;

    public function CloseButton() {
        addChild(new buttonGraphic_());
        buttonMode = true;
        addEventListener(MouseEvent.CLICK, this.onButtonClick);
    }

    public function disable():void {
        this.disabled = true;
        removeEventListener(MouseEvent.CLICK, this.onButtonClick);
    }

    private function onButtonClick(e:MouseEvent):void {
        if (!this.disabled) {
            this.event.dispatch();
            removeEventListener(MouseEvent.CLICK, this.onButtonClick);
        }
    }

}
}
