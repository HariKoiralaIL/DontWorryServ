package com.company.assembleegameclient.net {
import com.company.assembleegameclient.util.Currency;

/** Remembers an in-flight purchase so analytics can be reported once the server confirms it. */
internal class PurchaseTracker {

    private var itemId_:String;
    private var price_:int;
    private var currency_:int;
    private var converted_:Boolean;

    public function PurchaseTracker(itemId:String, price:int, currency:int, converted:Boolean) {
        this.itemId_ = itemId;
        this.price_ = price;
        this.currency_ = currency;
        this.converted_ = converted;
    }

    public function track():void {
        switch (this.currency_) {
            case Currency.GOLD: // gold
                //GA.global().trackEvent("credits", ((this.converted_) ? "buyConverted" : "buy"), this.itemId_, this.price_);
                return;
            case Currency.FAME:
                //GA.global().trackEvent("credits", "buyFame", this.itemId_, this.price_);
                return;
            case Currency.GUILD_FAME: // guild fame
                //GA.global().trackEvent("credits", "buyGuildFame", this.itemId_, this.price_);
                return;
            case Currency.KEYS:
                //GA.global().trackEvent("credits", "buySouls", this.itemId_, this.price_);
                return;
        }
    }

}
}
