package purchasedialogs {
import signals.nativesignals.NativeRelaySignal;

import eventsignals.EventRelaySignal;

import flash.display.Sprite;
import flash.events.MouseEvent;

import signals.Signal;

/**
 * Payment method picker. Dispatches `select` with the chosen
 * method name (a String) when one of the options is clicked.
 */
public class PaymentMethodDialog extends Sprite {

    public static const METHOD_PAYPAL:String = "PayPal";
    public static const METHOD_CREDIT_CARD:String = "Credit Cards, etc.";
    public static const METHOD_GOOGLE_CHECKOUT:String = "Google Checkout";

    private static const CLOSE_X:int = 550;
    private static const CLOSE_Y:int = 30;
    private static const CLOSE_SIZE:int = 30;

    private static const OPTION_X:int = 220;
    private static const OPTION_WIDTH:int = 180;
    private static const OPTION_HEIGHT:int = 35;
    private static const OPTION_Y_FIRST:int = 180;
    private static const OPTION_Y_SECOND:int = 224;
    private static const OPTION_Y_THIRD:int = 268;

    public static var backgroundClass:Class = PaymentMethodBackground;

    public var close:Signal;
    public var select:EventRelaySignal;

    public function PaymentMethodDialog() {
        this.select = new EventRelaySignal(MouseEvent.CLICK, String);
        addBackground();
        createCloseButton();
        createMethodButtons();
    }

    private function addBackground():void {
        addChild(new backgroundClass());
    }

    private function createCloseButton():void {
        var area:ClickArea = addClickArea(CLOSE_X, CLOSE_Y, CLOSE_SIZE, CLOSE_SIZE);
        this.close = new NativeRelaySignal(area, MouseEvent.CLICK);
    }

    private function createMethodButtons():void {
        var paypal:ClickArea = addOption(OPTION_Y_FIRST);
        var creditCard:ClickArea = addOption(OPTION_Y_SECOND);
        var googleCheckout:ClickArea = addOption(OPTION_Y_THIRD);
        this.select.map(paypal, METHOD_PAYPAL);
        this.select.map(creditCard, METHOD_CREDIT_CARD);
        this.select.map(googleCheckout, METHOD_GOOGLE_CHECKOUT);
    }

    private function addOption(y:int):ClickArea {
        return addClickArea(OPTION_X, y, OPTION_WIDTH, OPTION_HEIGHT);
    }

    private function addClickArea(x:int, y:int, width:int, height:int):ClickArea {
        var area:ClickArea = new ClickArea(x, y, width, height);
        addChild(area);
        return area;
    }
}
}
