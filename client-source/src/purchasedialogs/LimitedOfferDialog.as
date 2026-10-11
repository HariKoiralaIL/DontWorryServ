package purchasedialogs {
import _S_K_.NativeRelaySignal;

import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.MouseEvent;

import signals.Signal;

/**
 * Limited-time offer dialog: shows how many days are left,
 * with "buy" and "close" buttons.
 */
public class LimitedOfferDialog extends Sprite {

    public static const DAYS_LEFT_TEMPLATE:String = "${TIME} day${PLURAL} left!";

    private static const CLOSE_X:int = 550;
    private static const CLOSE_Y:int = 30;
    private static const CLOSE_SIZE:int = 30;

    private static const BUY_X:int = 270;
    private static const BUY_Y:int = 400;
    private static const BUY_WIDTH:int = 150;
    private static const BUY_HEIGHT:int = 40;

    private static const LABEL_X:int = 307;
    private static const LABEL_Y:int = 380;
    private static const LABEL_SIZE:int = 14;
    private static const LABEL_COLOR:uint = 0xE3C900;
    private static const LABEL_FONT:String = "Myriad Pro";

    public static var backgroundClass:Class = LimitedOfferBackground;

    public var close:Signal;
    public var buy:Signal;
    private var daysLeftText:SimpleText;

    public function LimitedOfferDialog() {
        addBackground();
        createDaysLeftText();
        createCloseButton();
        createBuyButton();
    }

    public function setDaysLeft(days:int):void {
        this.daysLeftText.text = DAYS_LEFT_TEMPLATE
                .replace("${TIME}", days)
                .replace("${PLURAL}", (days > 1) ? "s" : "");
    }

    private function addBackground():void {
        addChild(new backgroundClass());
    }

    private function createDaysLeftText():void {
        this.daysLeftText = new SimpleText(LABEL_SIZE, LABEL_COLOR, false, 0, 0, LABEL_FONT);
        this.daysLeftText.setBold(true);
        this.daysLeftText.x = LABEL_X;
        this.daysLeftText.y = LABEL_Y;
        addChild(this.daysLeftText);
    }

    private function createCloseButton():void {
        var area:ClickArea = addClickArea(CLOSE_X, CLOSE_Y, CLOSE_SIZE, CLOSE_SIZE);
        this.close = new NativeRelaySignal(area, MouseEvent.CLICK);
    }

    private function createBuyButton():void {
        var area:ClickArea = addClickArea(BUY_X, BUY_Y, BUY_WIDTH, BUY_HEIGHT);
        this.buy = new NativeRelaySignal(area, MouseEvent.CLICK);
    }

    private function addClickArea(x:int, y:int, width:int, height:int):ClickArea {
        var area:ClickArea = new ClickArea(x, y, width, height);
        addChild(area);
        return area;
    }
}
}
