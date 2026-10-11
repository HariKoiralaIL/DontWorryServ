// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.config.PaymentConfig

package client.config {
import robotlegs.bender.framework.api.IConfig;

import injection.Injector;

import env.ClientEnv;

import client.payment.IPaymentService;

import env.PlatformType;

import client.payment.WebPaymentService;

public class PaymentConfig implements IConfig {

    [Inject]
    public var injector:Injector;
    [Inject]
    public var clientEnv:ClientEnv;

    public function configure():void {
        this.injector.map(IPaymentService).toType(this.getPaymentServiceType());
    }

    private function getPaymentServiceType():Class {
        switch (this.clientEnv.getPlatform()) {
            case PlatformType.STEAM:
            case PlatformType.WEB:
            default:
                return (WebPaymentService);
        }
    }

}
}//package client.config

