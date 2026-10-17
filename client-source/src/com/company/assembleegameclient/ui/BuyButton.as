package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.util.Currency;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;
import com.company.util.GraphicHelper;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.events.MouseEvent;

/**
 * Rounded button that shows "<prefix><price>" followed by a currency icon
 * (or "Free" when the price is 0).
 *
 * Formerly: _u5
 */
public class BuyButton extends Sprite {

    private static const ICON_SET:String = "lofiObj3";
    private static const ICON_SIZE:int = 40;
    private static const GOLD_ICON_INDEX:int = 225;
    private static const FAME_ICON_INDEX:int = 224;
    private static const GUILD_FAME_ICON_INDEX:int = 226;
    private static const KEY_ICON_INDEX:int = 182;

    private static const NORMAL_COLOR:uint = 0xFFFFFF;
    private static const HOVER_COLOR:uint = 0xFFDC85;
    private static const DISABLED_COLOR:uint = 0x7F7F7F;

    private static var goldIcon_:BitmapData = null;
    private static var fameIcon_:BitmapData = null;
    private static var guildFameIcon_:BitmapData = null;
    private static var keyIcon_:BitmapData = null;

    private static function createIcon(index:int):BitmapData {
        var icon:BitmapData = TextureRedrawer.resize(AssetLibrary.getImageFromSet(ICON_SET, index), null, ICON_SIZE, true, 0, 0);
        return TextureRedrawer.outlineGlow(icon, 0, 0xFFFFFFFF);
    }

    /** Formerly _I_H_ */
    public static function getGoldIcon():BitmapData {
        if (goldIcon_ == null) {
            goldIcon_ = createIcon(GOLD_ICON_INDEX);
        }
        return goldIcon_;
    }

    /** Formerly fame */
    public static function getFameIcon():BitmapData {
        if (fameIcon_ == null) {
            fameIcon_ = createIcon(FAME_ICON_INDEX);
        }
        return fameIcon_;
    }

    /** Formerly key */
    public static function getKeyIcon():BitmapData {
        if (keyIcon_ == null) {
            keyIcon_ = createIcon(KEY_ICON_INDEX);
        }
        return keyIcon_;
    }

    /** Formerly _0M_s */
    public static function getGuildFameIcon():BitmapData {
        if (guildFameIcon_ == null) {
            guildFameIcon_ = createIcon(GUILD_FAME_ICON_INDEX);
        }
        return guildFameIcon_;
    }

    public var prefix_:String;
    public var text_:SimpleText;
    public var icon_:Bitmap;
    public var price_:int = -1;
    public var currency_:int = -1;
    public var w_:int;

    private var enabledFill_:GraphicsSolidFill = new GraphicsSolidFill(NORMAL_COLOR, 1);
    private var disabledFill_:GraphicsSolidFill = new GraphicsSolidFill(DISABLED_COLOR, 1);
    private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
    private var graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[enabledFill_, path_, GraphicHelper.END_FILL];

    public function BuyButton(prefix:String, fontSize:int, price:int, currency:int) {
        super();
        this.prefix_ = prefix;
        this.text_ = new SimpleText(fontSize, 0x363636, false, 0, 0, "Myriad Pro");
        this.text_.setBold(true);
        addChild(this.text_);
        this.icon_ = new Bitmap();
        addChild(this.icon_);
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
        this.setPrice(price, currency);
    }

    public function setPrice(price:int, currency:int):void {
        if (this.price_ == price && this.currency_ == currency) {
            return;
        }
        this.price_ = price;
        this.currency_ = currency;
        if (price != 0) {
            this.text_.text = this.prefix_ + price;
            this.text_.updateMetrics();
            switch (currency) {
                case Currency.GOLD:
                    this.icon_.bitmapData = getGoldIcon();
                    break;
                case Currency.FAME:
                    this.icon_.bitmapData = getFameIcon();
                    break;
                case Currency.GUILD_FAME:
                    this.icon_.bitmapData = getGuildFameIcon();
                    break;
                case Currency.KEYS:
                    this.icon_.bitmapData = getKeyIcon();
                    break;
                default:
                    this.icon_.bitmapData = null;
            }
        } else {
            this.text_.text = this.prefix_ + "Free";
            this.text_.updateMetrics();
        }
        this.icon_.x = this.text_.width - 3;
        this.icon_.y = -7;
        this.text_.x = ((this.text_.width + 12) / 2) - (this.text_.textWidth / 2) - 2;
        this.text_.y = 1;
        if (this.icon_.bitmapData != null) {
            this.w_ = this.text_.width + this.icon_.width - 6;
        } else {
            this.w_ = this.text_.textWidth + 16;
        }
        GraphicHelper.clearPath(this.path_);
        GraphicHelper.drawUI(0, 0, this.w_, this.text_.textHeight + 8, 4, [1, 1, 1, 1], this.path_);
        this.draw();
    }

    /** Formerly _A_w */
    public function setEnabled(enabled:Boolean):void {
        if (enabled == mouseEnabled) {
            return;
        }
        mouseEnabled = enabled;
        this.graphicsData_[0] = enabled ? this.enabledFill_ : this.disabledFill_;
        this.draw();
    }

    private function draw():void {
        graphics.clear();
        graphics.drawGraphicsData(this.graphicsData_);
    }

    private function onMouseOver(event:MouseEvent):void {
        this.enabledFill_.color = HOVER_COLOR;
        this.draw();
    }

    private function onRollOut(event:MouseEvent):void {
        this.enabledFill_.color = NORMAL_COLOR;
        this.draw();
    }
}
}
