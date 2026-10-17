package client.ui.controls {
import com.company.util.GraphicHelper;

import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Shape;
import flash.display.Sprite;

/**
 * Square check box graphic: a bordered rounded box, with a filled inner square
 * added when selected.
 */
public class CheckBoxIcon extends Sprite {

    private const SIZE:int = 28;
    private const BOX_RADIUS:int = 4;
    private const INNER_INSET:int = 4;
    private const INNER_RADIUS:int = 2;

    private var unselectedShape:Shape;
    private var selectedShape:Shape;

    public function CheckBoxIcon() {
        unselectedShape = createUnselectedShape();
        addChild(unselectedShape);
        selectedShape = createSelectedShape();
        addChild(selectedShape);
        setSelected(false);
    }

    public function setSelected(selected:Boolean):void {
        unselectedShape.visible = !selected;
        selectedShape.visible = selected;
    }

    private function createUnselectedShape():Shape {
        var shape:Shape = new Shape();
        drawBox(shape.graphics);
        return shape;
    }

    private function createSelectedShape():Shape {
        var shape:Shape = new Shape();
        drawBox(shape.graphics);
        drawInnerSquare(shape.graphics);
        return shape;
    }

    /** Near-transparent fill (keeps the box clickable) with a white rounded border. */
    private function drawBox(graphics:Graphics):void {
        var fill:GraphicsSolidFill = new GraphicsSolidFill(0, 0.01);
        var strokeFill:GraphicsSolidFill = new GraphicsSolidFill(0xFFFFFF, 1);
        var stroke:GraphicsStroke = new GraphicsStroke(2, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, strokeFill);
        var path:GraphicsPath = new GraphicsPath();
        GraphicHelper.drawUI(0, 0, SIZE, SIZE, BOX_RADIUS, GraphicHelper.ALL_CORNERS, path);
        var graphicsData:Vector.<IGraphicsData> = new <IGraphicsData>[stroke, fill, path, GraphicHelper.END_FILL, GraphicHelper.NO_STROKE];
        graphics.drawGraphicsData(graphicsData);
    }

    /** Solid white square inset inside the box. */
    private function drawInnerSquare(graphics:Graphics):void {
        var fill:GraphicsSolidFill = new GraphicsSolidFill(0xFFFFFF, 1);
        var path:GraphicsPath = new GraphicsPath();
        GraphicHelper.drawUI(INNER_INSET, INNER_INSET, SIZE - 2 * INNER_INSET, SIZE - 2 * INNER_INSET, INNER_RADIUS, GraphicHelper.ALL_CORNERS, path);
        var graphicsData:Vector.<IGraphicsData> = new <IGraphicsData>[fill, path, GraphicHelper.END_FILL];
        graphics.drawGraphicsData(graphicsData);
    }

}
}
