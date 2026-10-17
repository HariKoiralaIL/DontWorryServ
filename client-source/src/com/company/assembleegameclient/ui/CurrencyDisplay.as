package com.company.assembleegameclient.ui {
import account.Account;

import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.FameUtil;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

/**
 * Gold and fame counters with their icons. Double-clicking opens the money
 * management screen (only in safe maps unless the "clickForGold" option is on).
 *
 * Formerly: ui_goldcoin
 */
public class CurrencyDisplay extends Sprite {

    private static const FONT_SIZE:int = 18;
    private static const GOLD_ICON_INDEX:int = 225;

    private var goldText_:SimpleText;
    private var fameText_:SimpleText;
    private var goldIcon_:Bitmap;
    private var fameIcon_:Bitmap;
    private var credits_:int = -1;
    private var fame_:int = -1;
    private var gameSprite_:GameSprite;

    public function CurrencyDisplay(gameSprite:GameSprite = null) {
        super();
        this.gameSprite_ = gameSprite;
        this.goldText_ = new SimpleText(FONT_SIZE, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.goldText_.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        addChild(this.goldText_);
        var goldImage:BitmapData = AssetLibrary.getImageFromSet("lofiObj3", GOLD_ICON_INDEX);
        goldImage = TextureRedrawer.redraw(goldImage, 40, true, 0, 0);
        this.goldIcon_ = new Bitmap(goldImage);
        addChild(this.goldIcon_);
        this.fameText_ = new SimpleText(FONT_SIZE, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.fameText_.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        addChild(this.fameText_);
        this.fameIcon_ = new Bitmap(FameUtil.getFameIcon());
        addChild(this.fameIcon_);
        this.draw(0, 0);
        mouseEnabled = true;
        doubleClickEnabled = true;
        addEventListener(MouseEvent.DOUBLE_CLICK, this.onDoubleClick, false, 0, true);
    }

    public function draw(credits:int, fame:int):void {
        if (credits == this.credits_ && fame == this.fame_) {
            return;
        }
        this.credits_ = credits;
        this.fame_ = fame;
        this.goldIcon_.x = -this.goldIcon_.width;
        this.goldText_.text = this.credits_.toString();
        this.goldText_.updateMetrics();
        this.goldText_.x = (this.goldIcon_.x - this.goldText_.width) + 8;
        this.goldText_.y = (this.goldIcon_.height / 2) - (this.goldText_.height / 2);
        this.fameIcon_.x = this.goldText_.x - this.fameIcon_.width;
        this.fameText_.text = this.fame_.toString();
        this.fameText_.updateMetrics();
        this.fameText_.x = (this.fameIcon_.x - this.fameText_.width) + 8;
        this.fameText_.y = (this.fameIcon_.height / 2) - (this.fameText_.height / 2);
    }

    private function onDoubleClick(event:MouseEvent):void {
        if (!this.gameSprite_ || this.gameSprite_.isSafeMap() || Parameters.data_.clickForGold == true) {
            Account.getInstance().showMoneyManagement(stage);
        }
    }
}
}
