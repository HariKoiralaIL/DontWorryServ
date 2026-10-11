package optionsscreen {

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import com.company.ui.SimpleText;

/** A clickable tab heading on the options screen ("Controls", "Chat", ...). */
public class OptionsTabTitle extends Sprite {

    private static const FONT_SIZE:int = 16;

    public var text_:String;
    protected var labelText:SimpleText;
    protected var selected_:Boolean;

    public function OptionsTabTitle(text:String) {
        this.text_ = text;
        var isExtras:Boolean = (text == "Extras");
        this.labelText = new SimpleText(FONT_SIZE, isExtras ? 0xFF1493 : 0xB3B3B3, false, 0, 0, "Myriad Pro");
        if (isExtras) {
            this.labelText.setUnderline(true);
        }
        this.labelText.setBold(true);
        this.labelText.text = this.text_;
        this.labelText.updateMetrics();
        this.labelText.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        addChild(this.labelText);
        this.selected_ = false;
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
    }

    public function setSelected(selected:Boolean):void {
        this.selected_ = selected;
        this.redraw(false);
    }

    private function redraw(hovering:Boolean):void {
        var color:uint = hovering ? 0xFFFFFF : 0xB3B3B3;
        if (this.selected_) {
            color = 0xFFC800;
        }
        if (this.text_ == "Extras") {
            color = 0xFF1493;
        }
        this.labelText._du(FONT_SIZE, color);
    }

    private function onMouseOver(event:MouseEvent):void {
        this.redraw(true);
    }

    private function onRollOut(event:MouseEvent):void {
        this.redraw(false);
    }

}
}//package optionsscreen
