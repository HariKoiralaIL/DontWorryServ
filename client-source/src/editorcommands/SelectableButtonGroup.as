package editorcommands {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.utils.Dictionary;

/**
 * Vertical stack of SelectableButtons where one is selected at a time.
 * Each button can also be triggered with a keyboard key.
 * Subclasses build the list with addButton() and addSpacer().
 */
public class SelectableButtonGroup extends Sprite {

    private static const ROW_HEIGHT:int = 30;

    private var hotkeys:Dictionary;
    private var nextY:int = 0;
    private var selected_:SelectableButton = null;

    public function SelectableButtonGroup() {
        this.hotkeys = new Dictionary();
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    public function getSelectedValue():int {
        return this.selected_.value;
    }

    public function selectByValue(value:int):void {
        var button:SelectableButton;
        var index:int = 0;
        while (index < numChildren) {
            button = (getChildAt(index) as SelectableButton);
            if (button != null) {
                if (button.value == value) {
                    this.setSelected(button);
                    return;
                }
            }
            index++;
        }
    }

    protected function setSelected(button:SelectableButton):void {
        if (this.selected_ != null) {
            this.selected_.setSelected(false);
        }
        this.selected_ = button;
        this.selected_.setSelected(true);
    }

    protected function addButton(label:String, keyCode:int, callback:Function, value:int):void {
        var button:SelectableButton = new SelectableButton(label, callback, value);
        button.y = this.nextY;
        addChild(button);
        this.hotkeys[keyCode] = button;
        if (this.selected_ == null) {
            this.setSelected(button);
        }
        this.nextY = (this.nextY + ROW_HEIGHT);
    }

    protected function addSpacer():void {
        this.nextY = (this.nextY + ROW_HEIGHT);
    }

    private function onAddedToStage(event:Event):void {
        stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
    }

    private function onRemovedFromStage(event:Event):void {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
    }

    private function onKeyDown(event:KeyboardEvent):void {
        if (stage.focus != null) {
            return;
        }
        var button:SelectableButton = this.hotkeys[event.keyCode];
        if (button == null) {
            return;
        }
        button.callback_(button);
    }
}
}
