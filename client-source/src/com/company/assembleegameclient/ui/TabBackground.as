package com.company.assembleegameclient.ui {
import com.company.util.GraphicHelper;

import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Sprite;

/** Dark rounded panel shown below a tab button; the first tab has a square top-left corner. */
public class TabBackground extends Sprite {

    public var width_:int;
    public var height_:int;

    protected var fill_:GraphicsSolidFill = new GraphicsSolidFill(0x191919, 1);
    protected var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
    private var graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[fill_, path_, GraphicHelper.END_FILL];

    public function TabBackground(width:int, height:int) {
        super();
        this.width_ = width;
        this.height_ = height;
    }

    public function draw(firstTab:Boolean):void {
        GraphicHelper.clearPath(this.path_);
        GraphicHelper.drawUI(0, 0, this.width_, this.height_, 6, [firstTab ? 0 : 1, 1, 1, 1], this.path_);
        this.graphics.clear();
        this.graphics.drawGraphicsData(this.graphicsData_);
    }
}
}
