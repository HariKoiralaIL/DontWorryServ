package com.company.assembleegameclient.ui {
import audio.SoundEffects;

import client.ui.panels.ContainerPanel;

import com.company.assembleegameclient.map.GameMap;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.LootContainer;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.Player;
import com.company.ui.SimpleText;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;

/**
 * The item graphic shown in an InventorySlot. While it is being dragged it
 * lives on the stage; on mouse up it is dropped on another slot (swap), on the
 * world / chat (drop) or returned to its slot.
 *
 * Formerly: ui_items
 */
public class DraggableItem extends Sprite {

    private static const DOSE_TEXT_MATRIX:Matrix = createDoseTextMatrix();

    /** Minimum time between two swaps, in game-time milliseconds. */
    private static const SWAP_COOLDOWN:int = 500;

    private static var lastSwapTime_:int = -1000;

    private static function createDoseTextMatrix():Matrix {
        var matrix:Matrix = new Matrix();
        matrix.translate(10, 5);
        return matrix;
    }

    public var data_:Object;
    public var bitmap_:Bitmap;
    public var objectType_:int;
    /** The slot this item belongs to (formerly _03f). */
    public var slot_:InventorySlot;
    /** True while the item is being dragged (formerly _e). */
    public var dragging_:Boolean;

    public function DraggableItem(objectType:int, slot:InventorySlot, data:Object) {
        super();
        this.objectType_ = objectType;
        this.data_ = data;
        var itemXml:XML = ObjectLibrary.typeToXML_[objectType];
        var scale:Number = 5;
        if (itemXml.hasOwnProperty("ScaleValue")) {
            scale = itemXml.ScaleValue;
        }
        var texture:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.objectType_, 80, true, true, scale);
        if (this.data_ != null && this.data_.hasOwnProperty("TextureFile") && this.data_.TextureFile != "") {
            texture = ObjectLibrary.getRedrawnTextureFromTypeCustom(this.objectType_, 80, true, this.data_, true, scale);
        }
        if (itemXml.hasOwnProperty("Doses")) {
            texture = texture.clone();
            var doseText:SimpleText = new SimpleText(12, 0xFFFFFF, false, 0, 0, "Myriad Pro");
            doseText.text = String(itemXml.Doses);
            doseText.updateMetrics();
            texture.draw(doseText, DOSE_TEXT_MATRIX);
        }
        this.bitmap_ = new Bitmap(texture);
        this.bitmap_.x = -this.bitmap_.width / 2;
        this.bitmap_.y = -this.bitmap_.height / 2;
        addChild(this.bitmap_);
        this.slot_ = slot;
        addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
    }

    /** Dropped on a slot: validates the move and asks the server to swap. Formerly _08D_. */
    private function dropOnSlot(target:InventorySlot):void {
        if (target == null || !target.acceptsItemType(this.objectType_)) {
            this.returnToSlot();
            SoundEffects.play("error");
            return;
        }
        if (target == this.slot_) {
            this.returnToSlot();
            return;
        }
        var targetType:int = target.objectType_;
        if (targetType != -1 && !this.slot_.acceptsItemType(targetType)) {
            this.returnToSlot();
            SoundEffects.play("error");
            return;
        }
        if (targetType == this.objectType_) {
            this.returnToSlot();
            return;
        }
        if ((this.slot_.inventory_.gs_.lastUpdate_ - lastSwapTime_) < SWAP_COOLDOWN) {
            this.returnToSlot();
            return;
        }
        var player:Player = this.slot_.inventory_.gs_.map_.player_;
        if (player == null) {
            this.returnToSlot();
            return;
        }
        var targetOwner:GameObject = target.inventory_.owner_;
        if (targetOwner is Player && target.id_ < 4 && !ObjectLibrary.meetsEquipRequirements(this.objectType_, targetOwner as Player)) {
            this.returnToSlot();
            SoundEffects.play("error");
            return;
        }
        if (targetOwner is Player && this.slot_.id_ < 4 && targetType != -1 && !ObjectLibrary.checkLevelRequirement(targetType, targetOwner as Player)) {
            this.returnToSlot();
            SoundEffects.play("error");
            return;
        }
        if (targetOwner is Player && target.id_ < 4 && this.objectType_ != -1 && !ObjectLibrary.checkLevelRequirement(this.objectType_, targetOwner as Player)) {
            this.returnToSlot();
            SoundEffects.play("error");
            return;
        }
        lastSwapTime_ = this.slot_.inventory_.gs_.lastUpdate_;
        this.slot_.inventory_.gs_.gsc_.invSwap(player, this.slot_.inventory_.owner_, this.slot_.id_, this.slot_.objectType_, targetOwner, target.id_, target.objectType_);
    }

    /** Dropped on the world or chat: drop the item (or put it into the open container). Formerly _Y_4. */
    private function dropOnWorld():void {
        var player:Player = this.slot_.inventory_.gs_.map_.player_;
        var owner:GameObject = this.slot_.inventory_.owner_;
        var lootContainer:LootContainer = owner as LootContainer;
        var soulbound:Boolean = ObjectLibrary.isSoulbound(this.objectType_);
        if (owner != player && (lootContainer == null || lootContainer.ownerId_ != player.accountId_ || soulbound)) {
            this.returnToSlot();
            SoundEffects.play("error");
            return;
        }
        var interactPanel:* = this.slot_.inventory_.gs_.hudView_.interactPanel_;
        var currentContainer:LootContainer = interactPanel.currentInteractive as LootContainer;
        if (currentContainer != null && ((currentContainer.isOwnedByPlayer() && soulbound) || (currentContainer.ownerId_ == -1 && !soulbound))) {
            var containerPanel:ContainerPanel = interactPanel.currentPanel as ContainerPanel;
            if (containerPanel != null && containerPanel.inventory != null) {
                for each (var containerSlot:InventorySlot in containerPanel.inventory.slots_) {
                    if (containerSlot.objectType_ == -1) {
                        this.dropOnSlot(containerSlot);
                        return;
                    }
                }
            }
        }
        this.slot_.inventory_.gs_.gsc_.invDrop(this.slot_.inventory_.owner_.objectId_, this.slot_.id_, this.objectType_);
    }

    /** Puts the item back into its slot. Formerly _0K_9. */
    private function returnToSlot():void {
        this.slot_.addChild(this);
        this.slot_.redrawItem();
    }

    /** Formerly _0_5 */
    public function onMouseUp(event:Event):void {
        if (!this.dragging_) {
            return;
        }
        stopDrag();
        this.dragging_ = false;
        var target:DisplayObject = dropTarget;
        while (target != null) {
            if (target is InventorySlot) {
                this.dropOnSlot(target as InventorySlot);
                return;
            }
            if (target is GameMap || target is Chat) {
                this.dropOnWorld();
                return;
            }
            target = target.parent;
        }
        this.returnToSlot();
        SoundEffects.play("error");
    }
}
}
