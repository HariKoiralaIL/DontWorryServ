package game.marketplace {
    import com.company.assembleegameclient.game.GameSprite;
    import com.company.assembleegameclient.objects.ObjectLibrary;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class MarketplaceInventory extends Sprite {

        /** Player inventory: clicking a slot toggles whether it is included in the trade. */
        public static const MODE_SELECT:int = 1;
        /** Chosen items list: clicking a slot removes it. */
        public static const MODE_EDIT:int = 2;

        private static const COLUMNS:int = 4;
        private static const SPACING:int = 4;

        public var gs_:GameSprite;
        public var equipment_:Vector.<int>;
        public var equipData_:Vector.<Object>;
        public var mode_:int;
        public var slots_:Vector.<MarketplaceSlot>;

        public function MarketplaceInventory(equipment:Vector.<int>, equipData:Vector.<Object>, gs:GameSprite, mode:int) {
            super();
            this.equipment_ = equipment;
            this.equipData_ = equipData;
            this.mode_ = mode;
            this.gs_ = gs;
            this.build();
        }

        public function build():void {
            this.slots_ = new Vector.<MarketplaceSlot>();
            for (var i:int = 0; i < this.equipment_.length; i++) {
                var slot:MarketplaceSlot = new MarketplaceSlot(this.equipment_[i], this.equipData_[i], this.gs_, this.mode_ != MODE_SELECT);
                slot.x = (i % COLUMNS) * (MarketplaceSlot.WIDTH + SPACING);
                slot.y = Math.floor(i / COLUMNS) * (MarketplaceSlot.HEIGHT + SPACING);
                slot.slot_ = i;
                this.slots_.push(slot);
                addChild(slot);
                slot.addEventListener(MouseEvent.CLICK, this.onClickSlot);
            }
        }

        public function rebuild():void {
            for each (var slot:MarketplaceSlot in this.slots_) {
                this.removeChild(slot);
            }
            this.build();
            this.dispatchEvent(new Event(Event.CHANGE));
        }

        public function addItem(item:int, data:Object):void {
            this.equipment_.push(item);
            this.equipData_.push(data);
            this.rebuild();
        }

        /** Slot indices the player left enabled. */
        public function getIncludedSlots():Vector.<int> {
            var included:Vector.<int> = new Vector.<int>();
            for each (var slot:MarketplaceSlot in this.slots_) {
                if (slot.enabled_) {
                    included.push(slot.slot_);
                }
            }
            return included;
        }

        private function onClickSlot(e:MouseEvent):void {
            var slot:MarketplaceSlot = (e.currentTarget as MarketplaceSlot);
            if (slot.item_ == -1) {
                return;
            }
            if (this.mode_ == MODE_SELECT) {
                var xml:XML = ObjectLibrary.typeToXML_[slot.item_];
                if (xml.hasOwnProperty("Soulbound") || (slot.data_ != null && slot.data_.Soulbound)) {
                    return;
                }
                slot.enabled_ = !slot.enabled_;
                slot.redraw();
            } else if (this.mode_ == MODE_EDIT) {
                var index:int = this.slots_.indexOf(slot);
                this.equipment_.splice(index, 1);
                this.equipData_.splice(index, 1);
                this.rebuild();
            }
        }
    }
}
