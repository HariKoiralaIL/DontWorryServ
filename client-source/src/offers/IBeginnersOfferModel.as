package offers {

import com.company.assembleegameclient.util.offer.Offer;

import signals.Signal;

/**
 * State of the limited-time "beginner's" offer: how much time is left,
 * whether it should be popped up now, and the offer itself.
 */
public interface IBeginnersOfferModel {

    /** Dispatched when the time left was received from the server. */
    function get timeLeftUpdated():Signal;

    /** Dispatched when the offer has been expired via expireOffer(). */
    function get offerExpired():Signal;

    function isAvailable():Boolean;

    /** @return true if the offer is flagged to be shown right now */
    function shouldShowNow():Boolean;

    function clearShowNow():void;

    /** Asks the server how much time is left on the offer. */
    function requestTimeLeft():void;

    function getTimeLeft():int;

    /** @return the beginner's offer from the loaded offer list, or null */
    function getBeginnersOffer():Offer;

    function expireOffer():void;

}
}
