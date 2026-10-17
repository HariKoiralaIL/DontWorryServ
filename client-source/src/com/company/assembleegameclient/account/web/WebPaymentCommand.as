// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.account.web.WebPaymentCommand

package com.company.assembleegameclient.account.web {
import account.PurchaseOfferCommand;

import com.company.assembleegameclient.util.PaymentMethod;
import com.company.assembleegameclient.parameters.Parameters;

import flash.net.navigateToURL;
import flash.net.URLRequest;
import flash.events.Event;

public class WebPaymentCommand extends PurchaseOfferCommand {

    override public function execute():void {
        var method:PaymentMethod;
        Parameters.data_.paymentMethod = method;
        Parameters.save();
        method = PaymentMethod.getByLabel(paymentMethod);
        var url:String = method.getCreditsUrl(offers.tok, offers.exp, offer);
        navigateToURL(new URLRequest(url), "_blank");
        if (mediator) {
            mediator.dispatchEvent(new Event(Event.COMPLETE));
        }
    }

}
}//package com.company.assembleegameclient.account.web

