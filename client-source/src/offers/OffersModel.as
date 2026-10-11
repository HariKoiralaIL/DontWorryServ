package offers {

import com.company.assembleegameclient.appengine._02k;
import com.company.assembleegameclient.util.offer.Offers;

import signals.Signal;

import events.GenericDataEvent;

public class OffersModel implements IOffersModel {

    private var loadedOffers:Offers;
    private var offersUpdatedSignal:Signal;

    public function get offersUpdated():Signal {
        return this.offersUpdatedSignal = this.offersUpdatedSignal || new Signal();
    }

    public function loadOffers():void {
        _02k._U_t(this.getOffersPath(), this.handleOffersLoaded);
    }

    public function getOffers():Offers {
        return this.loadedOffers;
    }

    private function getOffersPath():String {
        return "/credits";
    }

    private function handleOffersLoaded(event:GenericDataEvent):void {
        this.loadedOffers = new Offers(XML(event.data));
        this.offersUpdated.dispatch();
    }

}
}
