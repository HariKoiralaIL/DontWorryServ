// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.ui.frames.GoldOfferItem

package client.ui.frames {
import flash.display.Sprite;

import client.ui.controls.ISelectableItem;

import com.company.assembleegameclient.util.offer.Offer;

import client.ui.controls.ColorRectangle;
import client.ui.controls.CheckBoxIcon;

import flash.display.BitmapData;

import com.company.ui.SimpleText;

import flash.events.MouseEvent;
import flash.display.Bitmap;

import com.company.util.AssetLibrary;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.BitmapUtil;

import flash.filters.DropShadowFilter;

public class GoldOfferItem extends Sprite implements ISelectableItem {

    private static const COLOR_SELECTED:int = 0x721100;
    private static const COLOR_HOVER:int = 0x4C0C00;
    private static const COLOR_DEFAULT:int = 0x340800;

    public function GoldOfferItem(_arg1:Offer, _arg2:String, _arg3:String) {
        this.offer = _arg1;
        this.currencyPrefix = _arg2;
        this.currencySuffix = _arg3;
        this.createBackground();
        this.createContainer();
        this.createCheckBox();
        this.createIcon();
        this.createGoldText();
        this.createPriceText();
        this.createBonusText();
        this.createTagline();
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
    }
    public var offer:Offer;
    public var currencyPrefix:String;
    public var currencySuffix:String;
    private var background:ColorRectangle;
    private var container:Sprite;
    private var checkBox:CheckBoxIcon;
    private var iconData:BitmapData;
    private var goldText:SimpleText;
    private var priceText:SimpleText;
    private var bonusText:SimpleText;
    private var taglineText:SimpleText;
    private var selected:Boolean;
    private var hovered:Boolean;

    public function getValue():String {
        return (this.offer.realmGold_.toString());
    }

    public function setHovered(_arg1:Boolean):void {
        this.hovered = _arg1;
        this.updateBackground();
    }

    public function setSelected(_arg1:Boolean):void {
        this.selected = _arg1;
        this.checkBox.setSelected(_arg1);
        this.updateBackground();
    }

    public function showBonus(_arg1:Boolean):void {
        if (this.bonusText) {
            this.bonusText.visible = _arg1;
        }
    }

    private function createBackground():void {
        this.background = new ColorRectangle();
        this.background.setSize(520, 36);
        this.updateBackground();
        addChild(this.background);
    }

    private function createContainer():void {
        this.container = new Sprite();
        this.container.x = (this.container.y = 3);
        addChild(this.container);
    }

    private function createCheckBox():void {
        this.checkBox = new CheckBoxIcon();
        this.checkBox.x = 3;
        this.container.addChild(this.checkBox);
    }

    private function createIcon():void {
        var _local1:Bitmap;
        this.iconData = AssetLibrary._xK_("lofiObj3", 225);
        this.iconData = TextureRedrawer.redraw(this.iconData, 50, true, 0, 0, false);
        this.iconData = BitmapUtil._Y_d(this.iconData, 8, 8, (this.iconData.width - 16), (this.iconData.height - 16));
        _local1 = new Bitmap(this.iconData);
        _local1.x = (this.checkBox.x + 35);
        this.container.addChild(_local1);
    }

    private function createGoldText():void {
        this.goldText = new SimpleText(18, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.goldText.text = (this.offer.realmGold_ + " Gold");
        this.goldText.setBold(true);
        this.goldText.updateMetrics();
        this.goldText.x = (this.checkBox.x + 70);
        this.goldText.y = ((this.iconData.height / 2) - (this.goldText.height / 2));
        this.goldText.filters = [new DropShadowFilter(0, 0, 0)];
        this.container.addChild(this.goldText);
    }

    private function createPriceText():void {
        this.priceText = new SimpleText(18, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.priceText.text = ((this.currencyPrefix + this.offer.price_) + this.currencySuffix);
        this.priceText.setBold(true);
        this.priceText.updateMetrics();
        this.priceText.x = 200;
        this.priceText.y = ((this.iconData.height / 2) - (this.priceText.height / 2));
        this.priceText.filters = [new DropShadowFilter(0, 0, 0)];
        this.container.addChild(this.priceText);
    }

    private function createBonusText():void {
        if (this.offer.bonus == 0) {
            return;
        }
        this.bonusText = new SimpleText(18, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.bonusText.text = (this.offer.bonus + "% Bonus");
        this.bonusText.setBold(true);
        this.bonusText.updateMetrics();
        this.bonusText.x = 280;
        this.bonusText.y = ((this.iconData.height / 2) - (this.bonusText.height / 2));
        this.bonusText.filters = [new DropShadowFilter(0, 0, 0)];
        this.container.addChild(this.bonusText);
    }

    private function createTagline():void {
        if (this.offer.tagline != null) {
            this.makeTaglineText();
        }
    }

    private function makeTaglineText():void {
        this.taglineText = new SimpleText(18, 8891485, false, 0, 0, "Myriad Pro");
        this.taglineText.text = this.offer.tagline;
        this.taglineText.updateMetrics();
        this.taglineText.x = 400;
        this.taglineText.y = ((this.iconData.height / 2) - (this.taglineText.height / 2));
        this.taglineText.filters = [new DropShadowFilter(0, 0, 0)];
        this.container.addChild(this.taglineText);
    }

    private function updateBackground():void {
        var _local1:int = ((this.selected) ? COLOR_SELECTED : ((this.hovered) ? COLOR_HOVER : COLOR_DEFAULT));
        this.background.setColor(_local1);
    }

    private function onMouseOver(_arg1:MouseEvent):void {
        this.setHovered(true);
    }

    private function onRollOut(_arg1:MouseEvent):void {
        this.setHovered(false);
    }

}
}//package client.ui.frames

