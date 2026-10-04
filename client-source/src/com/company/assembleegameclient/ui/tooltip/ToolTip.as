// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.ToolTip

package com.company.assembleegameclient.ui.tooltip {
import flash.display.Sprite;

import flash.display.IGraphicsData;

import com.company.util.GraphicHelper;

import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.GraphicsPath;
import flash.display.LineScaleMode;
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.filters.DropShadowFilter;
import flash.events.Event;


public class ToolTip extends Sprite {

    public function ToolTip(_arg1:uint, _arg2:Number, _arg3:uint, _arg4:Number, _arg5:Boolean = true) {
        this.backgroundFill_ = new GraphicsSolidFill(0, 1);
        this.outlineFill_ = new GraphicsSolidFill(0xFFFFFF, 1);
        this.outlineStroke_ = new GraphicsStroke(1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, this.outlineFill_);
        this.path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        this.graphicsData_ = new <IGraphicsData>[outlineStroke_, backgroundFill_, path_, GraphicHelper.END_FILL, GraphicHelper._H_B_];
        super();
        this.background_ = _arg1;
        this.backgroundAlpha_ = _arg2;
        this.outlineColor_ = _arg3;
        this.outlineAlpha_ = _arg4;
        this.followMouse_ = _arg5;
        mouseEnabled = false;
        mouseChildren = false;
        filters = [new DropShadowFilter(0, 0, 0, 1, 16, 16)];
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }
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

    public function draw():void {
        this.backgroundFill_.color = this.background_;
        this.backgroundFill_.alpha = this.backgroundAlpha_;
        this.outlineFill_.color = this.outlineColor_;
        this.outlineFill_.alpha = this.outlineAlpha_;
        graphics.clear();
        this.contentWidth_ = width;
        this.contentHeight_ = height;
        GraphicHelper._0L_6(this.path_);
        GraphicHelper.drawUI(-6, -6, (this.contentWidth_ + 12), (this.contentHeight_ + 12), 4, [1, 1, 1, 1], this.path_);
        graphics.drawGraphicsData(this.graphicsData_);
    }

    private function position():void {
        if (stage == null) {
            return;
        }
        stage;
        if (stage.mouseX < (800 / 2)) {
            x = (stage.mouseX + 12);
        } else {
            x = ((stage.mouseX - width) - 1);
        }
        if (x < 12) {
            x = 12;
        }
        stage;
        if (stage.mouseY < (600 / 3)) {
            y = (stage.mouseY + 12);
        } else {
            y = ((stage.mouseY - height) - 1);
        }
        if (y < 12) {
          //  y = 12;
        }
    }

    private function onAddedToStage(_arg1:Event):void {
        this.draw();
        if (this.followMouse_) {
            this.position();
            addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        }
    }

    private function onRemovedFromStage(_arg1:Event):void {
        if (this.followMouse_) {
            removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        }
    }

    private function onEnterFrame(_arg1:Event):void {
        this.position();
    }

}
}//package com.company.assembleegameclient.ui.tooltip

