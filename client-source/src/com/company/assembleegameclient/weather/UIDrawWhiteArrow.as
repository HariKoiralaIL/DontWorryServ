package com.company.assembleegameclient.weather {
import com.company.util.ConversionUtil;
import com.company.util.PointUtil;

import flash.display.Graphics;
import flash.geom.Point;

/** Same as tutorial.UIDrawArrow, but always white. */
public class UIDrawWhiteArrow {

    /** Duration (ms) of the grow-in animation. */
    public const ANIM_DURATION:int = 500;

    private static const HEAD_ANGLE:Number = Math.PI / 8;
    private static const HEAD_LENGTH:Number = 30;

    public var p0_:Point;
    public var p1_:Point;
    public var color_:uint;

    public function UIDrawWhiteArrow(xml:XML) {
        var points:Array = ConversionUtil.toPointPair(xml);
        this.p0_ = points[0];
        this.p1_ = points[1];
        this.color_ = 0xFFFFFF;
    }

    public function draw(lineWidth:int, g:Graphics, elapsed:int):void {
        var tip:Point = new Point();
        if (elapsed < this.ANIM_DURATION) {
            tip.x = this.p0_.x + (this.p1_.x - this.p0_.x) * elapsed / this.ANIM_DURATION;
            tip.y = this.p0_.y + (this.p1_.y - this.p0_.y) * elapsed / this.ANIM_DURATION;
        } else {
            tip.x = this.p1_.x;
            tip.y = this.p1_.y;
        }
        g.lineStyle(lineWidth, this.color_);
        g.moveTo(this.p0_.x, this.p0_.y);
        g.lineTo(tip.x, tip.y);
        var angle:Number = PointUtil.angleBetween(tip, this.p0_);
        var head:Point = PointUtil.pointAtAngle(tip, angle + HEAD_ANGLE, HEAD_LENGTH);
        g.lineTo(head.x, head.y);
        head = PointUtil.pointAtAngle(tip, angle - HEAD_ANGLE, HEAD_LENGTH);
        g.moveTo(tip.x, tip.y);
        g.lineTo(head.x, head.y);
    }

}
}
