package _zm {
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

// Formerly _fp. A single clickable row/button showing one string value.
public class DropdownItem extends Sprite {

    private static const FONT:String = "Myriad Pro";
    private static const TEXT_COLOR:uint = 0xB3B3B3;
    private static const BORDER_COLOR:uint = 0xB3B3B3;
    private static const BG_NORMAL:uint = 0x363636;
    private static const BG_HOVER:uint = 0x565656;

    public var w_:int;
    public var h_:int;
    private var nameText_:SimpleText;

    public function DropdownItem(value:String, width:int, height:int) {
        this.w_ = width;
        this.h_ = height;
        this.nameText_ = new SimpleText(16, TEXT_COLOR, false, 0, 0, FONT);
        this.nameText_.setBold(true);
        this.nameText_.text = value;
        this.nameText_.updateMetrics();
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
        this.nameText_.x = (this.w_ - this.nameText_.width) / 2;
        this.nameText_.y = (this.h_ - this.nameText_.height) / 2;
        addChild(this.nameText_);
        this.drawBackground(BG_NORMAL);
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
    }

    public function getValue():String {
        return this.nameText_.text;
    }

    private function drawBackground(color:uint):void {
        graphics.clear();
        graphics.lineStyle(1, BORDER_COLOR);
        graphics.beginFill(color, 1);
        graphics.drawRect(0, 0, this.w_, this.h_);
        graphics.endFill();
        graphics.lineStyle();
    }

    private function onMouseOver(e:MouseEvent):void {
        this.drawBackground(BG_HOVER);
    }

    private function onMouseOut(e:MouseEvent):void {
        this.drawBackground(BG_NORMAL);
    }
}
}
