package com.company.assembleegameclient.ui {
import com.company.util.GraphicHelper;

import flash.display.GraphicsPath;
import flash.display.GraphicsPathWinding;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Shape;

/**
 * Thin horizontal or vertical divider line with small end caps.
 *
 * Formerly: _return
 */
public class LineSeparator extends Shape {

    private static const END_CAP_SIZE:int = 4;

    private var fill_:GraphicsSolidFill = new GraphicsSolidFill(0xFFFFFF, 1);
    private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>(), GraphicsPathWinding.NON_ZERO);
    private var graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[fill_, path_, GraphicHelper.END_FILL];

    public function LineSeparator(length:int, color:uint, vertical:Boolean = false) {
        super();
        if (vertical) {
            this.drawVertical(length, color);
        } else {
            this.drawHorizontal(length, color);
        }
    }

    /** Formerly _rs */
    public function drawHorizontal(length:int, color:uint):void {
        graphics.clear();
        this.fill_.color = color;
        GraphicHelper.clearPath(this.path_);
        GraphicHelper.drawSpacer(0, 0, END_CAP_SIZE, this.path_);
        GraphicHelper.drawSpacer(length, 0, END_CAP_SIZE, this.path_);
        GraphicHelper.drawRect(0, -1, length, 2, this.path_);
        graphics.drawGraphicsData(this.graphicsData_);
    }

    /** Formerly drawVert */
    public function drawVertical(length:int, color:uint):void {
        graphics.clear();
        this.fill_.color = color;
        GraphicHelper.clearPath(this.path_);
        GraphicHelper.drawSpacer(0, 0, END_CAP_SIZE, this.path_);
        GraphicHelper.drawSpacer(0, length, END_CAP_SIZE, this.path_);
        GraphicHelper.drawRect(-1, 0, 2, length, this.path_);
        graphics.drawGraphicsData(this.graphicsData_);
    }
}
}
