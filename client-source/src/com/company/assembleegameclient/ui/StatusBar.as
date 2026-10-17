package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.ui.SimpleText;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import signals.Signal;

/**
 * Horizontal value bar (HP, MP, level / fame experience). Optionally shows its
 * value as text (always, or on hover), a boost suffix like " (+10)", an "xN"
 * multiplier badge, and can flash a highlight colour.
 *
 * Formerly: _0M_Y_
 */
public class StatusBar extends Sprite {

    /** Dispatched with true when bar text should always be visible (no hover needed). */
    public static var options_:Signal = new Signal(Boolean);

    private static const FONT:String = "CHIP SBKI";
    private static const FLASH_SPEED:Number = 0.1;
    private static const MAXED_TEXT_COLOR:uint = 0xFCDF00;
    private static const BOOSTED_TEXT_COLOR:uint = 0x5EB531;
    private static const MULTIPLIER_COLOR:uint = 0x90DC1B;

    private static const NUMBER_SUFFIXES:Array = ["K", "M", "B", "T"];

    /** Formerly NumberFormat: 12345 -> "12.35K". */
    private static function formatNumber(number:int):String {
        var size:int = (number != 0) ? logx(number) : 0;
        if (size >= 3) {
            while (size % 3 != 0) {
                size = size - 1;
            }
        }
        var divisor:Number = Math.pow(10, size);
        if (size >= 3) {
            return (Math.round((number / divisor) * 100) / 100.0) + NUMBER_SUFFIXES[(size / 3) - 1];
        }
        return number.toString();
    }

    public static function logx(value:Number, base:Number = 10):Number {
        return Math.log(value) / Math.log(base);
    }

    public var w_:int;
    public var h_:int;
    public var color_:uint;
    /** Background colour (formerly _F_h). */
    public var backColor_:uint;
    /** Background colour while flashing (formerly _R_V_). */
    public var flashBackColor_:uint;
    /** Current colour of the value text (formerly _native). */
    public var textColor_:uint;
    public var val_:int = -1;
    /** Maximum value (formerly _05E_). */
    public var max_:int = -1;
    public var boost_:int = -1;
    /** Maximum possible value including boosts (formerly _w1). */
    public var maxMax_:int = -1;
    public var labelText_:SimpleText;
    /** Value text, e.g. "120/200" (formerly _08m). */
    public var valueText_:SimpleText;
    /** Boost suffix text, e.g. " (+10)" (formerly _0M_M_). */
    public var boostText_:SimpleText;
    /** "xN" multiplier badge (formerly _5B_). */
    public var multiplierText_:SimpleText;
    /** Mouse is over the bar (formerly _68). */
    public var mouseOver_:Boolean = false;

    /** The coloured part of the bar (formerly _03o). */
    private var fillBar_:Sprite = new Sprite();
    private var defaultColor_:uint;
    private var defaultBackColor_:uint;
    private var flashing_:Boolean = false;
    private var flashCount_:int;
    private var flashDirection_:int = -1;
    private var cornerTL_:Bitmap = new Bitmap(new StatusBarCornerTL());
    private var cornerBR_:Bitmap = new Bitmap(new StatusBarCornerBR());

    public function StatusBar(width:int, height:int, color:uint, backColor:uint, label:String = null) {
        super();
        addChild(this.fillBar_);
        addChild(this.cornerTL_);
        addChild(this.cornerBR_);
        this.w_ = width;
        this.h_ = height;
        this.defaultColor_ = this.color_ = color;
        this.defaultBackColor_ = this.backColor_ = backColor;
        this.textColor_ = 0xFFFFFF;
        if (label != null && label.length != 0) {
            this.labelText_ = new SimpleText(14, this.textColor_, false, 0, 0, FONT);
            this.labelText_.setBold(true);
            this.labelText_.text = label;
            this.labelText_.updateMetrics();
            this.labelText_.y = -2;
            this.labelText_.filters = [new DropShadowFilter(0, 0, 0)];
            this.labelText_.x = 4;
            addChild(this.labelText_);
        }
        this.valueText_ = new SimpleText(13, 0xFFFFFF, false, 0, 0, FONT);
        this.valueText_.setBold(true);
        this.valueText_.filters = [new DropShadowFilter(0, 0, 0)];
        this.valueText_.y = -1;
        this.boostText_ = new SimpleText(13, this.textColor_, false, 0, 0, FONT);
        this.boostText_.setBold(true);
        this.boostText_.alpha = 0.6;
        this.boostText_.y = -1;
        this.boostText_.filters = [new DropShadowFilter(0, 0, 0)];
        this.multiplierText_ = new SimpleText(15, MULTIPLIER_COLOR, false, 0, 0, FONT);
        this.multiplierText_.setBold(true);
        this.multiplierText_.x = this.w_ - 25;
        this.multiplierText_.y = -1;
        this.multiplierText_.text = "x2";
        this.multiplierText_.filters = [new DropShadowFilter(0, 0, 0)];
        this.cornerTL_.y = 0;
        this.cornerTL_.x = 0;
        this.cornerBR_.y = 0;
        this.cornerBR_.x = this.w_ - this.cornerBR_.width;
        if (!Parameters.data_.toggleBarText) {
            addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        }
        options_.add(this.onOptionsChanged);
    }

    public function draw(value:int, max:int, boost:int, maxMax:int = -1):void {
        if (max > 0) {
            value = Math.min(max, Math.max(0, value));
        }
        if (value == this.val_ && max == this.max_ && boost == this.boost_ && maxMax == this.maxMax_) {
            return;
        }
        this.val_ = value;
        this.max_ = max;
        this.boost_ = boost;
        this.maxMax_ = maxMax;
        this.redraw();
    }

    /** Shows / hides the "xN" badge; showing it also starts a flash. Formerly _Y_r. */
    public function setMultiplier(show:Boolean, multiplier:int):void {
        if (show) {
            if (this.multiplierText_.text != ("x" + multiplier).toString()) {
                this.multiplierText_.text = "x" + multiplier;
            }
            addChild(this.multiplierText_);
            this.startFlash(3, MULTIPLIER_COLOR, 0xFFFFFF);
        } else {
            if (this.multiplierText_.parent) {
                removeChild(this.multiplierText_);
            }
        }
    }

    /** Pulses the bar with the given colours the given number of times. Formerly _W_K_. */
    public function startFlash(count:int, color:uint, backColor:uint):void {
        this.flashing_ = true;
        this.color_ = color;
        this.flashBackColor_ = backColor;
        this.flashCount_ = count;
        this.redraw();
        addEventListener(Event.ENTER_FRAME, this.onFlashFrame);
    }

    /** Formerly _S_H_ */
    private function setTextColor(color:uint):void {
        this.textColor_ = color;
        if (this.boostText_ != null) {
            this.boostText_.setColor(this.textColor_);
        }
        this.valueText_.setColor(this.textColor_);
    }

    /** Formerly _0E_J_ */
    private function redraw():void {
        graphics.clear();
        this.fillBar_.graphics.clear();
        var textColor:uint = 0xFFFFFF;
        if (this.maxMax_ > 0 && (this.max_ - this.boost_) == this.maxMax_) {
            textColor = MAXED_TEXT_COLOR;
        } else if (this.boost_ > 0) {
            textColor = BOOSTED_TEXT_COLOR;
        }
        if (this.textColor_ != textColor) {
            this.setTextColor(textColor);
        }
        graphics.beginFill(this.backColor_);
        graphics.drawRect(0, 0, this.w_, this.h_);
        graphics.endFill();
        if (this.flashing_) {
            this.fillBar_.graphics.beginFill(this.flashBackColor_);
            this.fillBar_.graphics.drawRect(0, 0, this.w_, this.h_);
        }
        this.fillBar_.graphics.beginFill(this.color_);
        if (this.max_ > 0) {
            this.fillBar_.graphics.drawRect(0, 0, this.w_ * (this.val_ / this.max_), this.h_);
        } else {
            this.fillBar_.graphics.drawRect(0, 0, this.w_, this.h_);
        }
        this.fillBar_.graphics.endFill();
        if (Parameters.data_.toggleBarText || (this.mouseOver_ && this.h_ > 4)) {
            if (this.max_ > 0) {
                if (Parameters.data_.togglePercentage) {
                    this.valueText_.text = Math.round((this.val_ / this.max_) * 100) + "% (" + formatNumber(this.val_) + ")";
                } else {
                    this.valueText_.text = formatNumber(this.val_) + "/" + formatNumber(this.max_);
                }
            } else {
                this.valueText_.text = "" + this.val_;
            }
            this.valueText_.updateMetrics();
            if (!contains(this.valueText_)) {
                addChild(this.valueText_);
            }
            if (this.boost_ != 0 && !Parameters.data_.togglePercentage) {
                this.boostText_.text = " (" + ((this.boost_ > 0) ? "+" : "") + this.boost_.toString() + ")";
                this.boostText_.updateMetrics();
                this.valueText_.x = (this.w_ / 2) - ((this.valueText_.width + this.boostText_.width) / 2);
                this.boostText_.x = this.valueText_.x + this.valueText_.width;
                if (!contains(this.boostText_)) {
                    addChild(this.boostText_);
                }
            } else {
                this.valueText_.x = (this.w_ / 2) - (this.valueText_.width / 2);
                if (contains(this.boostText_)) {
                    removeChild(this.boostText_);
                }
            }
        } else {
            if (contains(this.valueText_)) {
                removeChild(this.valueText_);
            }
            if (contains(this.boostText_)) {
                removeChild(this.boostText_);
            }
        }
    }

    /** Called when the "always show bar text" option changes. Formerly extraMouseHandler. */
    private function onOptionsChanged(alwaysShowText:Boolean):void {
        this.mouseOver_ = false;
        if (alwaysShowText) {
            removeEventListener(MouseEvent.ROLL_OVER, this.onMouseOver);
            removeEventListener(MouseEvent.ROLL_OUT, this.onMouseOut);
        } else {
            addEventListener(MouseEvent.ROLL_OVER, this.onMouseOver);
            addEventListener(MouseEvent.ROLL_OUT, this.onMouseOut);
        }
        this.redraw();
    }

    /** Fades the bar in and out while flashing. Formerly _0F__. */
    private function onFlashFrame(event:Event):void {
        if (this.fillBar_.alpha > 1 || this.fillBar_.alpha < 0) {
            this.flashDirection_ = this.flashDirection_ * -1;
            if (this.fillBar_.alpha > 1) {
                this.flashCount_--;
                if (!this.flashCount_) {
                    this.flashing_ = false;
                    this.color_ = this.defaultColor_;
                    this.backColor_ = this.defaultBackColor_;
                    this.fillBar_.alpha = 1;
                    this.redraw();
                    removeEventListener(Event.ENTER_FRAME, this.onFlashFrame);
                }
            }
        }
        this.fillBar_.alpha = this.fillBar_.alpha + (FLASH_SPEED * this.flashDirection_);
    }

    private function onMouseOver(event:MouseEvent):void {
        this.mouseOver_ = true;
        this.redraw();
    }

    private function onMouseOut(event:MouseEvent):void {
        this.mouseOver_ = false;
        this.redraw();
    }
}
}
