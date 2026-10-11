// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.ui.frames.ChangeNameFrame

package client.ui.frames {
import com.company.assembleegameclient.game.GameSprite;
import com.company.util._H_V_;

import flash.events.KeyboardEvent;

import flash.events.MouseEvent;
import flash.events.Event;

import client.events.NameResultEvent;

import com.company.googleanalytics.GA;
import com.company.assembleegameclient.parameters.Parameters;

public class ChangeNameFrame extends Frame {

    public function ChangeNameFrame(_arg1:GameSprite, _arg2:Boolean) {
        super("Choose a unique account name", "Cancel", "Choose", "/chooseName");
        this.gs_ = _arg1;
        this.isPurchase = _arg2;
        this.name_ = new TextInput("Name", false, "");
        this.name_.inputText_.restrict = "A-Za-z";
        this.name_.inputText_.maxChars = 10;
        addInput(this.name_);
        addInfoText("Maximum 10 characters");
        addInfoText("No numbers, spaces or punctuation");
        addInfoText("Racism or profanity gets you banned");
        Button1.addEventListener(MouseEvent.CLICK, this.onCancel);
        Button2.addEventListener(MouseEvent.CLICK, this.onChoose);
        this.addEventListener(Event.ADDED_TO_STAGE, this.onAdded);
        this.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemoved);
    }
    private var name_:TextInput;
    private var gs_:GameSprite;
    private var isPurchase:Boolean;

    public function onNameResult(_arg1:NameResultEvent):void {
        this.gs_.removeEventListener(NameResultEvent.NAMERESULTEVENT, this.onNameResult);
        if (_arg1.nameResult.success_) {
            /*if (this.isPurchase) {
                GA.global().trackEvent("credits", ((this.gs_.charList_.converted_) ? "buyConverted" : "buy"), "Name Change", Parameters._0u);
            }*/
            this.gs_.charList_.name_ = this.name_.text();
            this.gs_._V_1._02y.setName(this.name_.text());
            stage.focus = null;
            dispatchEvent(new Event(Event.COMPLETE));
        } else {
            this.name_.setError(_arg1.nameResult.errorText_);
            enableInput();
        }
    }

    private function onCancel(_arg1:MouseEvent):void {
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function onChoose(_arg1:MouseEvent):void {
        this.gs_.addEventListener(NameResultEvent.NAMERESULTEVENT, this.onNameResult);
        this.gs_.gsc_._K_Q_(this.name_.text());
        disableInput();
    }

    private function onAdded(e:Event):void {
        this.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyPressed);
    }

    private function onRemoved(e:Event):void {
        this.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyPressed);
    }

    private function onKeyPressed(e:KeyboardEvent):void {

        if (e.keyCode == _H_V_.ENTER) {
            this.onChoose(null);
        }
    }

}
}//package client.ui.frames

