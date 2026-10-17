package com.company.assembleegameclient.ui {
import audio.SoundEffects;

import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

/**
 * Plain text link: white text that turns yellow on hover and plays a click sound.
 *
 * Formerly: _jM_
 */
public class TextButton extends Sprite {

    private static const HOVER_COLOR:uint = 0xFFDC85;
    private static const DISABLED_COLOR:uint = 0xB3B3B3;

    public var text_:SimpleText;
    /** Colour while the mouse is not over the button (formerly _S_4). */
    public var normalColor_:uint = 0xFFFFFF;
    /** Colour used instead of normalColor_ after mouse-out when dimmed (formerly _G3_). */
    public var dimmedColor_:uint = DISABLED_COLOR;

    /** Use dimmedColor_ instead of normalColor_ when the mouse leaves (formerly _g4_). */
    private var dimmed_:Boolean = false;

    /**
     * @param fontSize font size
     * @param bold     bold text
     * @param label    button text
     * @param dimmed   show the button in the dimmed colour when not hovered
     */
    public function TextButton(fontSize:int, bold:Boolean, label:String, dimmed:Boolean = false) {
        super();
        this.text_ = new SimpleText(fontSize, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.text_.setBold(bold);
        this.text_.text = label;
        this.text_.updateMetrics();
        addChild(this.text_);
        this.text_.filters = [new DropShadowFilter(0, 0, 0)];
        this.dimmed_ = dimmed;
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        addEventListener(MouseEvent.CLICK, this.onClick);
    }

    /** Replaces the text and turns the button into a grey, non-interactive label. Formerly _bu. */
    public function setTextDisabled(label:String):void {
        this.text_.text = label;
        this.text_.updateMetrics();
        this.setNormalColor(DISABLED_COLOR);
        mouseEnabled = false;
        mouseChildren = false;
    }

    /** Formerly _gp */
    public function setTextColor(color:uint):void {
        this.text_.setColor(color);
    }

    /** Formerly _02W_ */
    public function setNormalColor(color:uint):void {
        this.normalColor_ = color;
        this.setTextColor(this.normalColor_);
    }

    private function onMouseOver(event:MouseEvent):void {
        this.setTextColor(HOVER_COLOR);
    }

    private function onMouseOut(event:MouseEvent):void {
        if (this.dimmed_) {
            this.setTextColor(this.dimmedColor_);
        } else {
            this.setTextColor(this.normalColor_);
        }
    }

    private function onClick(event:MouseEvent):void {
        SoundEffects.play("button_click");
    }
}
}
