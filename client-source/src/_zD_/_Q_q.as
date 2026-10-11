// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_zD_._Q_q

package _zD_ {
import robotlegs.bender.bundles.mvcs.Mediator;

import game.dialogs.DeleteCharacterConfirmation;

import com.company.assembleegameclient.appengine.SavedCharacter;

import game.signals.SavedCharacterSignal;

public class _Q_q extends Mediator {

    [Inject]
    public var view:DeleteCharacterConfirmation;
    [Inject]
    public var character:SavedCharacter;
    [Inject]
    public var deleteCharacter:SavedCharacterSignal;

    override public function initialize():void {
        this.view.deleteCharacter.add(this._pk);
        this.view.cancel.add(this._09m);
        this.view.show(this.character.name(), this.character._jp());
    }

    override public function destroy():void {
        this.view.deleteCharacter.add(this._pk);
        this.view.cancel.add(this._09m);
    }

    private function _09m():void {
        this.view.parent.removeChild(this.view);
    }

    private function _pk():void {
        this._09m();
        this.deleteCharacter.dispatch(this.character);
    }

}
}//package _zD_

