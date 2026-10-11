package services {

import flash.events.Event;

import com.company.assembleegameclient.appengine.SavedCharacter;
import com.company.assembleegameclient.appengine._2n;

import client.tasks.Task;
import events.TextErrorEvent;

/**
 * Task that deletes the injected character on the server.
 *
 * NOTE: the base class _zU_ provides startTask() and the completion method
 * _C_t(success, errorText); both keep their obfuscated names for now.
 */
public class DeleteCharacterTask extends Task {

    [Inject]
    public var character:SavedCharacter;

    override protected function startTask():void {
        var client:_2n = new _2n(2);
        client.addEventListener(Event.COMPLETE, this.handleDeleted);
        client.addEventListener(TextErrorEvent.TEXT_ERROR, this.handleError);
        client.deleteCharacter(this.character.charId());
    }

    private function handleDeleted(event:Event):void {
        complete(true, "");
    }

    private function handleError(event:TextErrorEvent):void {
        complete(false, "error: Unable to delete character");
    }

}
}
