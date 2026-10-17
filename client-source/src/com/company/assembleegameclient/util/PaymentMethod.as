package com.company.assembleegameclient.util {
import account.Account;

import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.offer.Offer;

import flash.net.URLVariables;

public class PaymentMethod {

    // Disabled in the original: "GoogleAnalytics Checkout" ("co", "") and "Credit Cards, etc." ("ps", "CH").
    public static const PAYMENT_METHODS:Vector.<PaymentMethod> = new <PaymentMethod>[new PaymentMethod("PayPal", "ps", "P3")];

    public static function getByLabel(label:String):PaymentMethod {
        var method:PaymentMethod;
        for each (method in PAYMENT_METHODS) {
            if (method.label_ == label) {
                return method;
            }
        }
        return null;
    }

    public var label_:String;
    public var provider_:String;
    public var paymentId_:String;

    public function PaymentMethod(label:String, provider:String, paymentId:String) {
        this.label_ = label;
        this.provider_ = provider;
        this.paymentId_ = paymentId;
    }

    public function getCreditsUrl(token:String, expiry:String, offer:Offer):String {
        var variables:URLVariables = new URLVariables();
        variables["tok"] = token;
        variables["exp"] = expiry;
        variables["guid"] = Account.getInstance().guid();
        variables["provider"] = this.provider_;
        switch (this.provider_) {
            case "ps":
                variables["jwt"] = offer.jwt_;
                variables["price"] = offer.price_.toString();
                variables["paymentid"] = this.paymentId_;
                break;
        }
        return "http://" + Parameters.serverAddress() + "/credits/add?" + variables.toString();
    }

}
}
