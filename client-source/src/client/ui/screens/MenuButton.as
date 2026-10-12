package client.ui.screens {
import com.company.audio.SoundEffects;
import com.company.ui.SimpleText;
import com.company.util.MoreColorUtil;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;
import flash.utils.getTimer;

/**
 * Large bold text button used on the menu screens. Highlights on hover and can
 * optionally pulse (used for the main "play" button).
 */
public class MenuButton extends Sprite {

    protected static const HOVER_TRANSFORM:ColorTransform = new ColorTransform(1, (220 / 0xFF), (133 / 0xFF));
    private static const DISABLED_COLOR:uint = 0x363636;

    protected var colorTransform_:ColorTransform = null;
    protected var text_:SimpleText;
    protected var pulse_:Boolean;

    private var baseWidth:Number;
    private var baseHeight:Number;
    private var active:Boolean;

    public function MenuButton(label:String, fontSize:int, pulse:Boolean) {
        name = label;
        this.text_ = new SimpleText(fontSize, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.text_.setBold(true);
        this.text_.text = label.toLowerCase();
        this.text_.updateMetrics();
        this.text_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        addChild(this.text_);
        this.pulse_ = pulse;
        this.baseWidth = width;
        this.baseHeight = height;
        this.activate();
    }

    public function activate():void {
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        addEventListener(MouseEvent.CLICK, this.onClick);
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        this.active = true;
    }

    public function deactivate():void {
        var disabled:ColorTransform = new ColorTransform();
        disabled.color = DISABLED_COLOR;
        this.setColorTransform(disabled);
        removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        removeEventListener(MouseEvent.CLICK, this.onClick);
        removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        this.active = false;
    }

    public function setColorTransform(transform:ColorTransform):void {
        if (transform == this.colorTransform_) {
            return;
        }
        this.colorTransform_ = transform;
        if (this.colorTransform_ == null) {
            this.text_.transform.colorTransform = MoreColorUtil.identity;
        } else {
            this.text_.transform.colorTransform = this.colorTransform_;
        }
    }

    public function setText(value:String):void {
        this.text_.text = value.toLowerCase();
        this.text_.updateMetrics();
    }

    protected function onMouseOver(event:MouseEvent):void {
        this.setColorTransform(HOVER_TRANSFORM);
    }

    protected function onMouseOut(event:MouseEvent):void {
        this.setColorTransform(null);
    }

    protected function onClick(event:MouseEvent):void {
        SoundEffects.play("button_click");
    }

    private function onAddedToStage(event:Event):void {
        if (this.pulse_) {
            addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        }
    }

    private function onRemovedFromStage(event:Event):void {
        if (this.pulse_) {
            removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        }
    }

    private function onEnterFrame(event:Event):void {
        var scale:Number = (1.05 + (0.05 * Math.sin((getTimer() / 200))));
        this.text_.scaleX = scale;
        this.text_.scaleY = scale;
        this.text_.x = ((this.baseWidth / 2) - (this.text_.width / 2));
        this.text_.y = ((this.baseHeight / 2) - (this.text_.height / 2));
    }

}
}
