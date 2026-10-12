package com.company.assembleegameclient.tutorial {

public class Step {

    public var text_:String;
    public var action_:String;
    public var boxes_:Vector.<UIDrawBox>;
    public var arrows_:Vector.<UIDrawArrow>;
    public var requirements_:Vector.<Requirement>;
    /** getTimer() value when all requirements were first met; 0 while unmet. */
    public var startTime_:int = 0;

    public function Step(xml:XML) {
        this.boxes_ = new Vector.<UIDrawBox>();
        this.arrows_ = new Vector.<UIDrawArrow>();
        this.requirements_ = new Vector.<Requirement>();
        super();
        for each (var boxXml:XML in xml.UIDrawBox) {
            this.boxes_.push(new UIDrawBox(boxXml));
        }
        for each (var arrowXml:XML in xml.UIDrawArrow) {
            this.arrows_.push(new UIDrawArrow(arrowXml));
        }
        for each (var reqXml:XML in xml.Requirement) {
            this.requirements_.push(new Requirement(reqXml));
        }
    }

    public function toString():String {
        return "[" + this.text_ + "]";
    }

}
}
