package picturebrowser {
import com.company.ui.SimpleText;

import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.events.FocusEvent;
import flash.filters.DropShadowFilter;

/**
 * Text input for comma-separated tags, with a placeholder
 * that is hidden while the field has focus.
 */
public class TagSearchBox extends Sprite {

    public static const WIDTH:int = 200;
    public static const HEIGHT:int = 30;

    private static const FONT:String = "Myriad Pro";
    private static const INPUT_FONT_SIZE:int = 16;
    private static const INPUT_COLOR:uint = 0xB3B3B3;
    private static const INPUT_X:int = 2;
    private static const MAX_CHARS:int = 256;
    private static const ALLOWED_CHARS:String = "a-z0-9 ,";

    private static const BORDER_THICKNESS:int = 2;
    private static const BORDER_COLOR:uint = 0x454545;
    private static const FILL_COLOR:uint = 0x333333;

    private static const PLACEHOLDER_TEXT:String = '<p align="center">tags (comma-separated)</p>';
    private static const PLACEHOLDER_FONT_SIZE:int = 14;
    private static const PLACEHOLDER_COLOR:uint = 0x939393;
    private static const PLACEHOLDER_Y_OFFSET:int = 2;

    public var inputText:SimpleText;
    public var placeholder:SimpleText;

    public function TagSearchBox() {
        this.inputText = new SimpleText(INPUT_FONT_SIZE, INPUT_COLOR, true, WIDTH, HEIGHT, FONT);
        this.inputText.border = false;
        this.inputText.maxChars = MAX_CHARS;
        this.inputText.restrict = ALLOWED_CHARS;
        this.inputText.updateMetrics();
        this.inputText.x = INPUT_X;
        addChild(this.inputText);

        graphics.lineStyle(BORDER_THICKNESS, BORDER_COLOR, 1, false, LineScaleMode.NORMAL,
                CapsStyle.ROUND, JointStyle.ROUND);
        graphics.beginFill(FILL_COLOR, 1);
        graphics.drawRect(0, -2, WIDTH, HEIGHT);
        graphics.endFill();
        graphics.lineStyle();

        this.inputText.addEventListener(FocusEvent.FOCUS_IN, this.onFocusIn);
        this.inputText.addEventListener(FocusEvent.FOCUS_OUT, this.onFocusOut);

        this.placeholder = new SimpleText(PLACEHOLDER_FONT_SIZE, PLACEHOLDER_COLOR, false, WIDTH, HEIGHT, FONT);
        this.placeholder.htmlText = PLACEHOLDER_TEXT;
        this.placeholder.updateMetrics();
        this.placeholder.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 1)];
        this.placeholder.y = ((HEIGHT / 2) - (this.placeholder.height / 2)) + PLACEHOLDER_Y_OFFSET;
        addChild(this.placeholder);
    }

    public function getTags():String {
        return this.inputText.text;
    }

    private function onFocusIn(event:FocusEvent):void {
        if (contains(this.placeholder)) {
            removeChild(this.placeholder);
        }
    }

    private function onFocusOut(event:FocusEvent):void {
        if (!contains(this.placeholder) && this.inputText.text == "") {
            addChild(this.placeholder);
        }
    }
}
}
