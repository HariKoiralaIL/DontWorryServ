package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.net.messages.data.TradeItem;
import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
import com.company.assembleegameclient.ui.tooltip.ToolTip;
import com.company.ui.SimpleText;

import constants.ActorType;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

/**
 * One side of the trade window: a player name, a status line and a grid of
 * TradeSlots. Dispatches Event.CHANGE when the local player toggles a slot.
 *
 * Formerly: _eb
 */
public class TradeInventory extends Sprite {

    public static const STATE_CLICK_ITEMS:int = 0;
    public static const STATE_NO_SPACE:int = 1;
    public static const STATE_ACCEPTED:int = 2;
    public static const STATE_PLAYER_SELECTING:int = 3;

    private static const NORMAL_COLOR:uint = 0xB3B3B3;
    private static const ERROR_COLOR:uint = 0xFF0000;
    private static const ACCEPTED_COLOR:uint = 0x89AB5C;

    private static const SLOTS_PER_ROW:int = 4;
    private static const SLOT_SPACING:int = 4;
    private static const GRID_TOP:int = 46;
    /** Number of equipment slots at the start of the grid (never counted as free space). */
    private static const EQUIPMENT_SLOTS:int = 4;

    private static const NO_CORNERS:Array = [0, 0, 0, 0];
    private static const SLOT_CORNERS:Array = [
        [1, 0, 0, 1],
        NO_CORNERS,
        NO_CORNERS,
        [0, 1, 1, 0],
        [1, 0, 0, 0],
        NO_CORNERS,
        NO_CORNERS,
        [0, 1, 0, 0],
        [0, 0, 0, 1],
        NO_CORNERS,
        NO_CORNERS,
        [0, 0, 1, 0]
    ];

    private static var toolTip_:ToolTip = null;

    public var gs_:GameSprite;
    public var playerName_:String;
    public var slots_:Vector.<TradeSlot> = new Vector.<TradeSlot>();

    private var nameText_:SimpleText;
    private var taglineText_:SimpleText;

    /**
     * @param gs          game sprite
     * @param playerName  name shown above the grid
     * @param items       items offered by this player
     * @param interactive true for the local player's side (slots can be toggled)
     */
    public function TradeInventory(gs:GameSprite, playerName:String, items:Vector.<TradeItem>, interactive:Boolean) {
        super();
        this.gs_ = gs;
        this.playerName_ = playerName;
        this.nameText_ = new SimpleText(20, NORMAL_COLOR, false, 0, 0, "Myriad Pro");
        this.nameText_.setBold(true);
        this.nameText_.x = 0;
        this.nameText_.y = 0;
        this.nameText_.text = this.playerName_;
        this.nameText_.updateMetrics();
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.nameText_);
        this.taglineText_ = new SimpleText(12, NORMAL_COLOR, false, 0, 0, "Myriad Pro");
        this.taglineText_.x = 0;
        this.taglineText_.y = 22;
        this.taglineText_.text = "";
        this.taglineText_.updateMetrics();
        this.taglineText_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.taglineText_);
        for (var i:int = 0; i < items.length; i++) {
            var item:TradeItem = items[i];
            var slot:TradeSlot = new TradeSlot(item.item_, item.tradeable_, item.included_, item.slotType_, i - 3, SLOT_CORNERS[i], i, JSON.parse(item.data_));
            slot.x = int(i % SLOTS_PER_ROW) * (Slot.WIDTH + SLOT_SPACING);
            slot.y = int(i / SLOTS_PER_ROW) * (Slot.HEIGHT + SLOT_SPACING) + GRID_TOP;
            if (item.item_ != -1) {
                slot.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
                slot.addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
            }
            if (interactive && item.tradeable_) {
                slot.addEventListener(MouseEvent.MOUSE_DOWN, this.onSlotClick);
            }
            this.slots_.push(slot);
            addChild(slot);
        }
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    /** Formerly _ao */
    public function getIncludedFlags():Vector.<Boolean> {
        var flags:Vector.<Boolean> = new Vector.<Boolean>();
        for (var i:int = 0; i < this.slots_.length; i++) {
            flags.push(this.slots_[i].included_);
        }
        return flags;
    }

    /** Formerly _0K_s */
    public function setIncludedFlags(flags:Vector.<Boolean>):void {
        for (var i:int = 0; i < this.slots_.length; i++) {
            this.slots_[i].setIncluded(flags[i]);
        }
    }

    /** Formerly _02S_ */
    public function matchesIncludedFlags(flags:Vector.<Boolean>):Boolean {
        for (var i:int = 0; i < this.slots_.length; i++) {
            if (flags[i] != this.slots_[i].included_) {
                return false;
            }
        }
        return true;
    }

    /** Number of slots currently included in the trade; formerly _07c. */
    public function countIncluded():int {
        var count:int = 0;
        for (var i:int = 0; i < this.slots_.length; i++) {
            if (this.slots_[i].included_) {
                count++;
            }
        }
        return count;
    }

    /** Number of empty non-equipment slots; formerly _91. */
    public function countEmptySlots():int {
        var count:int = 0;
        for (var i:int = EQUIPMENT_SLOTS; i < this.slots_.length; i++) {
            if (this.slots_[i].item_ == -1) {
                count++;
            }
        }
        return count;
    }

    /** Formerly _07t */
    public function setState(state:int):void {
        switch (state) {
            case STATE_CLICK_ITEMS:
                this.setStatus(NORMAL_COLOR, "Click items you want to trade");
                return;
            case STATE_NO_SPACE:
                this.setStatus(ERROR_COLOR, "Not enough space for trade!");
                return;
            case STATE_ACCEPTED:
                this.setStatus(ACCEPTED_COLOR, "Trade accepted!");
                return;
            case STATE_PLAYER_SELECTING:
                this.setStatus(NORMAL_COLOR, "Player is selecting items");
                return;
        }
    }

    private function setStatus(color:uint, message:String):void {
        this.nameText_.setColor(color);
        this.taglineText_.setColor(color);
        this.taglineText_.text = message;
        this.taglineText_.updateMetrics();
    }

    private function showToolTip(newToolTip:ToolTip):void {
        this.hideToolTip();
        toolTip_ = newToolTip;
        if (toolTip_ != null) {
            stage.addChild(toolTip_);
        }
    }

    private function hideToolTip():void {
        if (toolTip_ != null) {
            if (toolTip_.parent != null) {
                toolTip_.parent.removeChild(toolTip_);
            }
            toolTip_ = null;
        }
    }

    private function onRemovedFromStage(event:Event):void {
        this.hideToolTip();
    }

    private function onMouseOver(event:Event):void {
        var slot:TradeSlot = event.currentTarget as TradeSlot;
        this.showToolTip(new EquipmentToolTip(slot.item_, this.gs_.map_.player_, -1, ActorType.OTHER_PLAYER, slot.id, false, slot.data_));
    }

    private function onRollOut(event:Event):void {
        this.hideToolTip();
    }

    private function onSlotClick(event:MouseEvent):void {
        var slot:TradeSlot = event.currentTarget as TradeSlot;
        slot.setIncluded(!slot.included_);
        dispatchEvent(new Event(Event.CHANGE));
    }
}
}
