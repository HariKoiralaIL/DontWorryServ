package game.marketplace {
    import com.company.assembleegameclient.game.GameSprite;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.assembleegameclient.ui.RoundedButton;

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    /** One row of the offer list: offered items -> requested items, plus the Trade/Collect/Close button. */
    public class MarketplaceOffer extends Sprite {

        public static const WIDTH:int = 792;
        public static const HEIGHT:int = 108;

        private static const COLUMNS:int = 4;
        private static const SPACING:int = 4;
        /** Inventory slots below this index are equipment slots, not backpack slots. */
        private static const FIRST_INVENTORY_SLOT:int = 4;

        public var gs_:GameSprite;
        public var info_:MarketplaceOfferInfo;

        private var offer_:Sprite;
        private var arrow_:Bitmap;
        private var request_:Sprite;
        private var tradeButton_:RoundedButton;
        private var id_:int;

        public function MarketplaceOffer(xml:XML, gs:GameSprite) {
            super();
            this.info_ = new MarketplaceOfferInfo(
                parseItems(String(xml.OfferItems)),
                parseData(String(xml.OfferData)),
                parseItems(String(xml.RequestItems)),
                parseData(String(xml.RequestData)),
                xml.Mine == "true",
                int(xml.Status));
            this.gs_ = gs;
            this.id_ = int(xml.@id);
            this.draw();
        }

        private static function parseItems(value:String):Vector.<int> {
            return Vector.<int>(value.split(", "));
        }

        private static function parseData(json:String):Vector.<Object> {
            var result:Vector.<Object> = new Vector.<Object>();
            for each (var entry:Object in JSON.parse(json).datas) {
                result.push(entry);
            }
            return result;
        }

        private function draw():void {
            var slotsEnabled:Boolean = (this.info_.status_ == 0);

            this.offer_ = this.buildSlotGrid(this.info_.offerItems_, this.info_.offerData_, slotsEnabled);
            this.offer_.x = 4;
            this.offer_.y = (HEIGHT / 2) - (this.offer_.height / 2);
            addChild(this.offer_);

            this.arrow_ = new TradeArrowEmbed();
            this.arrow_.x = this.offer_.x + this.offer_.width + 10;
            this.arrow_.y = (HEIGHT / 2) - (this.arrow_.height / 2) - 4;
            addChild(this.arrow_);

            this.request_ = this.buildSlotGrid(this.info_.requestItems_, this.info_.requestData_, slotsEnabled);
            this.request_.x = this.arrow_.x + this.arrow_.width + 18;
            this.request_.y = (HEIGHT / 2) - (this.request_.height / 2);
            addChild(this.request_);

            var label:String = "Trade";
            if (this.info_.mine_) {
                label = (this.info_.status_ != 0) ? "Collect" : "Close";
            }
            this.tradeButton_ = new RoundedButton(24, label);
            this.tradeButton_.x = (MarketplaceLayout.ACTION_BUTTON_CENTER_X - (this.tradeButton_.width / 2));
            this.tradeButton_.y = (HEIGHT / 2) - (this.tradeButton_.height / 2);
            this.tradeButton_.setEnabled(this.canUseButton());
            addChild(this.tradeButton_);
            this.tradeButton_.addEventListener(MouseEvent.CLICK, this.onMouseClick);
        }

        private function buildSlotGrid(items:Vector.<int>, datas:Vector.<Object>, enabled:Boolean):Sprite {
            var grid:Sprite = new Sprite();
            for (var i:int = 0; i < items.length; i++) {
                var slot:MarketplaceSlot = new MarketplaceSlot(items[i], datas[i], this.gs_, enabled);
                slot.x = (i % COLUMNS) * (MarketplaceSlot.WIDTH + SPACING);
                slot.y = Math.floor(i / COLUMNS) * (MarketplaceSlot.HEIGHT + SPACING);
                grid.addChild(slot);
            }
            return grid;
        }

        private function canUseButton():Boolean {
            if (!this.info_.mine_) {
                return this.canAcceptTrade();
            }
            if (!this.info_.status_) {
                return true;
            }
            return this.canCollect();
        }

        /** Does the player own every requested item and have room for the offered ones? */
        private function canAcceptTrade():Boolean {
            var playerItems:Vector.<int> = this.gs_.map_.player_.equipment_;
            var playerData:Vector.<Object> = this.gs_.map_.player_.equipData_;
            var usedSlots:Vector.<int> = new Vector.<int>();
            for (var i:int = 0; i < this.info_.requestItems_.length; i++) {
                var found:Boolean = false;
                var requested:Object = this.info_.requestData_[i];
                for (var p:int = 0; p < playerItems.length; p++) {
                    if (playerItems[p] == -1 || playerItems[p] != this.info_.requestItems_[i] || usedSlots.indexOf(p) != -1) {
                        continue;
                    }
                    var owned:Object = playerData[p];
                    if (this.isSoulbound(playerItems[p], owned)) {
                        continue;
                    }
                    if (this.dataMatches(requested, owned)) {
                        usedSlots.push(p);
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    return false;
                }
            }
            var freeSlots:int = 0;
            for (var s:int = FIRST_INVENTORY_SLOT; s < playerItems.length; s++) {
                if (playerItems[s] == -1 || usedSlots.indexOf(s) != -1) {
                    freeSlots++;
                }
            }
            return freeSlots >= this.info_.offerItems_.length;
        }

        /** Enough empty backpack space to collect a finished trade. */
        private function canCollect():Boolean {
            var playerItems:Vector.<int> = this.gs_.map_.player_.equipment_;
            var free:int = 0;
            for (var i:int = FIRST_INVENTORY_SLOT; i < playerItems.length; i++) {
                if (playerItems[i] == -1) {
                    free++;
                }
            }
            return free >= this.info_.offerItems_.length;
        }

        private function isSoulbound(itemType:int, data:Object):Boolean {
            var xml:XML = ObjectLibrary.typeToXML_[itemType];
            return xml.hasOwnProperty("Soulbound") || (this.hasField(data, "Soulbound") && data.Soulbound);
        }

        /** Does the owned item's extra data satisfy the requested item's data? */
        private function dataMatches(requested:Object, owned:Object):Boolean {
            if (this.hasField(requested, "Strange") && requested.Strange) {
                return this.hasField(owned, "Strange");
            }
            return this.fieldMatches(requested, owned, "NamePrefix") && this.fieldMatches(requested, owned, "Effect");
        }

        /** An empty/missing requested value means "must have none"; otherwise the values must be equal. */
        private function fieldMatches(requested:Object, owned:Object, key:String):Boolean {
            var wanted:* = this.hasField(requested, key) ? requested[key] : "";
            var hasOwned:Boolean = this.hasField(owned, key);
            if (wanted != "") {
                return hasOwned && owned[key] == wanted;
            }
            return !(hasOwned && owned[key] != "");
        }

        private function hasField(data:Object, key:String):Boolean {
            return data != null && data.hasOwnProperty(key);
        }

        private function onMouseClick(e:MouseEvent):void {
            this.dispatchEvent(new MarketplaceEvent(this.id_, MarketplaceEvent.TRADE));
        }
    }
}
