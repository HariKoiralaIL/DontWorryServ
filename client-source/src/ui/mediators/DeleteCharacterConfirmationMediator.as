package ui.mediators {
import com.company.assembleegameclient.appengine.SavedCharacter;

import game.dialogs.DeleteCharacterConfirmation;
import game.signals.SavedCharacterSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

/** Mediator for the "delete character?" confirmation dialog. */
public class DeleteCharacterConfirmationMediator extends Mediator {

    [Inject]
    public var view:DeleteCharacterConfirmation;
    [Inject]
    public var character:SavedCharacter;
    [Inject]
    public var deleteCharacterSignal:SavedCharacterSignal;

    override public function initialize():void {
        this.view.deleteCharacter.add(this.onDeleteConfirmed);
        this.view.cancel.add(this.closeDialog);
        this.view.show(this.character.name(), this.character.displayId());
    }

    override public function destroy():void {
        this.view.deleteCharacter.remove(this.onDeleteConfirmed);
        this.view.cancel.remove(this.closeDialog);
    }

    private function closeDialog():void {
        this.view.parent.removeChild(this.view);
    }

    private function onDeleteConfirmed():void {
        this.closeDialog();
        this.deleteCharacterSignal.dispatch(this.character);
    }

}
}
