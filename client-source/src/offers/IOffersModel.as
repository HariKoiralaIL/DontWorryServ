package offers {

import com.company.assembleegameclient.util.offer.Offers;

import signals.Signal;

/**
 * Holds the list of purchasable offers loaded from the server.
 */
public interface IOffersModel {

    /** Dispatched whenever a fresh offer list has been loaded. */
    function get offersUpdated():Signal;

    /** Requests the offer list from the server. */
    function loadOffers():void;

    /** @return the last loaded offers, or null if none were loaded yet */
    function getOffers():Offers;

}
}
