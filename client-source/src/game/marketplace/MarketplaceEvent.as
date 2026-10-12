package game.marketplace {
    import flash.events.Event;

    public class MarketplaceEvent extends Event {

        public static const TRADE:String = "TRADE";
        public static const CREATE:String = "CREATE";
        public static const SEARCH:String = "SEARCH";

        public var id_:int;
        public var included_:Vector.<int>;
        public var offerItems_:Vector.<int>;
        public var offerData_:Vector.<Object>;
        public var requestItems_:Vector.<int>;
        public var requestData_:Vector.<Object>;

        public function MarketplaceEvent(id:int, type:String = "TRADE") {
            super(type, true);
            this.id_ = id;
        }

        public static function forCreate(included:Vector.<int>, requestItems:Vector.<int>, requestData:Vector.<Object>):MarketplaceEvent {
            var event:MarketplaceEvent = new MarketplaceEvent(0, CREATE);
            event.included_ = included;
            event.requestItems_ = requestItems;
            event.requestData_ = requestData;
            return event;
        }

        public static function forSearch(offer:MarketplaceItemSelect, request:MarketplaceItemSelect):MarketplaceEvent {
            var event:MarketplaceEvent = new MarketplaceEvent(0, SEARCH);
            event.offerItems_ = offer.inventory_.equipment_;
            event.offerData_ = offer.inventory_.equipData_;
            event.requestItems_ = request.inventory_.equipment_;
            event.requestData_ = request.inventory_.equipData_;
            return event;
        }
    }
}
