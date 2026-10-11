package optionsscreen {

import flash.events.Event;

import com.company.assembleegameclient.parameters.Parameters;

/** An option whose value is picked from a fixed list by clicking through it (e.g. On/Off). */
public class ChoiceOption extends BaseOption {

    private var callback_:Function;
    private var chooser:Chooser;

    /**
     * @param labels   text shown for each choice
     * @param values   the value stored in Parameters.data_ for each choice (same order as labels)
     * @param callback optional; called after the value changes
     */
    public function ChoiceOption(paramName:String, labels:Vector.<String>, values:Array,
                                 label:String, description:String, callback:Function) {
        super(paramName, label, description);
        this.callback_ = callback;
        this.chooser = new Chooser(labels, values, Parameters.data_[this.paramName]);
        this.chooser.addEventListener(Event.CHANGE, this.onChange);
        addChild(this.chooser);
    }

    override public function refresh():void {
        this.chooser.setValue(Parameters.data_[this.paramName]);
    }

    private function onChange(event:Event):void {
        Parameters.data_[this.paramName] = this.chooser.value();
        Parameters.save();
        if (this.callback_ != null) {
            this.callback_();
        }
    }

}
}//package optionsscreen
