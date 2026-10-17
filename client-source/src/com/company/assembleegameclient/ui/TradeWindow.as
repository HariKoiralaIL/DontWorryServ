package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.net.messages.incoming.TradeStart;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

/**
 * Trade window: the local player's offer on top, the other player's offer
 * below it, and Cancel / Trade buttons.
 *
 * Formerly: _zg
 */
public class TradeWindow extends Sprite {

    public static const WIDTH:int = 200;
    public static const HEIGHT:int = 400;

    private static const BUTTON_WIDTH:int = 80;
    private static const BUTTON_FONT_SIZE:int = 16;

    public var gs_:GameSprite;

    private var myInventory_:TradeInventory;
    private var theirInventory_:TradeInventory;
    private var cancelButton_:RoundedButton;
    private var tradeButton_:TradeButton;

    public function TradeWindow(gs:GameSprite, tradeStart:TradeStart) {
        super();
        this.gs_ = gs;
        var myName:String = this.gs_.map_.player_.name_;
        this.myInventory_ = new TradeInventory(gs, myName, tradeStart.myItems_, true);
        this.myInventory_.x = 14;
        this.myInventory_.y = 0;
        this.myInventory_.addEventListener(Event.CHANGE, this.onMyOfferChanged);
        addChild(this.myInventory_);
        this.theirInventory_ = new TradeInventory(gs, tradeStart.yourName_, tradeStart.yourItems_, false);
        this.theirInventory_.x = 14;
        this.theirInventory_.y = 174;
        addChild(this.theirInventory_);
        this.cancelButton_ = new RoundedButton(BUTTON_FONT_SIZE, "Cancel", BUTTON_WIDTH);
        this.cancelButton_.addEventListener(MouseEvent.CLICK, this.onCancelClick);
        this.cancelButton_.x = (WIDTH / 4) - (this.cancelButton_.width / 2);
        this.cancelButton_.y = (HEIGHT - this.cancelButton_.height) - 10;
        addChild(this.cancelButton_);
        this.tradeButton_ = new TradeButton(BUTTON_FONT_SIZE, BUTTON_WIDTH);
        this.tradeButton_.addEventListener(MouseEvent.CLICK, this.onTradeClick);
        this.tradeButton_.x = ((3 * WIDTH) / 4) - (this.tradeButton_.width / 2);
        this.tradeButton_.y = (HEIGHT - this.tradeButton_.height) - 10;
        addChild(this.tradeButton_);
        this.updateTradeState();
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    /** The other player changed their offer; formerly _hf. */
    public function setTheirOffer(offer:Vector.<Boolean>):void {
        this.theirInventory_.setIncludedFlags(offer);
        this.updateTradeState();
    }

    /** The server reports an accepted trade; formerly _C_D_. */
    public function onTradeAccepted(myOffer:Vector.<Boolean>, theirOffer:Vector.<Boolean>):void {
        if (this.myInventory_.matchesIncludedFlags(myOffer) && this.theirInventory_.matchesIncludedFlags(theirOffer)) {
            this.theirInventory_.setState(TradeInventory.STATE_ACCEPTED);
        }
    }

    /**
     * Checks that both sides have enough free slots for what is being traded,
     * updates the status lines and enables / blocks the Trade button.
     * Formerly _55.
     */
    public function updateTradeState():void {
        var myIncluded:int = this.myInventory_.countIncluded();
        var myEmpty:int = this.myInventory_.countEmptySlots();
        var theirIncluded:int = this.theirInventory_.countIncluded();
        var theirEmpty:int = this.theirInventory_.countEmptySlots();
        var enoughSpace:Boolean = true;
        if ((theirIncluded - myIncluded - myEmpty) > 0) {
            this.myInventory_.setState(TradeInventory.STATE_NO_SPACE);
            enoughSpace = false;
        } else {
            this.myInventory_.setState(TradeInventory.STATE_CLICK_ITEMS);
        }
        if ((myIncluded - theirIncluded - theirEmpty) > 0) {
            this.theirInventory_.setState(TradeInventory.STATE_NO_SPACE);
            enoughSpace = false;
        } else {
            this.theirInventory_.setState(TradeInventory.STATE_PLAYER_SELECTING);
        }
        if (enoughSpace) {
            this.tradeButton_.reset();
        } else {
            this.tradeButton_.block();
        }
    }

    private function onAddedToStage(event:Event):void {
        stage.addEventListener(Event.ACTIVATE, this.onActivate);
    }

    private function onRemovedFromStage(event:Event):void {
        stage.removeEventListener(Event.ACTIVATE, this.onActivate);
    }

    private function onActivate(event:Event):void {
        this.tradeButton_.reset();
    }

    private function onMyOfferChanged(event:Event):void {
        this.gs_.gsc_.changeTrade(this.myInventory_.getIncludedFlags());
        this.updateTradeState();
    }

    private function onCancelClick(event:MouseEvent):void {
        this.gs_.gsc_.cancelTrade();
        dispatchEvent(new Event(Event.CANCEL));
    }

    private function onTradeClick(event:MouseEvent):void {
        this.gs_.gsc_.acceptTrade(this.myInventory_.getIncludedFlags(), this.theirInventory_.getIncludedFlags());
        this.myInventory_.setState(TradeInventory.STATE_ACCEPTED);
    }
}
}
