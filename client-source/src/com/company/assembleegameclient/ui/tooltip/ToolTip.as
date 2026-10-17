package com.company.assembleegameclient.ui.tooltip {
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
import flash.filters.DropShadowFilter;

public class ToolTip extends Sprite {

    private static const SCREEN_WIDTH:int = 800;
    private static const SCREEN_HEIGHT:int = 600;
    private static const CURSOR_OFFSET:int = 12;
    private static const PADDING:int = 6;

    public var contentWidth_:int;
    public var contentHeight_:int;

    private var graphicsData_:Vector.<IGraphicsData>;
    private var background_:uint;
    private var backgroundAlpha_:Number;
    private var outlineColor_:uint;
    private var outlineAlpha_:Number;
    private var followMouse_:Boolean;
    private var backgroundFill_:GraphicsSolidFill;
    private var outlineFill_:GraphicsSolidFill;
    private var outlineStroke_:GraphicsStroke;
    private var path_:GraphicsPath;

    public function ToolTip(background:uint, backgroundAlpha:Number, outlineColor:uint, outlineAlpha:Number, followMouse:Boolean = true) {
        backgroundFill_ = new GraphicsSolidFill(0, 1);
        outlineFill_ = new GraphicsSolidFill(0xFFFFFF, 1);
        outlineStroke_ = new GraphicsStroke(1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, outlineFill_);
        path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        graphicsData_ = new <IGraphicsData>[outlineStroke_, backgroundFill_, path_, GraphicHelper.END_FILL, GraphicHelper.NO_STROKE];
        super();
        background_ = background;
        backgroundAlpha_ = backgroundAlpha;
        outlineColor_ = outlineColor;
        outlineAlpha_ = outlineAlpha;
        followMouse_ = followMouse;
        mouseEnabled = false;
        mouseChildren = false;
        filters = [new DropShadowFilter(0, 0, 0, 1, 16, 16)];
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }

    public function draw():void {
        backgroundFill_.color = background_;
        backgroundFill_.alpha = backgroundAlpha_;
        outlineFill_.color = outlineColor_;
        outlineFill_.alpha = outlineAlpha_;
        graphics.clear();
        contentWidth_ = width;
        contentHeight_ = height;
        GraphicHelper.clearPath(path_);
        GraphicHelper.drawUI(-PADDING, -PADDING, contentWidth_ + 2 * PADDING, contentHeight_ + 2 * PADDING, 4, [1, 1, 1, 1], path_);
        graphics.drawGraphicsData(graphicsData_);
    }

    private function position():void {
        if (stage == null) {
            return;
        }
        if (stage.mouseX < SCREEN_WIDTH / 2) {
            x = stage.mouseX + CURSOR_OFFSET;
        } else {
            x = stage.mouseX - width - 1;
        }
        if (x < CURSOR_OFFSET) {
            x = CURSOR_OFFSET;
        }
        if (stage.mouseY < SCREEN_HEIGHT / 3) {
            y = stage.mouseY + CURSOR_OFFSET;
        } else {
            y = stage.mouseY - height - 1;
        }
    }

    private function onAddedToStage(event:Event):void {
        draw();
        if (followMouse_) {
            position();
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
    }

    private function onRemovedFromStage(event:Event):void {
        if (followMouse_) {
            removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
    }

    private function onEnterFrame(event:Event):void {
        position();
    }

}
}
