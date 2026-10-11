// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.ui.frames.CreateGuildFrame

package client.ui.frames {
import com.company.assembleegameclient.game.GameSprite;

import flash.events.MouseEvent;
import flash.events.Event;

import client.events.ResultEvent;

public class CreateGuildFrame extends Frame {

    public function CreateGuildFrame(_arg1:GameSprite) {
        super("Create a new Guild", "Cancel", "Create", "/createGuild");
        this.gs_ = _arg1;
        this.name_ = new TextInput("Guild Name", false, "");
        this.name_.inputText_.restrict = "A-Za-z ";
        this.name_.inputText_.maxChars = 20;
        addInput(this.name_);
        addInfoText("Maximum 20 characters");
        addInfoText("No numbers or punctuation");
        addInfoText("Racism or profanity gets your guild banned");
        Button1.addEventListener(MouseEvent.CLICK, this.onCancel);
        Button2.addEventListener(MouseEvent.CLICK, this.onCreate);
    }
    private var name_:TextInput;
    private var gs_:GameSprite;

    private function onCancel(_arg1:MouseEvent):void {
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function onCreate(_arg1:MouseEvent):void {
        this.gs_.addEventListener(ResultEvent.GUILD_RESULT, this.onGuildResult);
        this.gs_.gsc_._S_W_(this.name_.text());
        disableInput();
    }

    private function onGuildResult(_arg1:ResultEvent):void {
        this.gs_.removeEventListener(ResultEvent.GUILD_RESULT, this.onGuildResult);
        if (_arg1.success_) {
            stage.focus = null;
            dispatchEvent(new Event(Event.COMPLETE));
        } else {
            this.name_.setError(_arg1.errorText_);
            enableInput();
        }
    }

}
}//package client.ui.frames

