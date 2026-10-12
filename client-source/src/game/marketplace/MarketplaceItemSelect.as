package game.marketplace {
    import client.ui.frames.DataChooser;
    import client.ui.frames.TextInput;

    import com.company.assembleegameclient.game.GameSprite;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.assembleegameclient.ui.FrameHolder;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    /** Item search box plus the list of items chosen so far. */
    public class MarketplaceItemSelect extends Sprite {

        public static const TYPE_MARKET_CREATE:String = "marketCreate";

        private static const MAX_ITEMS:int = 8;
        private static const SLOT_SPACING:int = 4;

        public var inventory_:MarketplaceInventory;
        public var perRow_:int;

        protected var type_:String;

        private var gs_:GameSprite;
        private var items_:Vector.<int>;
        private var datas_:Vector.<Object>;
        private var searchPanel_:Sprite;
        private var search_:TextInput;
        private var choices_:Sprite;
        private var choiceImages_:Vector.<MarketplaceSlot>;

        public function MarketplaceItemSelect(gs:GameSprite) {
            super();
            this.gs_ = gs;
            this.items_ = new Vector.<int>();
            this.datas_ = new Vector.<Object>();
            this.choiceImages_ = new Vector.<MarketplaceSlot>();
            this.perRow_ = 5;
            this.build();
        }

        public function build():void {
            this.inventory_ = new MarketplaceInventory(this.items_, this.datas_, this.gs_, MarketplaceInventory.MODE_EDIT);
            addChild(this.inventory_);
            this.inventory_.addEventListener(Event.CHANGE, this.moveInventory);
            this.searchPanel_ = new Sprite();
            this.searchPanel_.y = 104;
            this.searchPanel_.x = -26;
            this.search_ = new TextInput("", false, "");
            this.search_.x = 9;
            this.searchPanel_.addChild(this.search_);
            this.search_.addEventListener(Event.CHANGE, this.onSearchInput);
            this.choices_ = new Sprite();
            this.choices_.y = this.search_.height - 15;
            this.searchPanel_.addChild(this.choices_);
            this.addChild(this.searchPanel_);
        }

        public function itemSearch(query:String):void {
            for each (var old:MarketplaceSlot in this.choiceImages_) {
                this.choices_.removeChild(old);
            }
            this.choiceImages_ = new Vector.<MarketplaceSlot>();
            if (query == "") {
                return;
            }
            var matches:Vector.<int> = ObjectLibrary.searchItems(query);
            var count:int = 0;
            for (var i:int = 0; i < matches.length; i++) {
                var type:int = matches[i];
                if (ObjectLibrary._6H_(type) == null) {
                    continue;
                }
                var xml:XML = ObjectLibrary._Q_F_[type];
                if (xml.hasOwnProperty("AdminOnly") || xml.hasOwnProperty("Soulbound")) {
                    continue;
                }
                var slot:MarketplaceSlot = new MarketplaceSlot(type, null, this.gs_, true, true);
                slot.x = (count % this.perRow_) * (MarketplaceSlot.WIDTH + SLOT_SPACING);
                slot.y = Math.floor(count / this.perRow_) * (MarketplaceSlot.HEIGHT + SLOT_SPACING);
                this.choices_.addChild(slot);
                this.choiceImages_.push(slot);
                slot.addEventListener(MouseEvent.CLICK, this.onClickItem);
                count++;
            }
        }

        public function setType(type:String):void {
            this.type_ = type;
            if (this.type_ == TYPE_MARKET_CREATE) {
                this.perRow_ = 14;
                this.inventory_.x = 314;
                this.search_.x = 1;
            }
        }

        /** Items that carry extra data must be configured in a DataChooser first. */
        private function needsDataChooser(xml:XML):Boolean {
            return xml.@id == "Strange Part"
                || xml.@id == "Strangifier"
                || xml.hasOwnProperty("Projectile")
                || (xml.hasOwnProperty("Activate") && xml.Activate == "UnlockSkin");
        }

        private function onSearchInput(e:Event):void {
            this.itemSearch(this.search_.text());
        }

        private function onClickItem(e:MouseEvent):void {
            var slot:MarketplaceSlot = (e.currentTarget as MarketplaceSlot);
            if (this.inventory_.equipment_.length >= MAX_ITEMS) {
                return;
            }
            var xml:XML = ObjectLibrary._Q_F_[slot.item_];
            if (xml == null) {
                return;
            }
            if (this.needsDataChooser(xml)) {
                var chooser:DataChooser = new DataChooser(this.gs_, slot.item_);
                stage.addChild(new FrameHolder(chooser));
                chooser.addEventListener(Event.COMPLETE, this.onItemAdd);
            } else {
                this.inventory_.addItem(slot.item_, null);
            }
        }

        private function onItemAdd(e:Event):void {
            var chooser:DataChooser = (e.currentTarget as DataChooser);
            if (!chooser.canceled_) {
                this.inventory_.addItem(chooser.itemType_, chooser.itemData_);
            }
        }

        private function moveInventory(e:Event):void {
            this.inventory_.y = 50 - (this.inventory_.height / 2);
        }
    }
}
