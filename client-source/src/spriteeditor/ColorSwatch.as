package spriteeditor {
import flash.display.Sprite;

import client.util.color.HSV;

import com.company.util.MoreColorUtil;

/** A square of solid color. When locked, setColor() is ignored after construction. */
public class ColorSwatch extends Sprite {

    public var size_:int;
    public var color_:HSV;
    public var locked_:Boolean = false;

    public function ColorSwatch(size:int, color:HSV, locked:Boolean) {
        this.size_ = size;
        this.color_ = new HSV();
        this.setColor(color);
        this.locked_ = locked;
    }

    public function setColor(color:HSV):void {
        if (this.locked_) {
            return;
        }
        this.color_.h = color.h;
        this.color_.s = color.s;
        this.color_.v = color.v;
        var rgb:uint = MoreColorUtil.hsvToRgb(this.color_.h, this.color_.s, this.color_.v);
        graphics.beginFill(rgb);
        graphics.drawRect(0, 0, this.size_, this.size_);
        graphics.endFill();
    }
}
}//package spriteeditor
