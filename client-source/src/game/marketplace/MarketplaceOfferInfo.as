package game.marketplace {
    public class MarketplaceOfferInfo {

        public var mine_:Boolean;
        /** 0 = open; anything else means the trade is finished and can be collected. */
        public var status_:int;

        public var offerItems_:Vector.<int>;
        public var offerData_:Vector.<Object>;

        public var requestItems_:Vector.<int>;
        public var requestData_:Vector.<Object>;

        public function MarketplaceOfferInfo(offerItems:Vector.<int>, offerData:Vector.<Object>, requestItems:Vector.<int>, requestData:Vector.<Object>, mine:Boolean, status:int) {
            this.offerItems_ = offerItems;
            this.offerData_ = offerData;
            this.requestItems_ = requestItems;
            this.requestData_ = requestData;
            this.mine_ = mine;
            this.status_ = status;
        }
    }
}
