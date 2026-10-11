// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.ui.frames.PaymentMethodItem

package client.ui.frames {
import flash.display.Sprite;

import client.ui.controls.ISelectableItem;

import com.company.ui.SimpleText;

import client.ui.controls.CheckBoxIcon;

import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

public class PaymentMethodItem extends Sprite implements ISelectableItem {

    public static const HEIGHT:int = 28;

    public function PaymentMethodItem(_arg1:String) {
        this.label = _arg1;
        this.createCheckBox();
        this.createLabel();
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
    }
    private var label:String;
    private var text:SimpleText;
    private var checkBox:CheckBoxIcon;

    public function getValue():String {
        return (this.label);
    }

    public function setSelected(_arg1:Boolean):void {
        this.checkBox.setSelected(_arg1);
    }

    private function createCheckBox():void {
        this.checkBox = new CheckBoxIcon();
        addChild(this.checkBox);
    }

    private function createLabel():void {
        this.text = new SimpleText(18, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.text.setBold(true);
        this.text.text = this.label;
        this.text.updateMetrics();
        this.text.filters = [new DropShadowFilter(0, 0, 0)];
        this.text.x = (HEIGHT + 8);
        addChild(this.text);
    }

    private function onMouseOver(_arg1:MouseEvent):void {
        this.text.setColor(16768133);
    }

    private function onRollOut(_arg1:MouseEvent):void {
        this.text.setColor(0xFFFFFF);
    }

}
}//package client.ui.frames

