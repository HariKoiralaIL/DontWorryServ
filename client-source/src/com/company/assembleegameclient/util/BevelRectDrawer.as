package com.company.assembleegameclient.util {
import flash.display.Graphics;

public class BevelRectDrawer {

    /** Traces the outline of a bevelled rectangle with the given Graphics (fill/line style set by the caller). */
    public function drawBevelRect(x:int, y:int, rect:BevelRect, graphics:Graphics):void {
        var right:int = (x + rect.width);
        var bottom:int = (y + rect.height);
        var bevel:int = rect.bevel_;
        if (rect.topLeftBevel_) {
            graphics.moveTo(x, (y + bevel));
            graphics.lineTo((x + bevel), y);
        } else {
            graphics.moveTo(x, y);
        }
        if (rect.topRightBevel_) {
            graphics.lineTo((right - bevel), y);
            graphics.lineTo(right, (y + bevel));
        } else {
            graphics.lineTo(right, y);
        }
        if (rect.bottomRightBevel_) {
            graphics.lineTo(right, (bottom - bevel));
            graphics.lineTo((right - bevel), bottom);
        } else {
            graphics.lineTo(right, bottom);
        }
        if (rect.bottomLeftBevel_) {
            graphics.lineTo((x + bevel), bottom);
            graphics.lineTo(x, (bottom - bevel));
        } else {
            graphics.lineTo(x, bottom);
        }
    }

}
}
