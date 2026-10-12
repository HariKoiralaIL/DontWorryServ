// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.ui.frames.NewAccountNameFrame

package client.ui.frames {
import com.company.assembleegameclient.appengine.AppEngineClient;
import com.company.util._H_V_;

import flash.events.KeyboardEvent;

import flash.events.MouseEvent;
import flash.events.Event;

import com.company.assembleegameclient.parameters.Parameters;

import events.GenericDataEvent;
import events.TextErrorEvent;

import com.company.util._H_U_;

import account.Account;

public class NewAccountNameFrame extends Frame {

    public function NewAccountNameFrame() {
        super("Choose a unique account name", "Cancel", "Choose", "/newChooseName");
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
    private var request:AppEngineClient = null;

    private function onCancel(_arg1:MouseEvent):void {
        stage.focus = null;
        dispatchEvent(new Event(Event.CANCEL));
    }

    private function onChoose(_arg1:MouseEvent):void {
        if (this.name_.text().length < 1) {
            this.name_.setError("Name too short");
            return;
        }
        var _local2:AppEngineClient = new AppEngineClient(Parameters.serverAddress(), "/account", true);
        _local2.addEventListener(GenericDataEvent.GENERIC_DATA, this.onNameSet);
        _local2.addEventListener(TextErrorEvent.TEXT_ERROR, this.onNameError);
        var _local3:Object = {"name": this.name_.text()};
        _H_U_._t2(_local3, Account.getInstance().credentials());
        _local2.sendRequest("setName", _local3);
        disableInput();
    }

    private function onNameSet(_arg1:GenericDataEvent):void {
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function onNameError(_arg1:TextErrorEvent):void {
        this.name_.setError(_arg1.text);
        enableInput();
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

