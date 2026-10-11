package beginnersoffer {
import flash.display.Sprite;

/**
 * Semi-transparent dark layer drawn behind a dialog.
 * Sized by its mediator via initialize().
 */
public class DarkOverlay extends Sprite {

    private static const FILL_COLOR:uint = 0x151515;
    private static const FILL_ALPHA:Number = 0.6;

    public function initialize(overlayWidth:int, overlayHeight:int):void {
        graphics.beginFill(FILL_COLOR, FILL_ALPHA);
        graphics.drawRect(0, 0, overlayWidth, overlayHeight);
        graphics.endFill();
    }
}
}
