// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.payment.IPaymentService

package client.payment {
import signals.Signal;

public interface IPaymentService {

    function get complete():Signal;

    function purchase(_arg1:PurchaseRequest):void;

}
}//package client.payment

