// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.account.web.WebPaymentCommand

package com.company.assembleegameclient.account.web {
import _qN_._px;

import com.company.assembleegameclient.util._zR_;
import com.company.assembleegameclient.parameters.Parameters;

import flash.net.navigateToURL;
import flash.net.URLRequest;
import flash.events.Event;

public class WebPaymentCommand extends _px {

    override public function execute():void {
        var method:_zR_;
        Parameters.data_.paymentMethod = method;
        Parameters.save();
        method = _zR_._8N_(paymentMethod);
        var url:String = method._T_R_(offers.tok, offers.exp, offer);
        navigateToURL(new URLRequest(url), "_blank");
        if (mediator) {
            mediator.dispatchEvent(new Event(Event.COMPLETE));
        }
    }

}
}//package com.company.assembleegameclient.account.web

