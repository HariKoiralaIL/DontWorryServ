package ui.mediators {
import _F_1._3V_;
import _F_1._U_W_;

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
    public var view:_U_W_;
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
        this.view._0M_S_.add(this.onClose);
        this.view._yK_(!this.deathRecord._sr);
        if (this.deathRecord.info && this.deathRecord.info.background) {
            this.view._K_f(this.deathRecord.info.background);
        }
        this.trackPageSignal.dispatch(FAME_PAGE);
        this.configureFameRequest();
        this.fame.completed.addOnce(this.onFameLoaded);
        this.fame.start();
    }

    override public function destroy():void {
        this.view._0M_S_.remove(this.onClose);
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
        this.view._tC_(this.fame.name, this.fame.level, this.fame.objectType);
        this.view._ec(this.fame.createdOn, this.fame.killedBy);
        this.view._sQ_(this.fame.character);
        this.view._0__(this.fame.totalFame, this.fame.xml);
    }

    private function onClose():void {
        if (this.deathRecord._sr) {
            this.changeScreenSignal.dispatch(new _3V_());
        } else {
            this.backSignal.dispatch();
        }
    }

}
}
