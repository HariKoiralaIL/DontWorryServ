package events {

import flash.events.Event;

import com.company.assembleegameclient.appengine.SavedCharacter;

/**
 * Dispatched when the player requests deletion of a saved character.
 */
public class DeleteCharacterEvent extends Event {

    public static const DELETE_CHARACTER_EVENT:String = "DELETE_CHARACTER_EVENT";

    public var savedChar_:SavedCharacter;

    public function DeleteCharacterEvent(savedChar:SavedCharacter) {
        super(DELETE_CHARACTER_EVENT);
        this.savedChar_ = savedChar;
    }

    override public function clone():Event {
        return new DeleteCharacterEvent(this.savedChar_);
    }

}
}
