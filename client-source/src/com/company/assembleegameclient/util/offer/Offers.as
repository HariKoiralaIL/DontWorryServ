package com.company.assembleegameclient.util.offer {

public class Offers {

    private static const BEST_DEAL:String = "(Best deal)";
    private static const MOST_POPULAR:String = "(Most popular)";
    private static const MOST_POPULAR_PRICE:Number = 10;

    public var tok:String;
    public var exp:String;
    public var offerList:Vector.<Offer>;

    public function Offers(xml:XML) {
        this.tok = xml.Tok;
        this.exp = xml.Exp;
        this.makeOffers(xml);
    }

    private function makeOffers(xml:XML):void {
        this.makeOfferList(xml);
        this.sortOfferList();
        this.defineBonuses();
        this.defineMostPopularTagline();
        this.defineBestDealTagline();
    }

    private function makeOfferList(xml:XML):void {
        this.offerList = new <Offer>[];
        for each (var offerXml:XML in xml.Offer) {
            this.offerList.push(this.makeOffer(offerXml));
        }
    }

    private function makeOffer(xml:XML):Offer {
        var id:String = xml.Id;
        var price:Number = Number(xml.Price);
        var realmGold:int = int(xml.RealmGold);
        var jwt:String = xml.CheckoutJWT;
        var data:String = xml.Data;
        var currency:String = xml.hasOwnProperty("Currency") ? xml.Currency : null;
        return new Offer(id, price, realmGold, jwt, data, currency);
    }

    private function sortOfferList():void {
        this.offerList.sort(this.compareByPrice);
    }

    private function compareByPrice(a:Offer, b:Offer):int {
        return a.price_ - b.price_;
    }

    /** Bonus of each offer vs. the gold-per-price rate of the cheapest offer. */
    private function defineBonuses():void {
        var baseGold:int = this.offerList[0].realmGold_;
        var basePrice:int = this.offerList[0].price_;
        var baseRate:Number = baseGold / basePrice;
        var i:int = 1;
        while (i < this.offerList.length) {
            var gold:int = this.offerList[i].realmGold_;
            var price:int = this.offerList[i].price_;
            var expectedGold:Number = price * baseRate;
            var extraGold:Number = gold - expectedGold;
            this.offerList[i].bonus = extraGold / price;
            i++;
        }
    }

    private function defineMostPopularTagline():void {
        for each (var offer:Offer in this.offerList) {
            if (offer.price_ == MOST_POPULAR_PRICE) {
                offer.tagline = MOST_POPULAR;
            }
        }
    }

    private function defineBestDealTagline():void {
        this.offerList[this.offerList.length - 1].tagline = BEST_DEAL;
    }

}
}
