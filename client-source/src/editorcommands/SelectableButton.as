package editorcommands {
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.MouseEvent;

/**
 * Outlined text button with hover, pressed and selected looks.
 * Clicking it calls callback_(this).
 */
public class SelectableButton extends Sprite {

    private static const WIDTH:int = 80;
    private static const HEIGHT:int = 25;

    private static const FONT:String = "Myriad Pro";
    private static const FONT_SIZE:int = 16;
    private static const TEXT_X:int = 2;

    private static const LINE_COLOR:uint = 0xFFFFFF;
    private static const FILL_COLOR_ACTIVE:uint = 0x7F7F7F;

    public var callback_:Function;
    public var value:int;
    private var over_:Boolean = false;
    private var pressed:Boolean = false;
    private var selected_:Boolean = false;
    private var text_:SimpleText;

    public function SelectableButton(label:String, callback:Function, value:int) {
        this.callback_ = callback;
        this.value = value;
        this.text_ = new SimpleText(FONT_SIZE, 0xFFFFFF, false, 0, 0, FONT);
        this.text_.setBold(true);
        this.text_.text = label;
        this.text_.updateMetrics();
        this.text_.x = TEXT_X;
        addChild(this.text_);
        this.redraw();
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
        addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
        addEventListener(MouseEvent.CLICK, this.onClick);
    }

    public function setSelected(selected:Boolean):void {
        this.selected_ = selected;
        this.redraw();
    }

    public function setText(label:String):void {
        this.text_.text = label;
        this.text_.updateMetrics();
    }

    private function redraw():void {
        var active:Boolean = (this.selected_ || this.pressed);
        graphics.clear();
        graphics.lineStyle((active || this.over_) ? 2 : 1, LINE_COLOR);
        if (active) {
            graphics.beginFill(FILL_COLOR_ACTIVE, 1);
        } else {
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
        this.pressed = false;
        this.redraw();
    }

    private function onMouseDown(event:MouseEvent):void {
        this.pressed = true;
        this.redraw();
    }

    private function onMouseUp(event:MouseEvent):void {
        this.pressed = false;
        this.redraw();
    }

    private function onClick(event:MouseEvent):void {
        this.callback_(this);
    }
}
}
