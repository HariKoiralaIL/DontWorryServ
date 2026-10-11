package offers {

import com.company.assembleegameclient.appengine._0B_u;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util._04d;
import com.company.assembleegameclient.util.offer.Offer;
import com.company.assembleegameclient.util.offer.Offers;
import com.company.util._H_U_;

import account.Account;
import signals.Signal;

import events.GenericDataEvent;

public class BeginnersOfferModel implements IBeginnersOfferModel {

    /** The beginner's offer is the one costing this much gold. */
    private static const BEGINNERS_OFFER_GOLD:int = 2600;

    [Inject]
    public var offersModel:IOffersModel;

    private var timeLeft:int;
    private var hasServerTimeLeft:Boolean;
    private var timeLeftUpdatedSignal:Signal;
    private var offerExpiredSignal:Signal;

    public function get timeLeftUpdated():Signal {
        return this.timeLeftUpdatedSignal = this.timeLeftUpdatedSignal || new Signal();
    }

    public function get offerExpired():Signal {
        return this.offerExpiredSignal = this.offerExpiredSignal || new Signal();
    }

    public function isAvailable():Boolean {
        return this.getTimeLeft() > 0;
    }

    public function shouldShowNow():Boolean {
        return Parameters.data_.beginnersOfferShowNow;
    }

    public function clearShowNow():void {
        Parameters.data_.beginnersOfferShowNow = false;
    }

    public function requestTimeLeft():void {
        var client:_0B_u = new _0B_u(Parameters._fK_(), "/account", true);
        client.addEventListener(GenericDataEvent.GENERIC_DATA, this.handleTimeLeftLoaded);
        var params:Object = {};
        _H_U_._t2(params, Account.getInstance().credentials());
        client.sendRequest("getBeginnerPackageTimeLeft", params);
    }

    /**
     * Uses the server's value once it has been received, until then the
     * value saved in the parameters.
     */
    public function getTimeLeft():int {
        return this.hasServerTimeLeft ? this.timeLeft : Parameters.data_.beginnersOfferTimeLeft;
    }

    public function getBeginnersOffer():Offer {
        var offer:Offer;
        var offerList:Offers = this.offersModel.getOffers();
        if (!offerList) {
            return null;
        }
        for each (offer in offerList.offerList) {
            if (offer.realmGold_ == BEGINNERS_OFFER_GOLD) {
                return offer;
            }
        }
        return null;
    }

    public function expireOffer():void {
        this.timeLeft = 0;
        Parameters.data_.showBeginningsOffer = false;
        if (this.offerExpiredSignal) {
            this.offerExpiredSignal.dispatch();
        }
    }

    private function handleTimeLeftLoaded(event:GenericDataEvent):void {
        var xml:XML = new XML(event.data);
        this.hasServerTimeLeft = true;
        this.timeLeft = _04d._3r(xml.text());
        this.timeLeftUpdated.dispatch();
    }

}
}
