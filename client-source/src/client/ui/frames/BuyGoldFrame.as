// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.ui.frames.BuyGoldFrame

package client.ui.frames {
import com.company.assembleegameclient.account.web.PurchaseMediator;

import com.company.assembleegameclient.ui._7f;

import flash.events.MouseEvent;

import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util._zR_;

import flash.display.Shape;


public class BuyGoldFrame extends Frame {

    private static const TITLE:String = "Support the game and buy Realm Gold";
    private static const BUTTON1_LABEL:String = "";
    private static const BUTTON2_LABEL:String = "Cancel";
    private static const PAGE_PATH:String = "/money";
    private static const PAYMENT_METHOD_HEADER:String = "Payment Method";
    private static const GOLD_AMOUNT_HEADER:String = "Gold Amount";
    private static const BUY_LABEL:String = "Buy Now";
    private static const WIDTH:int = 550;

    public function BuyGoldFrame(_arg1:PurchaseMediator) {
        super(TITLE, BUTTON1_LABEL, BUTTON2_LABEL, PAGE_PATH, WIDTH);
        this.mediator = _arg1;
        this.build();
    }
    private var mediator:PurchaseMediator;
    private var paymentSelector:PaymentMethodSelector;
    private var offerSelector:GoldOfferSelector;
    private var buyButton:_7f;

    private function build():void {
        this.addPaymentMethods();
        this.addOffers();
        this.addBuyButton();
        Button2.addEventListener(MouseEvent.CLICK, this.onCancel);
    }

    private function addPaymentMethods():void {
        if (!this.mediator.showPaymentMethods) {
            return;
        }
        this.createPaymentSelector();
        addHeader(PAYMENT_METHOD_HEADER);
        addSelector(this.paymentSelector);
        addSpacing(14);
        this.addDivider(0x7F7F7F, 536, 2, 10);
        addSpacing(6);
    }

    private function createPaymentSelector():void {
        var _local1:Vector.<String> = this.getPaymentLabels();
        this.paymentSelector = new PaymentMethodSelector(_local1);
        this.paymentSelector.setSelected(Parameters.data_.paymentMethod);
    }

    private function getPaymentLabels():Vector.<String> {
        var _local2:_zR_;
        var _local1:Vector.<String> = new Vector.<String>();
        for each (_local2 in _zR_._X__) {
            _local1.push(_local2.label_);
        }
        return (_local1);
    }

    private function addDivider(_arg1:int, _arg2:int, _arg3:int, _arg4:int):void {
        var _local5:Shape = new Shape();
        _local5.graphics.beginFill(_arg1);
        _local5.graphics.drawRect(_arg4, 0, (_arg2 - (_arg4 * 2)), _arg3);
        _local5.graphics.endFill();
        addElement(_local5, 0);
    }

    private function addOffers():void {
        this.offerSelector = new GoldOfferSelector(this.mediator.offers, this.mediator.currencyPrefix, this.mediator.currencySuffix);
        this.offerSelector.showBonus(this.mediator.showBonus);
        addHeader(GOLD_AMOUNT_HEADER);
        addElement(this.offerSelector);
    }

    private function addBuyButton():void {
        this.buyButton = new _7f(16, BUY_LABEL);
        this.buyButton.addEventListener(MouseEvent.CLICK, this.onBuy);
        this.buyButton.x = 8;
        this.buyButton.y = (h_ - 50);
        addChild(this.buyButton);
    }

    protected function onBuy(_arg1:MouseEvent):void {
        disableInput();
        if (this.paymentSelector != null) {
            this.mediator.paymentMethod = this.paymentSelector.getSelected();
        }
        this.mediator.offer = this.offerSelector.getSelectedItem().offer;
        this.mediator.startPurchase();
    }

    protected function onCancel(_arg1:MouseEvent):void {
        stage.focus = null;
        this.mediator.cancel();
    }

}
}//package client.ui.frames

