package game.marketplace {
    import account.Account;

    import com.company.assembleegameclient.appengine.AppEngineClient;
    import com.company.assembleegameclient.game.GameSprite;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.ui.TextButton;
    import com.company.assembleegameclient.ui._0K_B_;
    import com.company.ui.SimpleText;
    import com.company.util.PropertyUtil;

    import events.GenericDataEvent;
    import events.TextErrorEvent;

    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;

    /** Offer browser: All Trades / My Trades / Search tabs backed by the /market endpoint. */
    public class Marketplace extends Sprite {

        public static const CATEGORY_ALL:String = "all";
        public static const CATEGORY_MINE:String = "mine";
        public static const CATEGORY_SEARCH:String = "search";
        public static const CATEGORY_SEARCHED:String = "searched";

        private static const BUTTON_Y:int = 75;
        private static const BUTTON_X:int = 18;
        private static const BUTTON_SPACING:int = 150;
        private static const DIVIDER_Y:int = 100;
        private static const OFFER_SPACING:int = 4;
        private static const SCROLL_BAR_Y:int = 110;
        private static const SEARCH_SCROLL_PADDING:int = 70;
        private static const LIST_SCROLL_PADDING:int = 12;

        public var allButton_:TextButton;
        public var mineButton_:TextButton;
        public var searchButton_:TextButton;
        public var category_:String;
        public var search_:MarketplaceSearch;

        private var gs_:GameSprite;
        private var request_:AppEngineClient;
        private var loadingText_:SimpleText;
        private var titleText_:SimpleText;
        private var divider_:Shape;
        private var viewport_:Sprite;
        private var list_:Sprite;
        private var scrollBar_:_0K_B_;
        private var scrollPadding_:int;
        private var num_:int;
        private var offset_:int;

        public function Marketplace(num:int, offset:int, gs:GameSprite, category:String) {
            super();
            this.num_ = num;
            this.offset_ = offset;
            this.gs_ = gs;
            this.category_ = category;
            this.loadOffers(this.createListParams());
        }

        /** Re-enters the current category (search form, or a fresh offer list). */
        public function rebuild():void {
            if (this.category_ == CATEGORY_SEARCH) {
                this.removeScrollBar();
                this.list_.y = 0;
                this.list_.removeChildren();
                this.search_ = new MarketplaceSearch(this.gs_);
                this.list_.addChild(this.search_);
                this.search_.addEventListener(MarketplaceEvent.SEARCH, this.searchRebuild);
                this.search_.addEventListener(Event.CHANGE, this.checkScroll);
            } else {
                this.clearView();
                this.loadOffers(this.createListParams());
            }
        }

        public function searchRebuild(e:MarketplaceEvent):void {
            this.category_ = CATEGORY_SEARCHED;
            this.clearView();
            var params:Object = this.createListParams();
            params["offerItems"] = e.offerItems_.join();
            params["offerData"] = JSON.stringify({datas: e.offerData_});
            params["requestItems"] = e.requestItems_.join();
            params["requestData"] = JSON.stringify({datas: e.requestData_});
            this.loadOffers(params);
        }

        private function createListParams():Object {
            return {
                "num": this.num_,
                "offset": this.offset_,
                "filter": this.category_
            };
        }

        private function loadOffers(params:Object):void {
            this.showLoading();
            this.request_ = new AppEngineClient(Parameters.serverAddress(), "/market", true, 2);
            PropertyUtil.copyProperties(params, Account.getInstance().credentials());
            this.request_.addEventListener(GenericDataEvent.GENERIC_DATA, this.onOffersLoaded);
            this.request_.addEventListener(TextErrorEvent.TEXT_ERROR, this.onLoadError);
            this.request_.sendRequest("list", params);
        }

        private function showLoading():void {
            this.loadingText_ = new SimpleText(22, MarketplaceLayout.TEXT_COLOR, false, 0, 0, MarketplaceLayout.FONT);
            this.loadingText_.setBold(true);
            this.loadingText_.text = "Loading...";
            this.loadingText_._08S_();
            this.loadingText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
            this.loadingText_.x = ((MarketplaceLayout.STAGE_WIDTH / 2) - (this.loadingText_.width / 2));
            this.loadingText_.y = ((MarketplaceLayout.STAGE_HEIGHT / 2) - (this.loadingText_.height / 2));
            addChild(this.loadingText_);
        }

        private function build(xml:XML):void {
            removeChild(this.loadingText_);

            this.titleText_ = new SimpleText(32, MarketplaceLayout.TEXT_COLOR, false, 0, 0, MarketplaceLayout.FONT);
            this.titleText_.setBold(true);
            this.titleText_.text = "Marketplace";
            this.titleText_._08S_();
            this.titleText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
            this.titleText_.y = 24;
            this.titleText_.x = ((MarketplaceLayout.STAGE_WIDTH / 2) - (this.titleText_.width / 2));
            addChild(this.titleText_);

            this.buildCategoryButtons();

            this.divider_ = new Shape();
            var g:Graphics = this.divider_.graphics;
            g.clear();
            g.lineStyle(2, MarketplaceLayout.ACCENT_COLOR);
            g.moveTo(0, DIVIDER_Y);
            g.lineTo(MarketplaceLayout.STAGE_WIDTH, DIVIDER_Y);
            g.lineStyle();
            addChild(this.divider_);

            this.viewport_ = new Sprite();
            this.viewport_.x = MarketplaceLayout.VIEWPORT_X;
            this.viewport_.y = MarketplaceLayout.VIEWPORT_Y;
            var maskShape:Shape = new Shape();
            g = maskShape.graphics;
            g.beginFill(0);
            g.drawRect(0, 0, MarketplaceLayout.CONTENT_WIDTH, MarketplaceLayout.VIEWPORT_HEIGHT);
            g.endFill();
            this.viewport_.addChild(maskShape);
            this.viewport_.mask = maskShape;
            addChild(this.viewport_);

            this.list_ = new Sprite();
            var offerY:int = 8;
            for each (var offerXml:XML in xml.Offer) {
                var offer:MarketplaceOffer = new MarketplaceOffer(offerXml, this.gs_);
                offer.x = 4;
                offer.y = offerY;
                this.list_.addChild(offer);
                offerY += MarketplaceOffer.HEIGHT + OFFER_SPACING;
            }
            this.viewport_.addChild(this.list_);
            if (this.list_.height > MarketplaceLayout.VIEW_HEIGHT) {
                this.addScrollBar(this.list_.height, LIST_SCROLL_PADDING);
            }
        }

        /** Removes everything build() added, ready for a new load. */
        private function clearView():void {
            removeChild(this.titleText_);
            this.titleText_ = null;
            removeChild(this.divider_);
            this.divider_ = null;
            removeChild(this.viewport_);
            this.viewport_ = null;
            this.list_ = null;
            this.search_ = null;
            removeChild(this.allButton_);
            this.allButton_ = null;
            removeChild(this.mineButton_);
            this.mineButton_ = null;
            removeChild(this.searchButton_);
            this.searchButton_ = null;
            this.removeScrollBar();
        }

        private function buildCategoryButtons():void {
            this.allButton_ = this.createCategoryButton("All Trades", BUTTON_X, this.onAllClick);
            this.mineButton_ = this.createCategoryButton("My Trades", BUTTON_X + BUTTON_SPACING, this.onMineClick);
            this.searchButton_ = this.createCategoryButton("Search", BUTTON_X + (BUTTON_SPACING * 2), this.onSearchClick);
        }

        private function createCategoryButton(label:String, posX:Number, onClick:Function):TextButton {
            var button:TextButton = new TextButton(18, false, "", true);
            button.text_.setBold(true);
            button.text_.text = label;
            button.text_.textColor = MarketplaceLayout.TEXT_COLOR;
            button.text_.updateMetrics();
            button.x = posX;
            button.y = BUTTON_Y;
            button.addEventListener(MouseEvent.CLICK, onClick);
            addChild(button);
            return button;
        }

        private function addScrollBar(barContentHeight:Number, scrollPadding:int):void {
            this.scrollPadding_ = scrollPadding;
            this.scrollBar_ = new _0K_B_(MarketplaceLayout.SCROLL_BAR_WIDTH, MarketplaceLayout.VIEW_HEIGHT);
            this.scrollBar_.x = ((MarketplaceLayout.STAGE_WIDTH - this.scrollBar_.width) - 4);
            this.scrollBar_.y = SCROLL_BAR_Y;
            this.scrollBar_._fA_(MarketplaceLayout.VIEW_HEIGHT, barContentHeight);
            this.scrollBar_.addEventListener(Event.CHANGE, this.onScroll);
            addChild(this.scrollBar_);
        }

        private function removeScrollBar():void {
            if (this.scrollBar_ != null && contains(this.scrollBar_)) {
                removeChild(this.scrollBar_);
                this.scrollBar_ = null;
            }
        }

        private function onScroll(e:Event):void {
            this.list_.y = (-(this.scrollBar_._Q_D_()) * ((this.list_.height + this.scrollPadding_) - MarketplaceLayout.VIEW_HEIGHT));
        }

        private function checkScroll(e:Event):void {
            this.removeScrollBar();
            if (this.list_.height > MarketplaceLayout.VIEW_HEIGHT) {
                this.addScrollBar(this.list_.height + SEARCH_SCROLL_PADDING, SEARCH_SCROLL_PADDING);
            }
        }

        private function onOffersLoaded(e:GenericDataEvent):void {
            this.build(XML(e.data));
        }

        private function onLoadError(e:TextErrorEvent):void {
            this.loadingText_.text = e.text;
        }

        private function selectCategory(category:String):void {
            if (this.category_ != category) {
                this.category_ = category;
                this.rebuild();
            }
        }

        private function onAllClick(e:MouseEvent):void {
            this.selectCategory(CATEGORY_ALL);
        }

        private function onMineClick(e:MouseEvent):void {
            this.selectCategory(CATEGORY_MINE);
        }

        private function onSearchClick(e:MouseEvent):void {
            this.selectCategory(CATEGORY_SEARCH);
        }
    }
}
