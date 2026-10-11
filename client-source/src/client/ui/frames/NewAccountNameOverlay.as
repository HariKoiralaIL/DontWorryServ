// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.ui.frames.NewAccountNameOverlay

package client.ui.frames {
import flash.display.Sprite;
import flash.display.Shape;
import flash.display.Graphics;
import flash.events.Event;

public class NewAccountNameOverlay extends Sprite {

    public function NewAccountNameOverlay() {
        this.background = new Shape();
        var _local1:Graphics = this.background.graphics;
        _local1.clear();
        _local1.beginFill(0, 0.8);
        _local1.drawRect(0, 0, 800, 600);
        _local1.endFill();
        addChild(this.background);
        this.nameFrame = new NewAccountNameFrame();
        this.nameFrame.addEventListener(Event.CANCEL, this.onCancel);
        this.nameFrame.addEventListener(Event.COMPLETE, this.onComplete);
        addChild(this.nameFrame);
    }
    private var background:Shape;
    private var nameFrame:NewAccountNameFrame;

    private function onCancel(_arg1:Event):void {
        stage.focus = null;
        parent.removeChild(this);
    }

    private function onComplete(_arg1:Event):void {
        parent.removeChild(this);
        dispatchEvent(new Event(Event.COMPLETE));
    }

}
}//package client.ui.frames

