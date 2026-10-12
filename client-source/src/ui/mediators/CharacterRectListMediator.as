package ui.mediators {
import _F_1._0H_2;

import com.company.assembleegameclient.screens.charrects.CharacterRectList;

import game.signals.SpriteSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

/** Mediator for the character list; the "new character" row opens the new-character screen (_F_1._0H_2). */
public class CharacterRectListMediator extends Mediator {

    [Inject]
    public var view:CharacterRectList;
    [Inject]
    public var setScreenSignal:SpriteSignal;

    override public function initialize():void {
        this.view.newCharacter.add(this.onNewCharacter);
    }

    override public function destroy():void {
        this.view.newCharacter.remove(this.onNewCharacter);
    }

    private function onNewCharacter():void {
        this.setScreenSignal.dispatch(new _0H_2());
    }

}
}
