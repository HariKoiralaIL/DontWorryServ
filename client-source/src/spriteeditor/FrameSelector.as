package spriteeditor {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

/** Row of buttons for choosing which animation frame is being edited. Dispatches CHANGE. */
public class FrameSelector extends Sprite {

    public static const STAND:String = "Stand";
    public static const WALK1:String = "Walk 1";
    public static const WALK2:String = "Walk 2";
    public static const ATTACK1:String = "Attack 1";
    public static const ATTACK2:String = "Attack 2";
    public static const FRAMES:Vector.<String> = new <String>[STAND, WALK1, WALK2, ATTACK1, ATTACK2];

    public function FrameSelector() {
        var frame:String;
        var button:FrameButton;
        this.buttons_ = new Vector.<FrameButton>();
        super();
        var buttonX:int;
        for each (frame in FRAMES) {
            button = new FrameButton(frame);
            button.addEventListener(MouseEvent.CLICK, this.onButtonClick);
            button.x = buttonX;
            buttonX = (buttonX + (button.width + 5));
            addChild(button);
            this.buttons_.push(button);
        }
        this.setSelected(this.buttons_[0]);
    }
    public var buttons_:Vector.<FrameButton>;
    public var selected_:FrameButton = null;

    public function getSelectedFrame():String {
        return (this.selected_.label_);
    }

    private function setSelected(button:FrameButton):void {
        if (this.selected_ != null) {
            this.selected_.setSelected(false);
        }
        this.selected_ = button;
        this.selected_.setSelected(true);
        dispatchEvent(new Event(Event.CHANGE));
    }

    private function onButtonClick(event:MouseEvent):void {
        var button:FrameButton = (event.target as FrameButton);
        this.setSelected(button);
    }

}
}
