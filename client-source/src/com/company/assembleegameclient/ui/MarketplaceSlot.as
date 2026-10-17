package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
import com.company.util.GraphicHelper;

import constants.ActorType;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

/**
 * Item tile of the marketplace: rounded frame in the item's name colour, the
 * item icon, a dimmed overlay when disabled and an item tooltip on hover.
 */
public class MarketplaceSlot extends Sprite {

    public static const WIDTH:int = 48;
    public static const HEIGHT:int = 48;

    private static const DEFAULT_COLOR:uint = 0xFFFFFF;
    private static const DEFAULT_SCALE:Number = 5;
    private static const FRAME_DARKEN_PERCENT:int = 25;

    public var gs_:GameSprite;
    public var item_:int;
    public var data_:Object;
    public var itemBitmap_:Bitmap;
    public var toolTip_:EquipmentToolTip;
    public var enabled_:Boolean;
    public var slot_:int = 0;
    public var selectItem_:Boolean;

    protected var fill_:GraphicsSolidFill = new GraphicsSolidFill(0x7A1300);
    protected var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());

    private var disabledOverlay_:Sprite;
    private var graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[fill_, path_, GraphicHelper.END_FILL];

    /**
     * @param item       object type of the item, or -1 for an empty tile
     * @param data       item instance data (name colour, custom texture, ...)
     * @param gs         game sprite
     * @param enabled    false draws a dimmed overlay
     * @param selectItem true when the tile is used for selecting (no tooltip)
     */
    public function MarketplaceSlot(item:int, data:Object, gs:GameSprite, enabled:Boolean, selectItem:Boolean = false) {
        super();
        this.gs_ = gs;
        this.item_ = item;
        this.data_ = data;
        this.enabled_ = enabled;
        this.selectItem_ = selectItem;
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        this.redraw();
    }

    public function redraw():void {
        var color:uint = DEFAULT_COLOR;
        if (this.data_ != null && this.data_.hasOwnProperty("NameColor")) {
            color = this.data_.NameColor;
        }
        // Dark outer frame, then the lighter inner fill.
        this.fill_.color = GraphicHelper.darkenColor(color, FRAME_DARKEN_PERCENT);
        this.graphicsData_ = new <IGraphicsData>[this.fill_, this.path_, GraphicHelper.END_FILL];
        GraphicHelper.clearPath(this.path_);
        GraphicHelper.drawUI(0, 0, WIDTH, HEIGHT, 6, [1, 1, 1, 1], this.path_);
        graphics.clear();
        graphics.drawGraphicsData(this.graphicsData_);
        GraphicHelper.drawUI(3, 3, WIDTH - 6, HEIGHT - 6, 6, [1, 1, 1, 1], this.path_);
        this.fill_.color = color;
        this.graphicsData_ = new <IGraphicsData>[this.fill_, this.path_, GraphicHelper.END_FILL];
        graphics.drawGraphicsData(this.graphicsData_);

        if (this.itemBitmap_ != null && this.contains(this.itemBitmap_)) {
            removeChild(this.itemBitmap_);
            this.itemBitmap_ = null;
        }
        if (this.item_ != -1) {
            var itemXml:XML = ObjectLibrary.typeToXML_[this.item_];
            var scale:Number = DEFAULT_SCALE;
            if (itemXml.hasOwnProperty("ScaleValue")) {
                scale = itemXml.ScaleValue;
            }
            var texture:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.item_, 80, true, true, scale);
            if (this.data_ != null && this.data_.hasOwnProperty("TextureFile") && this.data_.TextureFile != "") {
                // NOTE: the 4th argument is the item type here but the item data in
                // DraggableItem / TradeSlot - possibly a bug in the original, left unchanged.
                texture = ObjectLibrary.getRedrawnTextureFromTypeCustom(this.item_, 80, true, this.item_, true, scale);
            }
            this.itemBitmap_ = new Bitmap(texture);
            var offset:Point = getIconOffset(this.item_, ObjectLibrary.getSlotTypeFromType(this.item_), false);
            this.itemBitmap_.x = (-this.itemBitmap_.width / 2) + (WIDTH / 2) + offset.x;
            this.itemBitmap_.y = (-this.itemBitmap_.height / 2) + (HEIGHT / 2) + offset.y;
            addChild(this.itemBitmap_);
        }

        if (this.disabledOverlay_ != null && this.contains(this.disabledOverlay_)) {
            removeChild(this.disabledOverlay_);
            this.disabledOverlay_ = null;
        }
        if (!this.enabled_) {
            // Octagon with 6px cut corners, matching the tile shape.
            this.disabledOverlay_ = new Sprite();
            this.disabledOverlay_.graphics.beginFill(0, 0.5);
            this.disabledOverlay_.graphics.moveTo(6, 0);
            this.disabledOverlay_.graphics.lineTo(WIDTH - 6, 0);
            this.disabledOverlay_.graphics.lineTo(WIDTH, 6);
            this.disabledOverlay_.graphics.lineTo(WIDTH, HEIGHT - 6);
            this.disabledOverlay_.graphics.lineTo(WIDTH - 6, HEIGHT);
            this.disabledOverlay_.graphics.lineTo(6, HEIGHT);
            this.disabledOverlay_.graphics.lineTo(0, HEIGHT - 6);
            this.disabledOverlay_.graphics.lineTo(0, 6);
            this.disabledOverlay_.graphics.lineTo(6, 0);
            this.disabledOverlay_.graphics.endFill();
            addChild(this.disabledOverlay_);
        }
    }

    /** Same icon nudging as Slot.getIconOffset. */
    protected function getIconOffset(itemType:int, slotType:int, emptyIcon:Boolean):Point {
        var offset:Point = new Point();
        switch (slotType) {
            case Slot.accessory_:
                offset.x = (itemType == 2878) ? 0 : -2;
                offset.y = emptyIcon ? -2 : 0;
                break;
            case Slot.spell_:
                offset.y = -2;
                break;
        }
        return offset;
    }

    private function hideToolTip():void {
        if (this.toolTip_ != null) {
            if (this.toolTip_.parent != null) {
                this.toolTip_.parent.removeChild(this.toolTip_);
            }
            this.toolTip_ = null;
        }
    }

    private function onMouseOver(event:MouseEvent):void {
        this.hideToolTip();
        if (this.item_ != -1 && ObjectLibrary.getIdFromType(this.item_) != null) {
            this.toolTip_ = new EquipmentToolTip(this.item_, this.gs_.map_.player_, -1, ActorType.NPC, 1, false, this.data_);
            stage.addChild(this.toolTip_);
        }
    }

    private function onMouseOut(event:MouseEvent):void {
        this.hideToolTip();
    }

    private function onAddedToStage(event:Event):void {
        if (!this.selectItem_) {
            this.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            this.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        }
    }

    private function onRemovedFromStage(event:Event):void {
        this.hideToolTip();
        if (!this.selectItem_) {
            this.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            this.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        }
    }
}
}
