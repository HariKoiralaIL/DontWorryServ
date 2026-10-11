package account.ui {
import client.events.MoneyChangedEvent;
import client.ui.frames.BuyGoldFrame;

import com.company.assembleegameclient.account.web.PurchaseMediator;
import com.company.assembleegameclient.account.web.WebPaymentCommand;
import com.company.assembleegameclient.appengine._02k;
import com.company.assembleegameclient.util.offer.Offers;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;

import events.GenericDataEvent;

public class PurchaseCreditsDialog extends Sprite {

    public function PurchaseCreditsDialog() {
        var background:Shape = new Shape();
        var g:Graphics = background.graphics;
        g.clear();
        g.beginFill(0, 0.8);
        g.drawRect(0, 0, 800, 600);
        g.endFill();
        addChild(background);
        _02k._U_t("/credits", onOffersLoaded);
    }

    private function onOffersLoaded(event:GenericDataEvent):void {
        var mediator:PurchaseMediator = new PurchaseMediator();
        mediator.addEventListener(Event.CANCEL, onCancel);
        mediator.addEventListener(Event.COMPLETE, onComplete);
        mediator.offers = new Offers(XML(event.data));
        mediator.currencyPrefix = "$";
        mediator.currencySuffix = "";
        mediator.showBonus = true;
        mediator.showPaymentMethods = true;
        mediator.purchaseCommand = new WebPaymentCommand();
        addChild(new BuyGoldFrame(mediator));
    }

    private function onCancel(event:Event):void {
        parent.removeChild(this);
    }

    private function onComplete(event:Event):void {
        stage.addEventListener(Event.ACTIVATE, onStageActivate);
        parent.removeChild(this);
    }

    private function onStageActivate(event:Event):void {
        var target:Stage = event.target as Stage;
        target.dispatchEvent(new MoneyChangedEvent());
        target.removeEventListener(Event.ACTIVATE, onStageActivate);
    }

}
}
