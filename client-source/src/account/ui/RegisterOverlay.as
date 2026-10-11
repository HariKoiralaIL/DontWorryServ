package account.ui {
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;

public class RegisterOverlay extends Sprite {

    private var background:Shape;

    public function RegisterOverlay() {
        background = new Shape();
        var g:Graphics = background.graphics;
        g.clear();
        g.beginFill(0, 0.8);
        g.drawRect(0, 0, 800, 600);
        g.endFill();
        addChild(background);
        var frame:RegisterFrame = new RegisterFrame(false);
        frame.addEventListener(AccountFrameEvent.DONE, onClose);
        frame.addEventListener(AccountFrameEvent.CURRENT, onClose);
        addChild(frame);
    }

    private function onClose(event:Event):void {
        parent.removeChild(this);
    }

}
}
