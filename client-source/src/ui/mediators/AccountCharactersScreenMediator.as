package ui.mediators {
import client.ui.screens.NewsItem;
import client.ui.screens.DeathScreen;

import env.DeathRecord;

import game.signals.SpriteSignal2;

import robotlegs.bender.bundles.mvcs.Mediator;

/**
 * Mediator for the screen view _F_1._0B_m, which lists one account's characters.
 * Picking a character stores its ids in the DeathRecord and opens the fame screen (_F_1._U_W_).
 */
public class AccountCharactersScreenMediator extends Mediator {

    [Inject]
    public var view:NewsItem;
    [Inject]
    public var deathRecord:DeathRecord;
    [Inject]
    public var changeScreenSignal:SpriteSignal2;

    override public function initialize():void {
        this.view.fameClicked.add(this.onCharacterSelected);
    }

    override public function destroy():void {
        this.view.fameClicked.remove(this.onCharacterSelected);
    }

    private function onCharacterSelected(charId:int):void {
        this.deathRecord._Z__ = this.view.accountId;
        this.deathRecord._J_u = charId;
        this.changeScreenSignal.dispatch(new DeathScreen());
    }

}
}
