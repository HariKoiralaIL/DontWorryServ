package game.marketplace {
    import client.ui.screens.MenuButton;

    import client.events.ResultEvent;

    import com.company.assembleegameclient.game.GameSprite;
    import com.company.assembleegameclient.parameters.Parameters;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    import game.dialogs.Dialog;

    /** Full-screen marketplace window: browse offers, create trades, close. */
    public class MarketplaceContainerUI extends Sprite {

        private var gs_:GameSprite;
        private var marketplace_:Marketplace;
        private var create_:MarketplaceCreate;
        private var closeButton_:MenuButton;
        private var newTradeButton_:MenuButton;
        private var category_:String = Marketplace.CATEGORY_ALL;

        public function MarketplaceContainerUI(gs:GameSprite) {
            super();
            this.gs_ = gs;
            graphics.clear();
            graphics.beginFill(0x2B2B2B, 0.8);
            graphics.drawRect(0, 0, MarketplaceLayout.STAGE_WIDTH, MarketplaceLayout.STAGE_HEIGHT);
            graphics.endFill();
            this.showMarketplace();
            this.closeButton_ = new MenuButton("close", 36, false);
            this.newTradeButton_ = new MenuButton("create", 22, false);
            this.closeButton_.addEventListener(MouseEvent.CLICK, this.onCloseClick);
            this.newTradeButton_.addEventListener(MouseEvent.CLICK, this.onNewTradeClick);
            addChild(this.closeButton_);
            addChild(this.newTradeButton_);
            addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        }

        private function showMarketplace():void {
            this.marketplace_ = new Marketplace(50, 0, this.gs_, this.category_);
            this.marketplace_.addEventListener(MarketplaceEvent.TRADE, this.onTrade);
            addChild(this.marketplace_);
        }

        private function showError(text:String):void {
            var dialog:Dialog = new Dialog(text, "Error", "Ok", null, "/marketError");
            dialog.addEventListener(Dialog.BUTTON1_EVENT, this.onErrorDismissed);
            stage.addChild(dialog);
        }

        private function close():void {
            stage.focus = null;
            parent.removeChild(this);
        }

        private function onMarketResult(e:ResultEvent):void {
            this.gs_.removeEventListener(ResultEvent.MARKET_RESULT, this.onMarketResult);
            if (!e.success_) {
                this.showError(e.errorText_);
            } else {
                this.showMarketplace();
            }
        }

        private function onErrorDismissed(e:Event):void {
            var dialog:Dialog = (e.currentTarget as Dialog);
            stage.removeChild(dialog);
            this.showMarketplace();
        }

        private function onCloseClick(e:MouseEvent):void {
            this.close();
        }

        private function onAddedToStage(e:Event):void {
            this.closeButton_.x = ((MarketplaceLayout.STAGE_WIDTH / 2) - (this.closeButton_.width / 2));
            this.closeButton_.y = 526;
            this.newTradeButton_.x = this.closeButton_.x + this.closeButton_.width + 18;
            this.newTradeButton_.y = 535;
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown, false, 1);
            stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp, false, 1);
        }

        private function onRemovedFromStage(e:Event):void {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown, false);
            stage.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUp, false);
        }

        private function onKeyDown(e:KeyboardEvent):void {
            if (e.keyCode == Parameters.data_.marketHotkey && !(stage.focus is TextField)) {
                this.close();
            }
            e.stopImmediatePropagation();
        }

        private function onKeyUp(e:KeyboardEvent):void {
            e.stopImmediatePropagation();
        }

        private function onTrade(e:MarketplaceEvent):void {
            this.category_ = this.marketplace_.category_;
            this.marketplace_.removeEventListener(MarketplaceEvent.TRADE, this.onTrade);
            removeChild(this.marketplace_);
            this.gs_.gsc_.marketTrade(e.id_);
            this.gs_.addEventListener(ResultEvent.MARKET_RESULT, this.onMarketResult);
        }

        /** Toggles between the offer browser and the create-trade page. */
        private function onNewTradeClick(e:MouseEvent):void {
            if (!this.marketplace_.visible) {
                if (this.create_ != null) {
                    removeChild(this.create_);
                    this.create_ = null;
                }
                this.marketplace_.visible = true;
                this.marketplace_.rebuild();
                this.newTradeButton_.setText("create");
            } else {
                this.marketplace_.visible = false;
                this.create_ = new MarketplaceCreate(this.gs_);
                addChild(this.create_);
                this.create_.addEventListener(MarketplaceEvent.CREATE, this.onCreateTrade);
                this.newTradeButton_.setText("browse");
            }
        }

        private function onCreateTrade(e:MarketplaceEvent):void {
            this.category_ = Marketplace.CATEGORY_MINE;
            this.newTradeButton_.setText("create");
            this.marketplace_.removeEventListener(MarketplaceEvent.TRADE, this.onTrade);
            removeChild(this.marketplace_);
            this.create_.removeEventListener(MarketplaceEvent.CREATE, this.onCreateTrade);
            removeChild(this.create_);
            this.gs_.gsc_.marketCreate(e.included_, e.requestItems_, e.requestData_);
            this.gs_.addEventListener(ResultEvent.MARKET_RESULT, this.onMarketResult);
        }
    }
}
