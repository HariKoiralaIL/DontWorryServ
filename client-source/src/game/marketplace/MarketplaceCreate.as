package game.marketplace {
    import com.company.assembleegameclient.game.GameSprite;
    import com.company.assembleegameclient.ui._0K_B_;
    import com.company.assembleegameclient.ui._7f;
    import com.company.ui.SimpleText;

    import flash.display.Bitmap;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;

    /** "Create trade" page: pick your items, pick what you want in return. */
    public class MarketplaceCreate extends Sprite {

        private static const SCROLL_BAR_Y:int = 108;

        private var gs_:GameSprite;
        private var titleText_:SimpleText;
        private var divider_:Shape;
        private var viewport_:Sprite;
        private var list_:Sprite;
        private var scrollBar_:_0K_B_;
        private var myInv_:MarketplaceInventory;
        private var arrow_:Bitmap;
        private var request_:MarketplaceItemSelect;
        private var createButton_:_7f;

        public function MarketplaceCreate(gs:GameSprite) {
            super();
            this.gs_ = gs;
            this.build();
        }

        public function build():void {
            this.titleText_ = new SimpleText(32, MarketplaceLayout.TEXT_COLOR, false, 0, 0, MarketplaceLayout.FONT);
            this.titleText_.setBold(true);
            this.titleText_.text = "Marketplace";
            this.titleText_._08S_();
            this.titleText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
            this.titleText_.y = 24;
            this.titleText_.x = ((MarketplaceLayout.STAGE_WIDTH / 2) - (this.titleText_.width / 2));
            addChild(this.titleText_);

            this.divider_ = new Shape();
            var g:Graphics = this.divider_.graphics;
            g.clear();
            g.lineStyle(2, MarketplaceLayout.ACCENT_COLOR);
            g.moveTo(0, 100);
            g.lineTo(MarketplaceLayout.STAGE_WIDTH, 100);
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
            var player:* = this.gs_.map_.player_;
            this.myInv_ = new MarketplaceInventory(player.equipment_, player.equipData_, this.gs_, MarketplaceInventory.MODE_SELECT);
            this.myInv_.x = 8;
            this.myInv_.y = 8;
            this.list_.addChild(this.myInv_);

            this.arrow_ = new TradeArrowEmbed();
            this.arrow_.x = this.myInv_.x + this.myInv_.width + 10;
            this.arrow_.y = this.myInv_.y + (this.myInv_.height / 2) - (this.arrow_.height / 2);
            this.list_.addChild(this.arrow_);

            this.request_ = new MarketplaceItemSelect(this.gs_);
            this.request_.setType(MarketplaceItemSelect.TYPE_MARKET_CREATE);
            this.request_.x = 34;
            this.request_.y = this.arrow_.y + (this.arrow_.height / 2) - 50;
            this.list_.addChild(this.request_);
            this.request_.addEventListener(Event.CHANGE, this.updateScrollBar);

            this.createButton_ = new _7f(24, "Create");
            this.createButton_.x = (MarketplaceLayout.ACTION_BUTTON_CENTER_X - (this.createButton_.width / 2));
            this.createButton_.y = this.myInv_.y + (this.myInv_.height / 2) - (this.arrow_.height / 2);
            this.list_.addChild(this.createButton_);
            this.createButton_.addEventListener(MouseEvent.CLICK, this.onCreateClick);

            this.viewport_.addChild(this.list_);
            this.updateScrollBar();
        }

        private function updateScrollBar(e:Event = null):void {
            if (this.scrollBar_ != null && this.contains(this.scrollBar_)) {
                this.removeChild(this.scrollBar_);
                this.scrollBar_ = null;
            }
            if (this.list_.height > MarketplaceLayout.VIEW_HEIGHT) {
                this.scrollBar_ = new _0K_B_(MarketplaceLayout.SCROLL_BAR_WIDTH, MarketplaceLayout.VIEW_HEIGHT);
                this.scrollBar_.x = ((MarketplaceLayout.STAGE_WIDTH - this.scrollBar_.width) - 4);
                this.scrollBar_.y = SCROLL_BAR_Y;
                this.scrollBar_._fA_(MarketplaceLayout.VIEW_HEIGHT, this.list_.height);
                this.scrollBar_.addEventListener(Event.CHANGE, this.onScroll);
                addChild(this.scrollBar_);
            }
        }

        private function onScroll(e:Event):void {
            this.list_.y = (-(this.scrollBar_._Q_D_()) * (this.list_.height - MarketplaceLayout.VIEW_HEIGHT));
        }

        private function onCreateClick(e:MouseEvent):void {
            this.dispatchEvent(MarketplaceEvent.forCreate(this.myInv_.getIncludedSlots(), this.request_.inventory_.equipment_, this.request_.inventory_.equipData_));
        }
    }
}
