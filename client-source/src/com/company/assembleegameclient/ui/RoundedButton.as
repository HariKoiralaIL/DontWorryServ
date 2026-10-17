package com.company.assembleegameclient.ui {
import com.company.ui.SimpleText;
import com.company.util.GraphicHelper;

import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.events.MouseEvent;

/**
 * White rounded-rectangle button with a dark label; highlights on hover and
 * turns grey when disabled.
 *
 * Formerly: _7f
 */
public class RoundedButton extends Sprite {

    private static const NORMAL_COLOR:uint = 0xFFFFFF;
    private static const HOVER_COLOR:uint = 0xFFDC85;
    private static const DISABLED_COLOR:uint = 0x7F7F7F;

    public var text_:SimpleText;
    public var w_:int;

    private var enabledFill_:GraphicsSolidFill = new GraphicsSolidFill(NORMAL_COLOR, 1);
    private var disabledFill_:GraphicsSolidFill = new GraphicsSolidFill(DISABLED_COLOR, 1);
    private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
    private var graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[enabledFill_, path_, GraphicHelper.END_FILL];

    /**
     * @param fontSize label font size
     * @param label    label text
     * @param width    fixed button width; 0 sizes the button to the label
     */
    public function RoundedButton(fontSize:int, label:String, width:int = 0) {
        super();
        this.text_ = new SimpleText(fontSize, 0x363636, false, 0, 0, "Myriad Pro");
        this.text_.setBold(true);
        this.text_.text = label;
        this.text_.updateMetrics();
        addChild(this.text_);
        this.w_ = (width != 0) ? width : (this.text_.width + 12);
        GraphicHelper.clearPath(this.path_);
        GraphicHelper.drawUI(0, 0, this.w_, this.text_.textHeight + 8, 4, [1, 1, 1, 1], this.path_);
        this.draw();
        this.centerText();
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
    }

    /** Formerly _02C_ */
    public function setText(label:String):void {
        this.text_.text = label;
        this.text_.updateMetrics();
        this.centerText();
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

    private function centerText():void {
        this.text_.x = (this.w_ / 2) - (this.text_.textWidth / 2) - 2;
        this.text_.y = 1;
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
