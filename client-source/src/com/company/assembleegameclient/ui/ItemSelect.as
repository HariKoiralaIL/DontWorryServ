package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.net.messages.incoming.ItemSelectStart;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

/**
 * Window that lets the player pick one item from their inventory (e.g. for a
 * server-driven "select an item" action) with Cancel / Select buttons.
 */
public class ItemSelect extends Sprite {

    public static const WIDTH:int = 200;
    public static const HEIGHT:int = 400;

    private static const BUTTON_WIDTH:int = 80;
    private static const BUTTON_FONT_SIZE:int = 16;

    public var gs_:GameSprite;

    private var inventory_:ItemSelectInventory;
    private var cancelButton_:RoundedButton;
    private var selectButton_:RoundedButton;

    public function ItemSelect(gs:GameSprite, itemSelectStart:ItemSelectStart) {
        super();
        this.gs_ = gs;
        this.inventory_ = new ItemSelectInventory(gs, "", itemSelectStart.myItems_, true);
        this.inventory_.x = 14;
        this.inventory_.addEventListener(Event.CHANGE, this.onSelectionChanged);
        addChild(this.inventory_);
        var buttonY:Number = this.inventory_.y + this.inventory_.height + 5;
        this.cancelButton_ = new RoundedButton(BUTTON_FONT_SIZE, "Cancel", BUTTON_WIDTH);
        this.cancelButton_.addEventListener(MouseEvent.CLICK, this.onCancelClick);
        this.cancelButton_.x = (WIDTH / 4) - (this.cancelButton_.width / 2);
        this.cancelButton_.y = buttonY;
        addChild(this.cancelButton_);
        this.selectButton_ = new RoundedButton(BUTTON_FONT_SIZE, "Select", BUTTON_WIDTH);
        this.selectButton_.setEnabled(false);
        this.selectButton_.addEventListener(MouseEvent.CLICK, this.onSelectClick);
        this.selectButton_.x = ((3 * WIDTH) / 4) - (this.selectButton_.width / 2);
        this.selectButton_.y = buttonY;
        addChild(this.selectButton_);
    }

    private function onSelectionChanged(event:Event):void {
        this.selectButton_.setEnabled(this.inventory_.selected_ != null);
    }

    private function onCancelClick(event:MouseEvent):void {
        dispatchEvent(new Event(Event.CANCEL));
    }

    private function onSelectClick(event:MouseEvent):void {
        this.gs_.gsc_.selectItem(this.inventory_.getSelectedId());
    }
}
}
