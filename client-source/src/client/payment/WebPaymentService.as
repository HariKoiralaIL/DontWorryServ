// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.payment.WebPaymentService

package client.payment {
import offers.IOffersModel;

import signals.Signal;

import com.company.assembleegameclient.util._zR_;
import com.company.assembleegameclient.util.offer.Offers;
import com.company.assembleegameclient.parameters.Parameters;

import flash.net.navigateToURL;
import flash.net.URLRequest;

public class WebPaymentService implements IPaymentService {

    [Inject]
    public var offersModel:IOffersModel;
    private var completeSignal:Signal;

    public function get complete():Signal {
        return ((this.completeSignal = ((this.completeSignal) || (new Signal()))));
    }

    public function purchase(_arg1:PurchaseRequest):void {
        var _local3:_zR_;
        var _local2:Offers = this.offersModel.getOffers();
        Parameters.data_.paymentMethod = _local3;
        Parameters.save();
        _local3 = _zR_._8N_(_arg1.paymentMethod);
        var _local4:String = _local3._T_R_(_local2.tok, _local2.exp, _arg1.offer);
        navigateToURL(new URLRequest(_local4), "_blank");
        this.complete.dispatch();
    }

}
}//package client.payment

