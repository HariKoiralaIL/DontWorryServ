package com.company.assembleegameclient.ui {
import audio.SoundEffects;

import com.company.assembleegameclient.net.GameServerClient;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
import com.company.assembleegameclient.ui.tooltip.TitleDescriptionToolTip;
import com.company.assembleegameclient.ui.tooltip.ToolTip;
import com.company.util.GraphicHelper;

import constants.ActorType;

import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.filters.ColorMatrixFilter;
import flash.geom.Point;
import flash.utils.Timer;
import flash.utils.getTimer;

/**
 * A slot of an Inventory that can hold a draggable item. Handles tooltips,
 * drag & drop, shift-click use and the "double click to equip / use / take"
 * shortcut.
 *
 * Formerly: _E_6
 */
public class InventorySlot extends Slot {

    /** Max time between two clicks that counts as a double click, in milliseconds. */
    private static const DOUBLE_CLICK_DELAY:uint = 250;
    private static const DRAG_THRESHOLD:int = 3;
    private static const EMPTY:int = -1;
    private static const FIRST_NON_EQUIPMENT_SLOT:int = 4;

    private static const SOULBOUND_LOOT_BAG:String = "Soulbound Loot Bag";
    private static const LOOT_BAG:String = "Loot Bag";
    private static const VAULT_CHEST:String = "Vault Chest";
    private static const TREASURE_CHEST:String = "Treasure Chest";
    private static const INVENTORY_NAME:String = "Inventory";

    private static const UNUSABLE_OVERLAY_COLOR:uint = 0x8F3803;

    /** Darkens an item whose use needs more mana than the player has. */
    protected static const NOT_ENOUGH_MANA_FILTERS:Array = [new ColorMatrixFilter([0.4, 0, 0, 0, 0, 0, 0.4, 0, 0, 0, 0, 0, 0.4, 0, 0, 0, 0, 0, 1, 0])];

    public static var toolTip_:ToolTip;

    /** The inventory this slot belongs to (formerly _e9). */
    public var inventory_:Inventory;
    public var id_:int;
    /** The item is usable and therefore has a mana cost (formerly _cX_). */
    public var usable_:Boolean = false;
    /** Cached "not enough mana" state used to detect changes (formerly _F_t). */
    public var lackedMana_:Boolean = false;
    public var mpCost_:int;
    public var objectType_:int = -1;
    /** The item graphic currently shown in this slot (formerly _X_B_). */
    public var itemSprite_:DraggableItem = null;
    /** A single-use item was already consumed, wait for the server (formerly _04q). */
    public var consumed_:Boolean = false;
    public var itemData_:Object = null;

    /** Red overlay shown when the player cannot use the item (formerly _D_s). */
    private var unusableOverlay_:Shape;
    private var doubleClickTimer_:Timer;
    /** Clicks seen while the double click timer is running (formerly _O_W_). */
    private var extraClicks_:uint = 0;
    private var actorType_:String;
    private var dragStart_:Point;

    public function InventorySlot(inventory:Inventory, id:int, type:int, hotkeyNumber:int, corners:Array, equipment:Boolean = false) {
        super(type, hotkeyNumber, corners, equipment);
        this.inventory_ = inventory;
        this.id_ = id;
        this.unusableOverlay_ = new Shape();
        var overlayFill:GraphicsSolidFill = new GraphicsSolidFill(UNUSABLE_OVERLAY_COLOR, 1);
        GraphicHelper.clearPath(path_);
        var overlayData:Vector.<IGraphicsData> = new <IGraphicsData>[overlayFill, path_, GraphicHelper.END_FILL];
        GraphicHelper.drawUI(0, 0, WIDTH, HEIGHT, 4, corners_, path_);
        this.unusableOverlay_.graphics.drawGraphicsData(overlayData);
        this.unusableOverlay_.alpha = 0;
        addChild(this.unusableOverlay_);
        this.doubleClickTimer_ = new Timer(DOUBLE_CLICK_DELAY, 1);
        this.doubleClickTimer_.addEventListener(TimerEvent.TIMER_COMPLETE, this.onDoubleClickTimer);
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    /** Can an item of this object type be placed in this slot? Formerly _t8. */
    public function acceptsItemType(objectType:int):Boolean {
        if (type_ == any_) {
            return true;
        }
        return type_ == ObjectLibrary.getSlotTypeFromType(objectType);
    }

    /** Formerly _C_p */
    public function notEnoughMana():Boolean {
        var player:Player = this.inventory_.owner_ as Player;
        return player != null && player.MP_ < this.mpCost_;
    }

    public function draw(objectType:int):void {
        if (this.inventory_ != null && this.inventory_.owner_ != null) {
            this.itemData_ = this.inventory_.owner_.equipData_[this.id_];
        }
        if (this.objectType_ == objectType && (!this.usable_ || this.lackedMana_ == this.notEnoughMana())) {
            return;
        }
        this.objectType_ = objectType;
        this.consumed_ = false;
        this.updateUnusableOverlay();
        this.redrawItem();
    }

    public function refresh():void {
        this.redrawItem();
    }

    /** Rebuilds the item graphic for the current object type. Formerly _0E_J_. */
    public function redrawItem():void {
        this.updateUnusableOverlay();
        var itemXml:XML = ObjectLibrary.typeToXML_[this.objectType_];
        if (this.objectType_ == EMPTY || type_ == any_) {
            this.usable_ = false;
        } else if (itemXml != null && itemXml.hasOwnProperty("Usable")) {
            this.usable_ = true;
            this.mpCost_ = int(itemXml.MpCost);
        } else {
            this.usable_ = false;
        }
        if (this.itemSprite_ != null) {
            this.itemSprite_.parent.removeChild(this.itemSprite_);
            if (emptyIcon_ != null && !contains(emptyIcon_)) {
                addChild(emptyIcon_);
            }
            this.itemSprite_ = null;
        }
        if (this.objectType_ < 0 || itemXml == null) {
            return;
        }
        var slotType:int = ObjectLibrary.getSlotTypeFromType(this.objectType_);
        var offset:Point = getIconOffset(this.objectType_, slotType, false);
        this.itemSprite_ = new DraggableItem(this.objectType_, this, this.itemData_);
        this.itemSprite_.x = (WIDTH / 2) + offset.x;
        this.itemSprite_.y = (HEIGHT / 2) + offset.y;
        if (this.usable_) {
            this.lackedMana_ = this.notEnoughMana();
            if (this.lackedMana_) {
                this.itemSprite_.filters = NOT_ENOUGH_MANA_FILTERS;
            }
        }
        addChild(this.itemSprite_);
        if (emptyIcon_ != null && contains(emptyIcon_)) {
            removeChild(emptyIcon_);
        }
        this.updateUnusableOverlay();
    }

    /** Uses the item (drink a potion, activate a consumable, ...). */
    public function attemptUse():void {
        var itemXml:XML = ObjectLibrary.typeToXML_[this.objectType_];
        if (itemXml == null) {
            return;
        }
        var player:Player = this.inventory_.gs_.map_.player_;
        if (player == null || player.isPaused()) {
            return;
        }
        var consumable:Boolean = itemXml.hasOwnProperty("Consumable");
        var invUse:Boolean = itemXml.hasOwnProperty("InvUse");
        if (!consumable && !invUse) {
            return;
        }
        if (consumable && (this.itemData_ != null ? !this.itemData_.MultiUse : true)) {
            if (this.consumed_) {
                return;
            }
            this.consumed_ = true;
        }
        this.inventory_.gs_.gsc_.useItem(getTimer(), this.inventory_.owner_.objectId_, this.id_, this.objectType_, 0, 0);
        SoundEffects.play("use_potion");
        this.updateUnusableOverlay();
    }

    /** Shows the red overlay when the player can't use / equip the item. Formerly _X_6. */
    private function updateUnusableOverlay():void {
        if (this.inventory_.gs_ == null) {
            return;
        }
        var player:Player = this.inventory_.gs_.map_.player_;
        var canUse:Boolean = ObjectLibrary.canUseItem(this.objectType_, player) && ObjectLibrary.checkLevelRequirement(this.objectType_, player);
        if (this.objectType_ != EMPTY && canUse == false && this.itemSprite_ != null && this.itemSprite_.dragging_ == false) {
            this.unusableOverlay_.alpha = 1;
        } else {
            this.unusableOverlay_.alpha = 0;
        }
    }

    /** Formerly _5I_ */
    private function getSlotTypeLabel():String {
        if (type_ == any_) {
            return this.inventory_.name_;
        }
        return getSlotTypeName(type_);
    }

    /** Formerly _c1 */
    private function updateActorType():void {
        if (this.inventory_.gs_) {
            if (this.inventory_.owner_ is Player) {
                if (this.inventory_.owner_ == this.inventory_.gs_.map_.player_) {
                    this.actorType_ = ActorType.CURRENT_PLAYER;
                } else {
                    this.actorType_ = ActorType.OTHER_PLAYER;
                }
            } else {
                this.actorType_ = ActorType.NPC;
            }
        }
    }

    /** Formerly _9 */
    private function hideToolTip():void {
        if (toolTip_ != null) {
            if (toolTip_.parent != null) {
                toolTip_.parent.removeChild(toolTip_);
            }
            toolTip_ = null;
        }
    }

    /** Formerly _i9 */
    private function createEmptySlotToolTip():void {
        toolTip_ = new TitleDescriptionToolTip(0x2A2A2A, 0x9B9B9B, null, "Empty " + this.getSlotTypeLabel() + " slot", 200);
    }

    /** Formerly _H_T_ */
    private function createItemToolTip():void {
        var inventoryFull:Boolean = this.inventory_.isFull();
        if (ObjectLibrary.getIdFromType(this.objectType_) != null) {
            var player:Player = (this.inventory_.gs_ != null) ? this.inventory_.gs_.map_.player_ : null;
            var ownerType:int = (this.inventory_.owner_ != null) ? this.inventory_.owner_.objectType_ : -1;
            toolTip_ = new EquipmentToolTip(this.objectType_, player, ownerType, this.actorType_, this.itemSprite_.slot_.id_, inventoryFull, this.itemData_);
        } else {
            this.createEmptySlotToolTip();
        }
    }

    /** Formerly _6i */
    private function showToolTip():void {
        if (this.objectType_ == EMPTY) {
            this.createEmptySlotToolTip();
        } else {
            this.createItemToolTip();
        }
        stage.addChild(toolTip_);
    }

    /** Formerly _V_V_ */
    private function removeDragListeners():void {
        if (stage) {
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
        }
    }

    /** Double click: equip / use from the inventory, or take from a container. Formerly _Y_y. */
    private function onDoubleClick():void {
        if (this.inventory_.name_ == INVENTORY_NAME) {
            this.equipOrUse();
        } else {
            this.useFromContainer();
        }
    }

    /** Double click on a slot of a loot bag / chest. Formerly _00W_. */
    private function useFromContainer():void {
        if (this.isPlayerInventoryFull()) {
            var player:Player = this.getPlayer();
            var fitsEquipment:Boolean = ObjectLibrary.fitsPlayerSlots(this.objectType_, player);
            var itemXml:XML = ObjectLibrary.typeToXML_[this.objectType_];
            var itemSlotType:int = itemXml.SlotType;
            if (fitsEquipment) {
                this.equipInMatchingSlot(player, itemSlotType);
                return;
            }
            this.attemptUse();
        } else if (this.isContainerSlot()) {
            this.moveToFirstEmptySlot();
        }
    }

    /** Double click on a slot of the player's own inventory. Formerly _V_q. */
    private function equipOrUse():void {
        var player:Player = this.getPlayer();
        var fitsEquipment:Boolean = ObjectLibrary.fitsPlayerSlots(this.objectType_, player);
        var meetsLevel:Boolean = ObjectLibrary.checkLevelRequirement(this.objectType_, player);
        var itemXml:XML = ObjectLibrary.typeToXML_[this.objectType_];
        var itemSlotType:int = itemXml.SlotType;
        if (fitsEquipment && meetsLevel) {
            this.equipInMatchingSlot(player, itemSlotType);
            return;
        }
        this.attemptUse();
    }

    /** Swaps this item into the player's equipment slot of the same type. */
    private function equipInMatchingSlot(player:Player, itemSlotType:int):void {
        for (var i:uint = 0; i < FIRST_NON_EQUIPMENT_SLOT; i++) {
            if (player.slotTypes_[i] == itemSlotType) {
                this.swapWith(this.getPlayerInventory().slots_[i]);
                return;
            }
        }
    }

    /** True when the player has no free non-equipment slot. Formerly _I_N_. */
    private function isPlayerInventoryFull():Boolean {
        var playerInventory:Inventory = this.getPlayerInventory();
        for (var i:uint = FIRST_NON_EQUIPMENT_SLOT; i < playerInventory.slots_.length; i++) {
            if (playerInventory.slots_[i].objectType_ == EMPTY) {
                return false;
            }
        }
        return true;
    }

    /** Is this slot part of a loot bag / chest? Formerly _W_4. */
    private function isContainerSlot():Boolean {
        var name:String = this.inventory_.name_;
        return name == LOOT_BAG || name == VAULT_CHEST || name == SOULBOUND_LOOT_BAG || name == TREASURE_CHEST;
    }

    /** Picks the item up so it can be dragged. Formerly _4k. */
    private function beginDrag():void {
        if (this.itemSprite_ != null && contains(this.itemSprite_)) {
            if (emptyIcon_ != null && !contains(emptyIcon_)) {
                addChild(emptyIcon_);
            }
            removeChild(this.itemSprite_);
            var localPosition:Point = new Point(this.itemSprite_.x, this.itemSprite_.y);
            var globalPosition:Point = localToGlobal(localPosition);
            this.itemSprite_.startDrag(true);
            this.itemSprite_.dragging_ = true;
            stage.addChild(this.itemSprite_);
            this.itemSprite_.x = globalPosition.x;
            this.itemSprite_.y = globalPosition.y;
        }
        this.updateUnusableOverlay();
    }

    /** Moves the item into the first free inventory slot. Formerly _bL_. */
    private function moveToFirstEmptySlot():void {
        var playerInventory:Inventory = this.getPlayerInventory();
        for each (var slot:InventorySlot in playerInventory.slots_) {
            if (slot.objectType_ == EMPTY && slot.id_ > 3) {
                this.swapWith(slot);
                break;
            }
        }
    }

    /** Asks the server to swap this slot's item with the target slot's. Formerly _0A_v. */
    private function swapWith(target:InventorySlot):void {
        var client:GameServerClient = this.getServerClient();
        var player:Player = this.getPlayer();
        client.invSwap(player, this.inventory_.owner_, this.id_, this.objectType_, target.inventory_.owner_, target.id_, target.objectType_);
        this.updateUnusableOverlay();
    }

    /** Formerly _gw */
    private function getServerClient():GameServerClient {
        return this.inventory_.gs_.gsc_;
    }

    /** Formerly _v5 */
    private function getPlayer():Player {
        return this.inventory_.gs_.map_.player_;
    }

    /** The inventory (slots 4+) of the local player's panel. Formerly _A_P_. */
    private function getPlayerInventory():Inventory {
        return this.inventory_.gs_.hudView_.invTabs_.inventory_;
    }

    private function onAddedToStage(event:Event):void {
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        if (this.inventory_.gs_ != null) {
            addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
        }
        this.updateUnusableOverlay();
    }

    private function onRemovedFromStage(event:Event):void {
        if (this.itemSprite_ != null) {
            this.itemSprite_.parent.removeChild(this.itemSprite_);
            this.itemSprite_ = null;
            this.objectType_ = EMPTY;
        }
        this.hideToolTip();
        removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        if (this.inventory_.gs_ != null) {
            removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            this.removeDragListeners();
        }
    }

    private function onMouseOver(event:MouseEvent):void {
        this.updateActorType();
        this.hideToolTip();
        this.showToolTip();
    }

    private function onMouseDown(event:MouseEvent):void {
        this.hideToolTip();
        if (event.shiftKey) {
            this.attemptUse();
            return;
        }
        this.dragStart_ = new Point(event.stageX, event.stageY);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove, false, 0, true);
        stage.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
        if (this.doubleClickTimer_.running == false) {
            this.extraClicks_ = 0;
            this.doubleClickTimer_.reset();
            this.doubleClickTimer_.start();
        } else {
            this.extraClicks_++;
        }
    }

    private function onMouseMove(event:MouseEvent):void {
        var dx:Number = event.stageX - this.dragStart_.x;
        var dy:Number = event.stageY - this.dragStart_.y;
        var distance:Number = Math.sqrt((dx * dx) + (dy * dy));
        if (distance > DRAG_THRESHOLD) {
            this.doubleClickTimer_.reset();
            this.removeDragListeners();
            this.beginDrag();
        }
    }

    private function onMouseUp(event:Event):void {
        this.removeDragListeners();
        this.dragStart_ = null;
    }

    private function onDoubleClickTimer(event:TimerEvent):void {
        if (Parameters.data_["contextualClick"] == false) {
            return;
        }
        if (this.extraClicks_ > 0) {
            if (this.itemSprite_) {
                this.onDoubleClick();
            }
        }
    }

    private function onMouseOut(event:MouseEvent):void {
        this.hideToolTip();
    }
}
}
