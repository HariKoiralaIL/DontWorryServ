package spriteeditor {
import client.util.color.HSV;

import com.company.util.MoreColorUtil;

import flash.display.Sprite;

/** One square pixel of the editing grid. A null color means "empty". */
public class PixelCell extends Sprite {

    public function PixelCell(size:int, transparentWhenEmpty:Boolean) {
        this.size_ = size;
        this.transparentWhenEmpty_ = transparentWhenEmpty;
        this.redraw();
    }
    public var size_:int;
    public var color_:HSV = null;
    private var transparentWhenEmpty_:Boolean;

    public function setColor(color:HSV):void {
        this.color_ = ((color != null) ? color.clone() : null);
        this.redraw();
    }

    public function getColor():uint {
        return (((this.color_ == null) ? 0 : MoreColorUtil.hsvToRgb(this.color_.h, this.color_.s, this.color_.v)));
    }

    public function redraw():void {
        graphics.clear();
        if (this.color_ == null) {
            graphics.beginFill(0, ((this.transparentWhenEmpty_) ? 0 : 1));
        } else {
            graphics.beginFill(MoreColorUtil.hsvToRgb(this.color_.h, this.color_.s, this.color_.v));
        }
        graphics.drawRect(0, 0, this.size_, this.size_);
        graphics.endFill();
    }

}
}
