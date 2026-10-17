package com.company.assembleegameclient.ui {
import com.company.util.GraphicHelper;

import flash.display.Graphics;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;
import flash.utils.getTimer;

/**
 * Vertical scrollbar with up / down arrows, a draggable thumb and a clickable
 * track. Dispatches Event.CHANGE whenever the scroll position changes.
 *
 * Formerly: _0K_B_
 */
public class Scrollbar extends Sprite {

    private static const THUMB_COLOR:uint = 0x4C4C4C;
    private static const TRACK_COLOR:uint = 0x2A2A2A;
    private static const ARROW_COLOR:uint = 0x4C4C4C;

    /** Draws a right-pointing triangle plus a nearly invisible hit area. Formerly _G_k. */
    private static function drawArrow(width:int, height:int, g:Graphics):void {
        g.clear();
        g.beginFill(0x353535, 0.01);
        g.drawRect(-width / 2, -height / 2, width, height);
        g.endFill();
        g.beginFill(ARROW_COLOR, 1);
        g.moveTo(-width / 2, -height / 2);
        g.lineTo(width / 2, 0);
        g.lineTo(-width / 2, height / 2);
        g.lineTo(-width / 2, -height / 2);
        g.endFill();
    }

    private var width_:int;
    private var height_:int;
    private var speed_:Number;
    /** The area between the two arrows in which the thumb moves (formerly _gC_). */
    private var trackRect_:Rectangle;
    /** Scroll distance of one page, as a fraction of the scrollable range (formerly _oI_). */
    private var pageSize_:Number;
    private var background_:Sprite;
    private var upArrow_:Sprite;
    private var downArrow_:Sprite;
    private var thumb_:Sprite;
    private var lastTime_:int;
    /** Signed scroll speed while an arrow is held (formerly _H_). */
    private var scrollSpeed_:Number;

    private var fill_:GraphicsSolidFill = new GraphicsSolidFill(THUMB_COLOR, 1);
    private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
    private var graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[fill_, path_, GraphicHelper.END_FILL];

    public function Scrollbar(width:int, height:int, speed:Number = 1) {
        super();
        this.background_ = new Sprite();
        this.background_.addEventListener(MouseEvent.MOUSE_DOWN, this.onTrackMouseDown);
        addChild(this.background_);
        this.upArrow_ = this.createArrowButton(this.onUpArrowDown);
        addChild(this.upArrow_);
        this.downArrow_ = this.createArrowButton(this.onDownArrowDown);
        addChild(this.downArrow_);
        this.thumb_ = this.createArrowButton(this.onThumbMouseDown);
        addChild(this.thumb_);
        this.resize(width, height, speed);
    }

    /** Scroll position from 0 (top) to 1 (bottom). Formerly _Q_D_. */
    public function getPosition():Number {
        return (this.thumb_.y - this.trackRect_.y) / (this.trackRect_.height - this.thumb_.height);
    }

    /**
     * Sizes the thumb for the visible / total content ratio. Formerly _fA_.
     *
     * @param visibleSize size of the visible area
     * @param totalSize   size of all content
     * @param resetPosition scroll back to the top
     */
    public function setIndicatorSize(visibleSize:Number, totalSize:Number, resetPosition:Boolean = true):void {
        var thumbHeight:int = (totalSize == 0) ? this.trackRect_.height : ((visibleSize / totalSize) * this.trackRect_.height);
        thumbHeight = Math.min(this.trackRect_.height, Math.max(this.width_, thumbHeight));
        this.drawThumb(this.width_, thumbHeight, this.thumb_.graphics);
        this.pageSize_ = visibleSize / (totalSize - visibleSize);
        if (resetPosition) {
            this.setPosition(0);
        }
    }

    /** Formerly _0D__ */
    public function setPosition(position:Number):void {
        position = Math.max(0, Math.min(1, position));
        this.thumb_.y = (position * (this.trackRect_.height - this.thumb_.height)) + this.trackRect_.y;
        this.dispatchChange();
    }

    /** Formerly _d9 */
    public function pageUp():void {
        this.setPosition(this.getPosition() - this.pageSize_);
    }

    /** Formerly _tE_ */
    public function pageDown():void {
        this.setPosition(this.getPosition() + this.pageSize_);
    }

    public function resize(width:int, height:int, speed:Number = 1):void {
        this.width_ = width;
        this.height_ = height;
        this.speed_ = speed;
        var arrowSize:int = this.width_ * 0.75;
        this.trackRect_ = new Rectangle(0, arrowSize + 5, this.width_, (this.height_ - (arrowSize * 2)) - 10);
        var g:Graphics = this.background_.graphics;
        g.clear();
        g.beginFill(TRACK_COLOR, 1);
        g.drawRect(this.trackRect_.x, this.trackRect_.y, this.trackRect_.width, this.trackRect_.height);
        g.endFill();
        drawArrow(arrowSize, this.width_, this.upArrow_.graphics);
        this.upArrow_.rotation = -90;
        this.upArrow_.x = this.width_ / 2;
        this.upArrow_.y = arrowSize / 2;
        drawArrow(arrowSize, this.width_, this.downArrow_.graphics);
        this.downArrow_.x = this.width_ / 2;
        this.downArrow_.y = this.height_ - (arrowSize / 2);
        this.downArrow_.rotation = 90;
        this.drawThumb(this.width_, this.height_, this.thumb_.graphics);
        this.thumb_.x = 0;
        this.thumb_.y = this.trackRect_.y;
    }

    /** Creates an interactive sprite with hover highlight. Formerly _y9. */
    private function createArrowButton(mouseDownHandler:Function):Sprite {
        var button:Sprite = new Sprite();
        button.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        button.addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
        button.addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
        return button;
    }

    /** Formerly _bf */
    private function dispatchChange():void {
        dispatchEvent(new Event(Event.CHANGE));
    }

    /** Draws the rounded thumb. Formerly _5s. */
    private function drawThumb(width:int, height:int, g:Graphics):void {
        GraphicHelper.clearPath(this.path_);
        GraphicHelper.drawUI(0, 0, width, height, 4, [1, 1, 1, 1], this.path_);
        g.clear();
        g.drawGraphicsData(this.graphicsData_);
    }

    /** Formerly _0G_t */
    private function onRollOver(event:MouseEvent):void {
        var target:Sprite = event.target as Sprite;
        target.transform.colorTransform = new ColorTransform(1.6513, 1.8627, -0.5216);
    }

    private function onRollOut(event:MouseEvent):void {
        var target:Sprite = event.target as Sprite;
        target.transform.colorTransform = new ColorTransform(1, 1, 1);
    }

    /** Click on the track pages up or down. Formerly _06t. */
    private function onTrackMouseDown(event:MouseEvent):void {
        if (event.localY < this.thumb_.y) {
            this.pageUp();
        } else {
            this.pageDown();
        }
    }

    /** Formerly _0C_S_ */
    private function onUpArrowDown(event:MouseEvent):void {
        addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        addEventListener(MouseEvent.MOUSE_UP, this.onArrowMouseUp);
        this.lastTime_ = getTimer();
        this.scrollSpeed_ = -this.speed_;
    }

    /** Formerly _bX_ */
    private function onDownArrowDown(event:MouseEvent):void {
        addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        addEventListener(MouseEvent.MOUSE_UP, this.onArrowMouseUp);
        this.lastTime_ = getTimer();
        this.scrollSpeed_ = this.speed_;
    }

    /** Scrolls continuously while an arrow is held. Formerly _0N_. */
    private function onEnterFrame(event:Event):void {
        var now:int = getTimer();
        var elapsed:Number = (now - this.lastTime_) / 1000;
        var delta:int = ((this.height_ - (this.width_ * 3)) * elapsed) * this.scrollSpeed_;
        this.setPosition(((this.thumb_.y + delta) - this.trackRect_.y) / (this.trackRect_.height - this.thumb_.height));
        this.lastTime_ = now;
    }

    /** Formerly _04J_ */
    private function onArrowMouseUp(event:Event):void {
        removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        removeEventListener(MouseEvent.MOUSE_UP, this.onArrowMouseUp);
    }

    /** Formerly _0N_3 */
    private function onThumbMouseDown(event:MouseEvent):void {
        this.thumb_.startDrag(false, new Rectangle(0, this.trackRect_.y, 0, this.trackRect_.height - this.thumb_.height));
        stage.addEventListener(MouseEvent.MOUSE_UP, this.onThumbMouseUp);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onThumbMouseMove);
        this.dispatchChange();
    }

    /** Formerly _J_J_ */
    private function onThumbMouseUp(event:MouseEvent):void {
        stage.removeEventListener(MouseEvent.MOUSE_UP, this.onThumbMouseUp);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onThumbMouseMove);
        this.thumb_.stopDrag();
        this.dispatchChange();
    }

    /** Formerly _ma */
    private function onThumbMouseMove(event:MouseEvent):void {
        this.dispatchChange();
    }
}
}
