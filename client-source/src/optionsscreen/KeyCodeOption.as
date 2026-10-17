package optionsscreen {

import flash.events.Event;

import com.company.assembleegameclient.parameters.Parameters;
import com.company.util.MoreColorUtil;

/** An option that binds a keyboard key (shown as a KeyMapper button). */
public class KeyCodeOption extends BaseOption {

    private var keyMapper:KeyMapper;
    private var disabled:Boolean;

    public function KeyCodeOption(paramName:String, label:String, description:String, disabled:Boolean = false) {
        super(paramName, label, description);
        this.keyMapper = new KeyMapper(Parameters.data_[this.paramName]);
        this.keyMapper.addEventListener(Event.CHANGE, this.onChange);
        addChild(this.keyMapper);
        this.setDisabled(disabled);
    }

    override public function refresh():void {
        this.keyMapper.setKey(Parameters.data_[this.paramName]);
    }

    /** Greys the option out and stops it reacting to the mouse. */
    public function setDisabled(disabled:Boolean):void {
        this.disabled = disabled;
        transform.colorTransform = this.disabled ? MoreColorUtil.GRAY_60 : MoreColorUtil.identity;
        mouseEnabled = !this.disabled;
        mouseChildren = !this.disabled;
    }

    private function onChange(event:Event):void {
        Parameters.setKey(this.paramName, this.keyMapper.value());
        Parameters.save();
    }

}
}//package optionsscreen
