package com.company.assembleegameclient.util {
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Sprite;

public class ModalBackground extends Sprite {

    public static const HORIZONTAL_DIVISION:String = "HORIZONTAL_DIVISION";
    public static const VERTICAL_DIVISION:String = "VERTICAL_DIVISION";

    /** Plain filled panel. */
    public static const STYLE_FILLED:int = 0;
    /** Panel with a 30px header band. */
    public static const STYLE_WITH_HEADER:int = 1;
    /** Outline only, no fill. */
    public static const STYLE_OUTLINE:int = 2;

    private static const BEVEL:int = 4;
    private static const FILL_COLOR:uint = 0x2A2A2A;
    private static const BORDER_COLOR:uint = 0xFFFFFF;
    private static const DIVIDER_COLOR:uint = 0x666666;

    public function draw(boxWidth:int, boxHeight:int, style:int = 0):void {
        var outline:BevelRect = new BevelRect(boxWidth, boxHeight, BEVEL);
        var drawer:BevelRectDrawer = new BevelRectDrawer();
        graphics.lineStyle(1, BORDER_COLOR, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3);
        switch (style) {
            case STYLE_FILLED:
                graphics.beginFill(FILL_COLOR);
                drawer.drawBevelRect(0, 0, outline, graphics);
                graphics.endFill();
                break;
            case STYLE_WITH_HEADER:
                graphics.lineStyle(1, FILL_COLOR, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3);
                graphics.beginFill(FILL_COLOR, 1);
                drawer.drawBevelRect(1, 1, new BevelRect((boxWidth - 2), 29, BEVEL), graphics);
                graphics.endFill();
                graphics.beginFill(FILL_COLOR, 1);
                graphics.drawRect(1, 15, (boxWidth - 2), 15);
                graphics.endFill();
                graphics.lineStyle(2, BORDER_COLOR, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3);
                graphics.beginFill(FILL_COLOR, 0);
                drawer.drawBevelRect(0, 0, outline, graphics);
                graphics.endFill();
                break;
            case STYLE_OUTLINE:
                graphics.lineStyle(2, BORDER_COLOR, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3);
                graphics.beginFill(FILL_COLOR, 0);
                drawer.drawBevelRect(0, 0, outline, graphics);
                graphics.endFill();
                break;
            default:
                throw new Error("No value has been set!");
        }
    }

    /** @param direction HORIZONTAL_DIVISION or VERTICAL_DIVISION; @param offset y (horizontal) or x (vertical) position */
    public function drawDivider(direction:String, offset:int):void {
        switch (direction) {
            case HORIZONTAL_DIVISION:
                this.drawHorizontalDivider(offset);
                break;
            case VERTICAL_DIVISION:
                this.drawVerticalDivider(offset);
                break;
        }
    }

    private function drawHorizontalDivider(y:int):void {
        graphics.lineStyle();
        graphics.endFill();
        graphics.moveTo(1, y);
        graphics.beginFill(DIVIDER_COLOR, 1);
        graphics.drawRect(1, y, (width - 2), 2);
    }

    private function drawVerticalDivider(x:int):void {
        graphics.lineStyle();
        graphics.moveTo(x, 1);
        graphics.lineStyle(2, DIVIDER_COLOR);
        graphics.lineTo(x, (height - 1));
    }

}
}
