package ui.mediators {
import _F_1.CurrentCharacterScreen;
import _F_1._3V_;
import _F_1._C_Q_;
import _F_1._U_W_;

import com.company.assembleegameclient.appengine._0B_u;
import com.company.assembleegameclient.parameters.Parameters;

import env.DeathRecord;
import env.ServerListState;

import events.GenericDataEvent;
import events.TextErrorEvent;

import game.signals.NoArgSignal4;
import game.signals.SpriteSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

/**
 * Mediator for the legends screen (_F_1._3V_): loads the fame list from the server
 * for the selected timespan and opens the fame screen (_F_1._U_W_) for a picked entry.
 */
public class LegendsScreenMediator extends Mediator {

    private static const DEFAULT_TIMESPAN:String = "week";
    private static const NO_CHARACTER:int = -1;

    [Inject]
    public var view:_3V_;
    [Inject]
    public var serverList:ServerListState;
    [Inject]
    public var deathRecord:DeathRecord;
    [Inject]
    public var reloadCharListSignal:NoArgSignal4;
    [Inject]
    public var setScreenSignal:SpriteSignal;

    private var timespan:String;
    private var appEngineClient:_0B_u;

    override public function initialize():void {
        this.timespan = DEFAULT_TIMESPAN;
        this.appEngineClient = new _0B_u(Parameters._fK_(), "/fame", true, 2);
        this.appEngineClient.addEventListener(GenericDataEvent.GENERIC_DATA, this.onLegendsLoaded);
        this.appEngineClient.addEventListener(TextErrorEvent.TEXT_ERROR, this.onLoadError);
        this.view.close.add(this.onClose);
        this.view._8m.add(this.onTimespanChanged);
        this.view._T_c.add(this.onEntrySelected);
        this.loadLegends();
        this.view.initialize();
    }

    override public function destroy():void {
        this.view.close.remove(this.onClose);
        this.view._8m.remove(this.onTimespanChanged);
        this.view._T_c.remove(this.onEntrySelected);
    }

    private function onClose():void {
        if (this.deathRecord._sr) {
            this.deathRecord._sr = false;
            this.reloadCharListSignal.dispatch();
            this.setScreenSignal.dispatch(new CurrentCharacterScreen());
        } else {
            this.setScreenSignal.dispatch(new _C_Q_());
        }
    }

    private function onTimespanChanged(timespan:String):void {
        this.timespan = timespan;
        this.loadLegends();
    }

    private function loadLegends():void {
        var accountId:int = this.serverList.servers.accountId_;
        var charId:int = (accountId != -1 && this.deathRecord._sr) ? this.deathRecord._J_u : NO_CHARACTER;
        this.appEngineClient.sendRequest("list", {
            "timespan": this.timespan,
            "accountId": accountId,
            "charId": charId
        });
    }

    private function onEntrySelected(accountId:int, charId:int):void {
        this.deathRecord._sr = false;
        this.deathRecord._Z__ = accountId;
        this.deathRecord._J_u = charId;
        this.setScreenSignal.dispatch(new _U_W_());
    }

    public function onLegendsLoaded(event:GenericDataEvent):void {
        this.view._0d(XML(event.data));
    }

    private function onLoadError(event:TextErrorEvent):void {
        this.view._cC_(event.text);
    }

}
}
