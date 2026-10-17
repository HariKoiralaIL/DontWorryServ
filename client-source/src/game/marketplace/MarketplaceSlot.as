package game.marketplace {
    import com.company.assembleegameclient.game.GameSprite;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
    import com.company.util.GraphicHelper;

    import constants.ActorType;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.display.GraphicsPath;
    import flash.display.GraphicsSolidFill;
    import flash.display.IGraphicsData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    public class MarketplaceSlot extends Sprite {

        public static const WIDTH:int = 48;
        public static const HEIGHT:int = 48;

        private static const CORNER_RADIUS:int = 6;
        private static const BORDER:int = 3;
        private static const TEXTURE_SIZE:int = 80;
        private static const DEFAULT_ITEM_SCALE:Number = 5;

        public var gs_:GameSprite;
        public var item_:int;
        public var data_:Object;
        public var itemBitmap_:Bitmap;
        public var toolTip_:EquipmentToolTip;
        public var enabled_:Boolean;
        public var slot_:int = 0;
        public var selectItem_:Boolean;

        protected var fill_:GraphicsSolidFill;
        protected var path_:GraphicsPath;

        private var disabledOverlay_:Sprite;
        private var graphicsData_:Vector.<IGraphicsData>;

        public function MarketplaceSlot(item:int, data:Object, gs:GameSprite, enabled:Boolean, selectItem:Boolean = false) {
            super();
            this.fill_ = new GraphicsSolidFill(0x565656);
            this.path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
            this.graphicsData_ = new <IGraphicsData>[this.fill_, this.path_, GraphicHelper.END_FILL];
            this.gs_ = gs;
            this.item_ = item;
            this.data_ = data;
            this.enabled_ = enabled;
            this.selectItem_ = selectItem;
            this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
            this.redraw();
        }

        public function redraw():void {
            var color:uint = ObjectLibrary.getItemNameColor(this.item_);
            if (this.data_ != null && this.data_.hasOwnProperty("NameColor")) {
                color = this.data_.NameColor;
            }
            // Outer shape in a darkened colour, then the border ring (even-odd) in the item colour.
            this.fill_.color = GraphicHelper.darkenColor(color, 25);
            GraphicHelper.clearPath(this.path_);
            GraphicHelper.drawUI(0, 0, WIDTH, HEIGHT, CORNER_RADIUS, [1, 1, 1, 1], this.path_);
            graphics.clear();
            graphics.drawGraphicsData(this.graphicsData_);
            GraphicHelper.drawUI(BORDER, BORDER, WIDTH - (BORDER * 2), HEIGHT - (BORDER * 2), CORNER_RADIUS, [1, 1, 1, 1], this.path_);
            this.fill_.color = color;
            graphics.drawGraphicsData(this.graphicsData_);
            this.redrawItem();
            this.redrawDisabledOverlay();
        }

        protected function getItemOffset(itemType:int, slotType:int):Point {
            var offset:Point = new Point();
            switch (slotType) {
                case 9:
                    offset.x = ((itemType == 2878) ? 0 : -2);
                    break;
                case 11:
                    offset.y = -2;
                    break;
            }
            return offset;
        }

        private function redrawItem():void {
            if (this.itemBitmap_ != null && this.contains(this.itemBitmap_)) {
                removeChild(this.itemBitmap_);
                this.itemBitmap_ = null;
            }
            if (this.item_ == -1) {
                return;
            }
            var xml:XML = ObjectLibrary.typeToXML_[this.item_];
            var scale:Number = DEFAULT_ITEM_SCALE;
            if (xml.hasOwnProperty("ScaleValue")) {
                scale = xml.ScaleValue;
            }
            var texture:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.item_, TEXTURE_SIZE, true, true, scale, 0, 0);
            if (this.data_ != null && this.data_.hasOwnProperty("TextureFile") && this.data_.TextureFile != "") {
                texture = ObjectLibrary.getRedrawnTextureFromTypeCustom(this.item_, TEXTURE_SIZE, true, this.item_, true, scale, 0, 0);
            }
            this.itemBitmap_ = new Bitmap(texture);
            var offset:Point = this.getItemOffset(this.item_, ObjectLibrary.getSlotTypeFromType(this.item_));
            this.itemBitmap_.x = (-(this.itemBitmap_.width) / 2) + (WIDTH / 2) + offset.x;
            this.itemBitmap_.y = (-(this.itemBitmap_.height) / 2) + (HEIGHT / 2) + offset.y;
            addChild(this.itemBitmap_);
        }

        private function redrawDisabledOverlay():void {
            if (this.disabledOverlay_ != null && this.contains(this.disabledOverlay_)) {
                removeChild(this.disabledOverlay_);
                this.disabledOverlay_ = null;
            }
            if (this.enabled_) {
                return;
            }
            this.disabledOverlay_ = new Sprite();
            var g:Graphics = this.disabledOverlay_.graphics;
            g.beginFill(0, 0.5);
            g.moveTo(6, 0);
            g.lineTo(WIDTH - 6, 0);
            g.lineTo(WIDTH, 6);
            g.lineTo(WIDTH, HEIGHT - 6);
            g.lineTo(WIDTH - 6, HEIGHT);
            g.lineTo(6, HEIGHT);
            g.lineTo(0, HEIGHT - 6);
            g.lineTo(0, 6);
            g.lineTo(6, 0);
            g.endFill();
            addChild(this.disabledOverlay_);
        }

        private function removeToolTip():void {
            if (this.toolTip_ != null) {
                if (this.toolTip_.parent != null) {
                    this.toolTip_.parent.removeChild(this.toolTip_);
                }
                this.toolTip_ = null;
            }
        }

        private function onMouseOver(e:MouseEvent):void {
            this.removeToolTip();
            if (this.item_ != -1 && ObjectLibrary.getIdFromType(this.item_) != null) {
                this.toolTip_ = new EquipmentToolTip(this.item_, this.gs_.map_.player_, -1, ActorType.NPC, 1, false, this.data_);
                stage.addChild(this.toolTip_);
            }
        }

        private function onMouseOut(e:MouseEvent):void {
            this.removeToolTip();
        }

        private function onAddedToStage(e:Event):void {
            if (!this.selectItem_) {
                this.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
                this.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            }
        }

        private function onRemovedFromStage(e:Event):void {
            this.removeToolTip();
            if (!this.selectItem_) {
                this.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
                this.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            }
        }
    }
}
