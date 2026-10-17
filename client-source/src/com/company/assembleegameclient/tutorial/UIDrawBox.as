package com.company.assembleegameclient.tutorial {
import com.company.util.ConversionUtil;

import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;

public class UIDrawBox {

    /** Duration (ms) of the grow-in animation. */
    public const ANIM_DURATION:int = 500;
    /** Point the box grows out from. */
    public const START_POINT:Point = new Point(250, 200);

    public var rect_:Rectangle;
    public var color_:uint;

    public function UIDrawBox(xml:XML) {
        this.rect_ = ConversionUtil.toRectangle(xml);
        this.color_ = uint(xml.@color);
    }

    public function draw(lineWidth:int, g:Graphics, elapsed:int):void {
        var x:Number;
        var y:Number;
        var w:Number = this.rect_.width - lineWidth;
        var h:Number = this.rect_.height - lineWidth;
        if (elapsed < this.ANIM_DURATION) {
            var t:Number = elapsed / this.ANIM_DURATION;
            x = this.START_POINT.x + (this.rect_.x - this.START_POINT.x) * elapsed / this.ANIM_DURATION;
            y = this.START_POINT.y + (this.rect_.y - this.START_POINT.y) * elapsed / this.ANIM_DURATION;
            w *= t;
            h *= t;
        } else {
            x = this.rect_.x + lineWidth / 2;
            y = this.rect_.y + lineWidth / 2;
        }
        g.lineStyle(lineWidth, this.color_);
        g.drawRect(x, y, w, h);
    }

}
}
