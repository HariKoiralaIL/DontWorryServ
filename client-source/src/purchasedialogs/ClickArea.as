package purchasedialogs {
import flash.display.Sprite;

/**
 * Invisible, clickable rectangle placed over a dialog's background image
 * to act as a button hit area.
 */
public class ClickArea extends Sprite {

    public function ClickArea(x:int, y:int, width:int, height:int) {
        graphics.beginFill(0, 0);
        graphics.drawRect(0, 0, width, height);
        graphics.endFill();
        this.x = x;
        this.y = y;
        buttonMode = true;
    }
}
}
