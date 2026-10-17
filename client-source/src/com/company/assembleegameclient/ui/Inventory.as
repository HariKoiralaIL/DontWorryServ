package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.GameObject;
import com.company.util.GraphicHelper;

import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Sprite;

/**
 * A grid of InventorySlots (4 per row) belonging to a game object: the
 * player's equipment / inventory, a loot bag, a vault chest, ...
 */
public class Inventory extends Sprite {

    private static const SLOTS_PER_ROW:int = 4;
    private static const SLOT_SPACING:int = 4;

    private static const NO_CORNERS:Array = [0, 0, 0, 0];

    /** Which corners of each slot are rounded, keyed by the number of slots in the grid. */
    private static const SLOT_CORNERS:Object = {
        "1": [[1, 1, 1, 1]],
        "2": [[1, 0, 0, 1], [0, 1, 1, 0]],
        "3": [[1, 0, 0, 1], NO_CORNERS, [0, 1, 1, 0]],
        "4": [[1, 0, 0, 1], NO_CORNERS, NO_CORNERS, [0, 1, 1, 0]],
        "5": [[1, 0, 0, 1], NO_CORNERS, NO_CORNERS, [0, 1, 1, 0], [0, 0, 1, 1]],
        "6": [[1, 0, 0, 1], NO_CORNERS, NO_CORNERS, [0, 1, 1, 0], [0, 0, 0, 1], [0, 0, 1, 0]],
        "7": [[1, 0, 0, 1], NO_CORNERS, NO_CORNERS, [0, 1, 1, 0], [0, 0, 0, 1], NO_CORNERS, [0, 0, 1, 0]],
        "8": [[1, 0, 0, 0], NO_CORNERS, NO_CORNERS, [0, 1, 0, 0], [0, 0, 0, 1], NO_CORNERS, NO_CORNERS, [0, 0, 1, 0]],
        "12": [[1, 0, 0, 1], NO_CORNERS, NO_CORNERS, [0, 1, 1, 0], [1, 0, 0, 0], NO_CORNERS, NO_CORNERS, [0, 1, 0, 0], [0, 0, 0, 1], NO_CORNERS, NO_CORNERS, [0, 0, 1, 0]]
    };

    public var gs_:GameSprite;
    /** The object whose items are shown (formerly _iA_). */
    public var owner_:GameObject;
    /** Inventory name such as "Inventory" or "Loot Bag" (formerly _A_H_). */
    public var name_:String;
    public var invsize_:int;
    public var slots_:Vector.<InventorySlot> = new Vector.<InventorySlot>();
    public var equipment_:Boolean;

    protected var fill_:GraphicsSolidFill = new GraphicsSolidFill(0x4C4C4C);
    protected var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
    private var graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[fill_, path_, GraphicHelper.END_FILL];

    /**
     * @param gs          game sprite (null for display-only inventories)
     * @param owner       object that owns the items (null for display-only inventories)
     * @param name        inventory name
     * @param slotTypes   slot type of every slot
     * @param invSize     number of slots to create
     * @param showHotkeys whether empty slots show their hotkey number
     * @param offset      index of the first slot within the owner's equipment array
     * @param equipment   true for the equipment row (draws a background plate)
     */
    public function Inventory(gs:GameSprite, owner:GameObject, name:String, slotTypes:Vector.<int>, invSize:int, showHotkeys:Boolean, offset:int = 0, equipment:Boolean = false) {
        super();
        this.gs_ = gs;
        this.owner_ = owner;
        this.name_ = name;
        this.invsize_ = invSize;
        this.equipment_ = equipment;
        if (gs && owner == this.gs_.map_.player_) {
            this.gs_.map_.player_.inventory = this;
        }
        for (var i:int = 0; i < invSize; i++) {
            var slotId:int = i + offset;
            var slot:InventorySlot = new InventorySlot(this, slotId, slotTypes[i], showHotkeys ? (slotId - 3) : -1, SLOT_CORNERS[slotTypes.length][i], equipment);
            slot.x = int(i % SLOTS_PER_ROW) * (Slot.WIDTH + SLOT_SPACING);
            slot.y = int(i / SLOTS_PER_ROW) * (Slot.HEIGHT + SLOT_SPACING);
            this.slots_.push(slot);
            addChild(slot);
        }
    }

    public function draw(items:Vector.<int>):void {
        if (this.equipment_) {
            GraphicHelper.clearPath(this.path_);
            GraphicHelper.drawUI(-3, -3, 178, 46, 6, [1, 1, 1, 1], this.path_);
            graphics.clear();
            graphics.drawGraphicsData(this.graphicsData_);
        }
        for (var i:int = 0; i < this.slots_.length; i++) {
            this.slots_[i].draw((items != null && i < items.length) ? items[i] : -1);
        }
    }

    public function refresh():void {
        for each (var slot:InventorySlot in this.slots_) {
            slot.refresh();
        }
    }

    public function useItem(slotIndex:int):void {
        if (slotIndex < 0 || slotIndex >= this.slots_.length) {
            return;
        }
        this.slots_[slotIndex].attemptUse();
    }

    /**
     * True when every non-equipment slot (4..19) of the player's inventory
     * holds an item. Always false for small inventories or without a game sprite.
     * Formerly _mK_.
     */
    public function isFull():Boolean {
        if (!this.gs_) {
            return false;
        }
        if (this.invsize_ < 20) {
            return false;
        }
        var full:Boolean = true;
        for (var i:uint = 4; i < 20; i++) {
            var slot:InventorySlot = this.gs_.map_.player_.inventory.slots_[i];
            if (slot.itemSprite_ == null) {
                full = false;
            }
        }
        return full;
    }
}
}
