package beginnersoffer {
import flash.display.Sprite;

import purchasedialogs.CloseOnlyDialog;
import purchasedialogs.LimitedOfferDialog;
import purchasedialogs.PaymentMethodDialog;

import signals.Signal;

/**
 * Full-screen overlay that hosts one beginner's offer dialog at a time.
 */
public class BeginnersOfferDialogView extends Sprite {

    private static const STAGE_WIDTH:int = 800;
    private static const STAGE_HEIGHT:int = 600;
    private static const DIALOG_OFFSET:int = 15;
    private static const PAYMENT_DIALOG_Y_ADJUST:int = 5;

    public var buy:Signal;
    public var paymentMethodSelected:Signal;
    private var currentDialog:Sprite;

    public function BeginnersOfferDialogView() {
        this.buy = new Signal();
        this.paymentMethodSelected = new Signal(String);
        tabChildren = false;
        tabEnabled = false;
        addChild(new DarkOverlay());
    }

    public function showLimitedOffer(daysLeft:int):void {
        var dialog:LimitedOfferDialog = new LimitedOfferDialog();
        dialog.setDaysLeft(daysLeft);
        dialog.close.addOnce(this.destroy);
        dialog.buy.addOnce(this.onBuy);
        showDialog(dialog);
    }

    public function showOfferExpired():void {
        var dialog:CloseOnlyDialog = new CloseOnlyDialog();
        dialog.close.addOnce(this.destroy);
        showDialog(dialog);
    }

    public function showPaymentMethods():void {
        var dialog:PaymentMethodDialog = new PaymentMethodDialog();
        dialog.close.addOnce(this.destroy);
        dialog.select.addOnce(this.onPaymentMethodSelected);
        showDialog(dialog);
        dialog.y = dialog.y - PAYMENT_DIALOG_Y_ADJUST;
    }

    public function destroy():void {
        parent.removeChild(this);
    }

    private function onBuy():void {
        this.buy.dispatch();
    }

    private function onPaymentMethodSelected(method:String):void {
        this.paymentMethodSelected.dispatch(method);
    }

    private function showDialog(dialog:Sprite):void {
        removeCurrentDialog();
        this.currentDialog = dialog;
        dialog.x = (STAGE_WIDTH / 2) - (dialog.width / 2) - DIALOG_OFFSET;
        dialog.y = (STAGE_HEIGHT / 2) - (dialog.height / 2) - DIALOG_OFFSET;
        addChild(dialog);
    }

    private function removeCurrentDialog():void {
        if (this.currentDialog != null) {
            removeChild(this.currentDialog);
        }
        this.currentDialog = null;
    }
}
}
