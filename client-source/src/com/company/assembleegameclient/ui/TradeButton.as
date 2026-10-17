package com.company.assembleegameclient.ui {
import com.company.ui.SimpleText;
import com.company.util.GraphicHelper;

import flash.display.CapsStyle;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.getTimer;

/**
 * The "Trade" button of the trade window. It is disabled for a short
 * countdown (shown as a filling progress bar) to avoid accidental accepts, and
 * switches to "Waiting" once clicked.
 *
 * Formerly: ui_trading
 */
public class TradeButton extends Sprite {

    /** Time the button stays disabled after a (re)start, in milliseconds. */
    private static const COUNTDOWN_MS:int = 2999;

    private static const STATE_COUNTDOWN:int = 0;
    private static const STATE_READY:int = 1;
    private static const STATE_WAITING:int = 2;
    private static const STATE_BLOCKED:int = 3;

    private static const NORMAL_COLOR:uint = 0xFFFFFF;
    private static const HOVER_COLOR:uint = 0xFFDC85;
    private static const DISABLED_COLOR:uint = 0x7F7F7F;
    private static const PROGRESS_COLOR:uint = 0xBFBFBF;

    /** Container of the progress fill and outline; formerly _9C_. */
    public var progressHolder_:Sprite;
    /** Mask that reveals the progress fill; formerly _05l. */
    public var progressMask_:Shape;
    public var text_:SimpleText;
    public var w_:int;
    public var h_:int;

    private var state_:int;
    private var startTime_:int;

    private var enabledFill_:GraphicsSolidFill = new GraphicsSolidFill(NORMAL_COLOR, 1);
    private var disabledFill_:GraphicsSolidFill = new GraphicsSolidFill(DISABLED_COLOR, 1);
    private var progressFill_:GraphicsSolidFill = new GraphicsSolidFill(PROGRESS_COLOR, 1);
    private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(0xFFFFFF, 1);
    private var outlineStroke_:GraphicsStroke = new GraphicsStroke(2, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, outlineFill_);
    private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
    private var graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[enabledFill_, path_, GraphicHelper.END_FILL];
    private var progressGraphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[progressFill_, path_, GraphicHelper.END_FILL];
    private var outlineGraphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[outlineStroke_, path_, GraphicHelper.NO_STROKE];

    public function TradeButton(fontSize:int, width:int = 0) {
        super();
        this.startTime_ = getTimer();
        this.text_ = new SimpleText(fontSize, 0x363636, false, 0, 0, "Myriad Pro");
        this.text_.setBold(true);
        this.text_.text = "Trade";
        this.text_.updateMetrics();
        this.w_ = (width != 0) ? width : (this.text_.width + 12);
        this.h_ = this.text_.textHeight + 8;
        GraphicHelper.clearPath(this.path_);
        GraphicHelper.drawUI(0, 0, this.w_, this.h_, 4, [1, 1, 1, 1], this.path_);
        this.text_.x = (this.w_ / 2) - (this.text_.textWidth / 2) - 2;
        this.text_.y = 1;
        this.progressHolder_ = this.createProgressBar();
        addChild(this.progressHolder_);
        addChild(this.text_);
        this.draw();
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
        addEventListener(MouseEvent.CLICK, this.onClick);
    }

    /** Restarts the countdown. */
    public function reset():void {
        this.startTime_ = getTimer();
        this.state_ = STATE_COUNTDOWN;
        this.setEnabled(false);
        this.setLabel("Trade");
    }

    /** Disables the button (e.g. because a side has no room); formerly _pW_. */
    public function block():void {
        this.state_ = STATE_BLOCKED;
        this.setEnabled(false);
        this.setLabel("Trade");
    }

    /** Formerly _02C_ */
    private function setLabel(label:String):void {
        this.text_.text = label;
        this.text_.updateMetrics();
        this.text_.x = (this.w_ / 2) - (this.text_.textWidth / 2) - 2;
        this.text_.y = 1;
    }

    /** Formerly _A_w */
    private function setEnabled(enabled:Boolean):void {
        if (enabled == mouseEnabled) {
            return;
        }
        mouseEnabled = enabled;
        mouseChildren = enabled;
        this.graphicsData_[0] = enabled ? this.enabledFill_ : this.disabledFill_;
        this.draw();
    }

    /** Formerly _e4 */
    private function createProgressBar():Sprite {
        var holder:Sprite = new Sprite();
        var fillHolder:Sprite = new Sprite();
        var fillShape:Shape = new Shape();
        fillShape.graphics.clear();
        fillShape.graphics.drawGraphicsData(this.progressGraphicsData_);
        fillHolder.addChild(fillShape);
        this.progressMask_ = new Shape();
        fillHolder.addChild(this.progressMask_);
        fillHolder.mask = this.progressMask_;
        holder.addChild(fillHolder);
        var outlineShape:Shape = new Shape();
        outlineShape.graphics.clear();
        outlineShape.graphics.drawGraphicsData(this.outlineGraphicsData_);
        holder.addChild(outlineShape);
        return holder;
    }

    /** Formerly _qr */
    private function drawProgress(fraction:Number):void {
        this.progressMask_.graphics.clear();
        this.progressMask_.graphics.beginFill(PROGRESS_COLOR);
        this.progressMask_.graphics.drawRect(0, 0, this.w_ * fraction, this.h_);
        this.progressMask_.graphics.endFill();
    }

    private function draw():void {
        var now:int = getTimer();
        if (this.state_ == STATE_COUNTDOWN && (now - this.startTime_) >= COUNTDOWN_MS) {
            this.state_ = STATE_READY;
            this.setEnabled(true);
        }
        switch (this.state_) {
            case STATE_COUNTDOWN:
                this.progressHolder_.visible = true;
                this.drawProgress((now - this.startTime_) / COUNTDOWN_MS);
                break;
            case STATE_BLOCKED:
            case STATE_READY:
            case STATE_WAITING:
                this.progressHolder_.visible = false;
                break;
        }
        graphics.clear();
        graphics.drawGraphicsData(this.graphicsData_);
    }

    private function onAddedToStage(event:Event):void {
        addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        this.reset();
        this.draw();
    }

    private function onRemovedFromStage(event:Event):void {
        removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onEnterFrame(event:Event):void {
        this.draw();
    }

    private function onMouseOver(event:MouseEvent):void {
        this.enabledFill_.color = HOVER_COLOR;
        this.draw();
    }

    private function onRollOut(event:MouseEvent):void {
        this.enabledFill_.color = NORMAL_COLOR;
        this.draw();
    }

    private function onClick(event:MouseEvent):void {
        this.state_ = STATE_WAITING;
        this.setEnabled(false);
        this.setLabel("Waiting");
    }
}
}
