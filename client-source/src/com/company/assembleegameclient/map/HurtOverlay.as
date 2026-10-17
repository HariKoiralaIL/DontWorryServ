package com.company.assembleegameclient.map {
import com.company.util.GraphicHelper;

import flash.display.GradientType;
import flash.display.GraphicsGradientFill;
import flash.display.GraphicsPath;
import flash.display.IGraphicsData;
import flash.display.Shape;

/** Full-viewport radial vignette, tinted and pulsed by GameMap when the player is hurt. */
public class HurtOverlay extends Shape {

    private const diagonal:Number = 600 / Math.sin(Math.PI / 4);
    private const fill:GraphicsGradientFill = new GraphicsGradientFill(GradientType.RADIAL, [0xFFFFFF, 0xFFFFFF, 0xFFFFFF], [0, 0, 0.92], [0, 155, 0xFF], GraphicHelper.createGradientMatrix(diagonal, diagonal, 0, (600 - diagonal) / 2, (600 - diagonal) / 2));
    private const path:GraphicsPath = GraphicHelper.createRectPath(0, 0, 600, 600);
    private var graphicsData:Vector.<IGraphicsData>;

    public function HurtOverlay() {
        this.graphicsData = new <IGraphicsData>[this.fill, this.path, GraphicHelper.END_FILL];
        graphics.drawGraphicsData(this.graphicsData);
        visible = false;
    }

}
}
