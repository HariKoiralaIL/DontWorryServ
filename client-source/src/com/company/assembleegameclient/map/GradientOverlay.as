package com.company.assembleegameclient.map {
import com.company.util.GraphicHelper;

import flash.display.GradientType;
import flash.display.GraphicsGradientFill;
import flash.display.GraphicsPath;
import flash.display.IGraphicsData;
import flash.display.Shape;

/** Thin shaded strip drawn along the right edge of the viewport. */
public class GradientOverlay extends Shape {

    private const fill:GraphicsGradientFill = new GraphicsGradientFill(GradientType.LINEAR, [0, 0], [0, 1], [0, 0xFF], GraphicHelper.createGradientMatrix(10, 600));
    private const path:GraphicsPath = GraphicHelper.createRectPath(0, 0, 10, 600);
    private var graphicsData:Vector.<IGraphicsData>;

    public function GradientOverlay() {
        this.graphicsData = new <IGraphicsData>[this.fill, this.path, GraphicHelper.END_FILL];
        graphics.drawGraphicsData(this.graphicsData);
        visible = false;
    }

}
}
