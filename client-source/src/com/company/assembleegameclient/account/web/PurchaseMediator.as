// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.account.web.PurchaseMediator

package com.company.assembleegameclient.account.web {
import flash.events.EventDispatcher;

import com.company.assembleegameclient.util.offer.Offers;
import com.company.assembleegameclient.util.offer.Offer;

import _qN_._px;

import flash.events.Event;

public class PurchaseMediator extends EventDispatcher {

    public var offers:Offers;
    public var showPaymentMethods:Boolean;
    public var showBonus:Boolean;
    public var currencyPrefix:String;
    public var currencySuffix:String;
    public var offer:Offer;
    public var paymentMethod:String;
    public var purchaseCommand:_px;

    public function startPurchase():void {
        this.purchaseCommand.offers = this.offers;
        this.purchaseCommand.offer = this.offer;
        this.purchaseCommand.paymentMethod = this.paymentMethod;
        this.purchaseCommand.mediator = this;
        this.purchaseCommand.execute();
    }

    public function complete():void {
        dispatchEvent(new Event(Event.COMPLETE));
    }

    public function cancel():void {
        dispatchEvent(new Event(Event.CANCEL));
    }

}
}//package com.company.assembleegameclient.account.web

