package com.company.assembleegameclient.ui {
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.MouseEvent;

/**
 * Bold text label that changes colour on hover / press / selection.
 *
 * Formerly: _00A_
 */
public class SelectableLabel extends Sprite {

    private static const FONT_SIZE:int = 20;
    private static const HOVER_COLOR:uint = 0xFCCB19;
    private static const ACTIVE_COLOR:uint = 0xFFFFFF;
    private static const IDLE_COLOR:uint = 0xB2B2B2;

    public var label_:String;

    private var over_:Boolean = false;
    private var pressed_:Boolean = false;
    private var selected_:Boolean = false;
    private var text_:SimpleText;

    public function SelectableLabel(label:String) {
        super();
        this.label_ = label;
        this.text_ = new SimpleText(FONT_SIZE, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.text_.setBold(true);
        this.text_.text = label;
        this.text_.updateMetrics();
        this.text_.x = 2;
        addChild(this.text_);
        this.redraw();
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
        addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
    }

    public function setSelected(selected:Boolean):void {
        this.selected_ = selected;
        this.redraw();
    }

    private function redraw():void {
        if (this.over_) {
            this.text_.setColor(HOVER_COLOR);
        } else if (this.selected_ || this.pressed_) {
            this.text_.setColor(ACTIVE_COLOR);
        } else {
            this.text_.setColor(IDLE_COLOR);
        }
    }

    private function onMouseOver(event:MouseEvent):void {
        this.over_ = true;
        this.redraw();
    }

    private function onMouseOut(event:MouseEvent):void {
        this.over_ = false;
        this.pressed_ = false;
        this.redraw();
    }

    private function onMouseDown(event:MouseEvent):void {
        this.pressed_ = true;
        this.redraw();
    }

    private function onMouseUp(event:MouseEvent):void {
        this.pressed_ = false;
        this.redraw();
    }
}
}
