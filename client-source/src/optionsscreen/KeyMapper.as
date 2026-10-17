package optionsscreen {

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.utils.getTimer;

import com.company.ui.SimpleText;
import com.company.util.KeyCodes;

/**
 * Button showing the name of a key. Clicking it waits for the next key press and
 * rebinds to that key, dispatching Event.CHANGE.
 */
public class KeyMapper extends Sprite {

    public static const WIDTH:int = 80;
    public static const HEIGHT:int = 32;

    /** The key code currently bound. */
    public var key:uint;

    public var selected_:Boolean;

    /** True while waiting for the player to press a key. */
    public var settingKey:Boolean;

    private var keyText:SimpleText = null;

    public function KeyMapper(key:uint) {
        this.key = key;
        this.selected_ = false;
        this.settingKey = false;
        this.keyText = new SimpleText(16, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.keyText.setBold(true);
        this.keyText.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        addChild(this.keyText);
        this.redraw();
        this.exitSettingMode();
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
    }

    public function value():uint {
        return this.key;
    }

    public function setKey(newKey:uint):void {
        if (newKey == this.key) {
            return;
        }
        this.key = newKey;
        this.setText(KeyCodes.KEY_NAMES[this.key]);
        dispatchEvent(new Event(Event.CHANGE, true));
    }

    private function redraw():void {
        var g:Graphics = graphics;
        g.clear();
        g.lineStyle(2, (this.selected_ || this.settingKey) ? 0xB3B3B3 : 0x4c4c4c);
        g.beginFill(0x2a2a2a);
        g.drawRect(0, 0, WIDTH, HEIGHT);
        g.endFill();
        g.lineStyle();
    }

    private function setText(text:String):void {
        this.keyText.text = text;
        this.keyText.updateMetrics();
        this.keyText.x = (WIDTH / 2) - (this.keyText.width / 2);
        this.keyText.y = ((HEIGHT / 2) - (this.keyText.height / 2)) - 2;
        this.redraw();
    }

    /** Back to the normal state: shows the bound key and waits for a click. */
    private function exitSettingMode():void {
        this.settingKey = false;
        removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        if (stage != null) {
            removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.onStageMouseDown, true);
        }
        this.setText(KeyCodes.KEY_NAMES[this.key]);
        addEventListener(MouseEvent.CLICK, this.onClick);
    }

    /** Waits for a key press; any click elsewhere cancels. */
    private function enterSettingMode():void {
        if (stage == null) {
            return;
        }
        stage.stageFocusRect = false;
        stage.focus = this;
        this.settingKey = true;
        removeEventListener(MouseEvent.CLICK, this.onClick);
        addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
        stage.addEventListener(MouseEvent.MOUSE_DOWN, this.onStageMouseDown, true);
    }

    private function onMouseOver(event:MouseEvent):void {
        this.selected_ = true;
        this.redraw();
    }

    private function onRollOut(event:MouseEvent):void {
        this.selected_ = false;
        this.redraw();
    }

    private function onClick(event:MouseEvent):void {
        this.enterSettingMode();
    }

    /** Blinks the "[Hit Key]" prompt while waiting for input. */
    private function onEnterFrame(event:Event):void {
        var phase:int = getTimer() / 400;
        this.setText((phase % 2) == 0 ? "" : "[Hit Key]");
    }

    private function onKeyDown(event:KeyboardEvent):void {
        event.stopImmediatePropagation();
        this.key = event.keyCode;
        this.exitSettingMode();
        dispatchEvent(new Event(Event.CHANGE, true));
    }

    private function onStageMouseDown(event:MouseEvent):void {
        this.exitSettingMode();
    }

}
}//package optionsscreen
