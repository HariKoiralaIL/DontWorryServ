package game.marketplace {
    import com.company.assembleegameclient.game.GameSprite;
    import com.company.assembleegameclient.ui.RoundedButton;

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    /** Offer / request pickers; dispatches MarketplaceEvent.SEARCH. */
    public class MarketplaceSearch extends Sprite {

        private var gs_:GameSprite;
        private var offer_:MarketplaceItemSelect;
        private var arrow_:Bitmap;
        private var request_:MarketplaceItemSelect;
        private var searchButton_:RoundedButton;

        public function MarketplaceSearch(gs:GameSprite) {
            super();
            this.gs_ = gs;
            this.build();
        }

        public function build():void {
            this.offer_ = new MarketplaceItemSelect(this.gs_);
            this.offer_.x = 34;
            this.offer_.y = 58;
            addChild(this.offer_);
            this.arrow_ = new TradeArrowEmbed();
            this.arrow_.x = this.offer_.x + this.offer_.width + 10;
            this.arrow_.y = this.offer_.y + 50 - (this.arrow_.height / 2);
            addChild(this.arrow_);
            this.request_ = new MarketplaceItemSelect(this.gs_);
            this.request_.x = this.arrow_.x + this.arrow_.width + 18;
            this.request_.y = 58;
            addChild(this.request_);
            this.searchButton_ = new RoundedButton(24, "Search");
            this.searchButton_.x = (MarketplaceLayout.ACTION_BUTTON_CENTER_X - (this.searchButton_.width / 2));
            this.searchButton_.y = this.arrow_.y + (this.arrow_.height / 2) - (this.searchButton_.height / 2);
            addChild(this.searchButton_);
            this.searchButton_.addEventListener(MouseEvent.CLICK, this.onSearchClick);
        }

        private function onSearchClick(e:MouseEvent):void {
            this.dispatchEvent(MarketplaceEvent.forSearch(this.offer_, this.request_));
        }
    }
}
