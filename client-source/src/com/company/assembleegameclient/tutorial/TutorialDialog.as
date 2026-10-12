package com.company.assembleegameclient.tutorial {
import com.company.assembleegameclient.ui._7f;
import com.company.ui.SimpleText;
import com.company.util.GraphicHelper;

import flash.display.CapsStyle;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.utils.getTimer;

/** Tutorial text box that animates open, then shows its text and an optional "Next" button. */
public class TutorialDialog extends Sprite {

    public static const BORDER:int = 8;

    private static const OPEN_DURATION_MS:int = 200;
    private static const MIN_OPEN_SCALE:Number = 0.1;

    private var graphicsData_:Vector.<IGraphicsData>;
    private var tutorial_:Tutorial;
    private var rect_:Rectangle;
    private var text_:SimpleText;
    private var nextButton_:_7f = null;
    private var startTime_:int;
    private var fill_:GraphicsSolidFill;
    private var stroke_:GraphicsStroke;
    private var path_:GraphicsPath;

    public function TutorialDialog(tutorial:Tutorial, message:String, showNextButton:Boolean, bounds:Rectangle) {
        this.fill_ = new GraphicsSolidFill(0x2A2A2A, 1);
        this.stroke_ = new GraphicsStroke(1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, new GraphicsSolidFill(0xFFFFFF));
        this.path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        this.graphicsData_ = new <IGraphicsData>[stroke_, fill_, path_, GraphicHelper.END_FILL, GraphicHelper._H_B_];
        super();
        this.tutorial_ = tutorial;
        this.rect_ = bounds.clone();
        x = this.rect_.x;
        y = this.rect_.y;
        this.rect_.x = 0;
        this.rect_.y = 0;
        this.text_ = new SimpleText(15, 0xFFFFFF, false, this.rect_.width - 4 * BORDER, 0, "Myriad Pro");
        this.text_.text = "\t" + message;
        this.text_.wordWrap = true;
        this.text_.multiline = true;
        this.text_.x = 2 * BORDER;
        this.text_.y = 2 * BORDER;
        if (showNextButton) {
            this.nextButton_ = new _7f(18, "Next");
            this.nextButton_.addEventListener(MouseEvent.CLICK, this.onNextClick);
            this.nextButton_.x = this.rect_.width - this.nextButton_.width - 20;
            this.nextButton_.y = this.rect_.height - this.nextButton_.height - 10;
        }
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    private function drawRect():void {
        var scale:Number = Math.min(1, MIN_OPEN_SCALE + (1 - MIN_OPEN_SCALE) * (getTimer() - this.startTime_) / OPEN_DURATION_MS);
        if (scale == 1) {
            addChild(this.text_);
            if (this.nextButton_ != null) {
                addChild(this.nextButton_);
            }
            removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        }
        var r:Rectangle = this.rect_.clone();
        r.inflate(-(1 - scale) * this.rect_.width / 2, -(1 - scale) * this.rect_.height / 2);
        GraphicHelper._0L_6(this.path_);
        GraphicHelper.drawUI(r.x, r.y, r.width, r.height, 4, [1, 1, 1, 1], this.path_);
        graphics.clear();
        graphics.drawGraphicsData(this.graphicsData_);
    }

    private function onAddedToStage(e:Event):void {
        this.startTime_ = getTimer();
        addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onRemovedFromStage(e:Event):void {
        removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onEnterFrame(e:Event):void {
        this.drawRect();
    }

    private function onNextClick(e:MouseEvent):void {
        this.tutorial_.doneAction(Tutorial.NEXT);
    }

}
}
