package purchasedialogs {
import _S_K_.NativeRelaySignal;

import flash.display.Sprite;
import flash.events.MouseEvent;

import signals.Signal;

/**
 * Background image with a single close button.
 */
public class CloseOnlyDialog extends Sprite {

    private static const CLOSE_X:int = 550;
    private static const CLOSE_Y:int = 30;
    private static const CLOSE_SIZE:int = 30;

    public static var backgroundClass:Class = CloseOnlyDialogBackground;

    public var close:Signal;

    public function CloseOnlyDialog() {
        addBackground();
        var closeArea:ClickArea = addClickArea(CLOSE_X, CLOSE_Y, CLOSE_SIZE, CLOSE_SIZE);
        this.close = new NativeRelaySignal(closeArea, MouseEvent.CLICK);
    }

    private function addBackground():void {
        addChild(new backgroundClass());
    }

    private function addClickArea(x:int, y:int, width:int, height:int):ClickArea {
        var area:ClickArea = new ClickArea(x, y, width, height);
        addChild(area);
        return area;
    }
}
}
