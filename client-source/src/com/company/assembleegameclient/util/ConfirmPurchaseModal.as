package com.company.assembleegameclient.util {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.SellableObject;
import com.company.assembleegameclient.ui._u5;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormatAlign;

import signals.Signal;
import signals.nativesignals.NativeSignal;

/** "Confirm Purchase" dialog shown before buying a SellableObject. */
public class ConfirmPurchaseModal extends Sprite {

    public static const WIDTH:int = 280;
    public static const HEIGHT:int = 185;
    public static var isClosed:Boolean = true;

    private static const PADDING:int = 20;
    private static const TEXT_WIDTH:int = (WIDTH - (PADDING * 2));
    private static const HEADER_HEIGHT:int = 30;
    private static const BUY_BUTTON_Y:int = 142;
    // Position of the modal's centre in the parent's coordinate space.
    private static const CENTER_X:int = -300;
    private static const CENTER_Y:int = -200;

    private const closeButton:CloseButton = ObjectLibrary.makeCornerWidget(ConfirmPurchaseModal.WIDTH);
    private const buyButton:_u5 = new _u5("Buy for ", 16, 0, Currency.INVALID);

    private var buyClickSignal:NativeSignal;
    private var sellable_:SellableObject;
    public var event:Signal;
    public var open:Boolean;
    public var buyButtonWidth:int;

    public var gs_:GameSprite;

    public function ConfirmPurchaseModal(event:Signal, sellable:SellableObject, buyButtonWidth:Number, gameSprite:GameSprite) {
        ConfirmPurchaseModal.isClosed = false;
        this.event = event;
        this.sellable_ = sellable;
        this.buyButtonWidth = buyButtonWidth;
        this.gs_ = gameSprite;
        this.bindEvents();
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        this.positionElements();
        this.addElements();
        this.buyButton.setPrice(this.sellable_.price_, this.sellable_.currency_);
        var itemName:String = this.sellable_.soldObjectName();
        addChild(this.createLabel("Confirm Purchase", PADDING, 5, 0x57AD62));
        addChild(this.createLabel("Are you sure that you want to buy this item?", PADDING, 40, 0xFFFFFF));
        addChild(this.createLabel(itemName, PADDING, 100, 0xFFFFFF));
        this.open = true;
    }

    private static function makeModalBackground(boxWidth:int, boxHeight:int):ModalBackground {
        var background:ModalBackground = new ModalBackground();
        background.draw(boxWidth, boxHeight);
        background.drawDivider(ModalBackground.HORIZONTAL_DIVISION, HEADER_HEIGHT);
        return background;
    }

    public function createLabel(text:String, x:int, y:int, color:uint):SimpleText {
        var label:SimpleText = new SimpleText(16, color, false, TEXT_WIDTH, TEXT_WIDTH, "Myriad Pro");
        label.text = text;
        label.setBold(true);
        label.wordWrap = true;
        label.multiline = true;
        label.autoSize = TextFieldAutoSize.CENTER;
        label.setAlign(TextFormatAlign.CENTER);
        label.filters = [new DropShadowFilter(0, 0, 0)];
        label.x = x;
        label.y = y;
        return label;
    }

    private function positionElements():void {
        this.x = (CENTER_X + ((-1 * ConfirmPurchaseModal.WIDTH) * 0.5));
        this.y = (CENTER_Y + ((-1 * ConfirmPurchaseModal.HEIGHT) * 0.5));
        this.buyButton.y = (this.buyButton.y + BUY_BUTTON_Y);
        this.buyButton.x = ((WIDTH / 2) - (this.buyButtonWidth / 2));
    }

    private function bindEvents():void {
        this.closeButton.event.add(this.onCloseClick);
        this.buyClickSignal = new NativeSignal(this.buyButton, MouseEvent.CLICK, MouseEvent);
        this.buyClickSignal.add(this.onBuyClick);
    }

    private function addElements():void {
        addChild(makeModalBackground(ConfirmPurchaseModal.WIDTH, ConfirmPurchaseModal.HEIGHT));
        addChild(this.closeButton);
        addChild(this.buyButton);
    }

    public function onCloseClick():void {
        this.close();
    }

    public function onBuyClick(e:MouseEvent):void {
        gs_.gsc_.buy(this.sellable_.objectId_);
        //this.event.dispatch(this.sellable_);
        this.close();
    }

    private function close():void {
        ConfirmPurchaseModal.isClosed = true;
        this.open = false;
        stage.focus = null;
        parent.removeChild(this);
    }

    private function onRemovedFromStage(e:Event):void {
        ConfirmPurchaseModal.isClosed = true;
        this.open = false;
    }

}
}
