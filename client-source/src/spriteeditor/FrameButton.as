package spriteeditor {
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.MouseEvent;

public class FrameButton extends Sprite {

    private static const WIDTH:int = 60;
    private static const HEIGHT:int = 22;

    public function FrameButton(label:String) {
        this.label_ = label;
        this.text_ = new SimpleText(14, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.text_.setBold(true);
        this.text_.text = label;
        this.text_.updateMetrics();
        this.text_.x = ((WIDTH / 2) - (this.text_.width / 2));
        addChild(this.text_);
        this.redraw();
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
        addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
    }
    public var label_:String;
    private var over_:Boolean = false;
    private var pressed_:Boolean = false;
    private var selected_:Boolean = false;
    private var text_:SimpleText;

    public function setSelected(selected:Boolean):void {
        this.selected_ = selected;
        this.redraw();
    }

    public function setLabel(label:String):void {
        this.text_.text = label;
        this.text_.updateMetrics();
    }

    private function redraw():void {
        graphics.clear();
        if (((this.selected_) || (this.pressed_))) {
            graphics.lineStyle(2, 0xFFFFFF);
            graphics.beginFill(0x7F7F7F, 1);
        } else if (this.over_) {
            graphics.lineStyle(2, 0xFFFFFF);
            graphics.beginFill(0, 0);
        } else {
            graphics.lineStyle(1, 0xFFFFFF);
            graphics.beginFill(0, 0);
        }
        graphics.drawRect(0, 0, WIDTH, HEIGHT);
        graphics.endFill();
        graphics.lineStyle();
    }

    private function onMouseOver(event:MouseEvent):void {
        this.over_ = true;
        this.redraw();
    }

    private function onMouseOut(event:MouseEvent):void {
        this.over_ = false;
        this.pressed_ = false;
        this.redraw();
    }

    private function onMouseDown(event:MouseEvent):void {
        this.pressed_ = true;
        this.redraw();
    }

    private function onMouseUp(event:MouseEvent):void {
        this.pressed_ = false;
        this.redraw();
    }

}
}
