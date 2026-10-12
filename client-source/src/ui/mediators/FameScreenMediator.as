package ui.mediators {
import client.ui.screens.LegendsScreen;
import client.ui.screens.DeathScreen;

import client.tasks.Task;

import env.DeathRecord;
import env.ServerListState;

import game.signals.NoArgSignal2;
import game.signals.SpriteSignal2;
import game.signals.StringSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

import services.LoadFameTask;

/**
 * Mediator for the fame screen (view: _F_1._U_W_).
 * Loads the fame record of a character and feeds it to the view.
 */
public class FameScreenMediator extends Mediator {

    private static const FAME_PAGE:String = "/fame";

    [Inject]
    public var view:DeathScreen;
    [Inject]
    public var serverList:ServerListState;
    [Inject]
    public var deathRecord:DeathRecord;
    [Inject]
    public var changeScreenSignal:SpriteSignal2;
    [Inject]
    public var backSignal:NoArgSignal2;
    [Inject]
    public var trackPageSignal:StringSignal;
    [Inject]
    public var fame:LoadFameTask;

    override public function initialize():void {
        this.view.continueClicked.add(this.onClose);
        this.view.setSkipAnimation(!this.deathRecord._sr);
        if (this.deathRecord.info && this.deathRecord.info.background) {
            this.view.playDeathFade(this.deathRecord.info.background);
        }
        this.trackPageSignal.dispatch(FAME_PAGE);
        this.configureFameRequest();
        this.fame.completed.addOnce(this.onFameLoaded);
        this.fame.start();
    }

    override public function destroy():void {
        this.view.continueClicked.remove(this.onClose);
        if (this.deathRecord.info) {
            if (this.deathRecord.info.background) {
                this.deathRecord.info.background.dispose();
            }
            this.deathRecord.info.background = null;
        }
    }

    /** Own character (just died) vs. a character picked from the legends list. */
    private function configureFameRequest():void {
        if (this.deathRecord._dA_) {
            this.deathRecord._dA_ = false;
            this.fame.accountId = this.serverList.servers.accountId_;
            this.fame.charId = this.serverList.count;
        } else {
            this.fame.accountId = this.deathRecord._Z__;
            this.fame.charId = this.deathRecord._J_u;
        }
    }

    private function onFameLoaded(task:Task, isOk:Boolean, error:String = ""):void {
        this.view.setTitle(this.fame.name, this.fame.level, this.fame.objectType);
        this.view.setDeathInfo(this.fame.createdOn, this.fame.killedBy);
        this.view.setCharacterPortrait(this.fame.character);
        this.view.setStats(this.fame.totalFame, this.fame.xml);
    }

    private function onClose():void {
        if (this.deathRecord._sr) {
            this.changeScreenSignal.dispatch(new LegendsScreen());
        } else {
            this.backSignal.dispatch();
        }
    }

}
}
