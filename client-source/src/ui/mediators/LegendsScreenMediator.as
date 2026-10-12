package ui.mediators {
import client.ui.screens.CurrentCharacterScreen;
import client.ui.screens.LegendsScreen;
import client.ui.screens.TitleScreen;
import client.ui.screens.DeathScreen;

import com.company.assembleegameclient.appengine.AppEngineClient;
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
    public var view:LegendsScreen;
    [Inject]
    public var serverList:ServerListState;
    [Inject]
    public var deathRecord:DeathRecord;
    [Inject]
    public var reloadCharListSignal:NoArgSignal4;
    [Inject]
    public var setScreenSignal:SpriteSignal;

    private var timespan:String;
    private var appEngineClient:AppEngineClient;

    override public function initialize():void {
        this.timespan = DEFAULT_TIMESPAN;
        this.appEngineClient = new AppEngineClient(Parameters._fK_(), "/fame", true, 2);
        this.appEngineClient.addEventListener(GenericDataEvent.GENERIC_DATA, this.onLegendsLoaded);
        this.appEngineClient.addEventListener(TextErrorEvent.TEXT_ERROR, this.onLoadError);
        this.view.close.add(this.onClose);
        this.view.timespanSelected.add(this.onTimespanChanged);
        this.view.characterSelected.add(this.onEntrySelected);
        this.loadLegends();
        this.view.initialize();
    }

    override public function destroy():void {
        this.view.close.remove(this.onClose);
        this.view.timespanSelected.remove(this.onTimespanChanged);
        this.view.characterSelected.remove(this.onEntrySelected);
    }

    private function onClose():void {
        if (this.deathRecord._sr) {
            this.deathRecord._sr = false;
            this.reloadCharListSignal.dispatch();
            this.setScreenSignal.dispatch(new CurrentCharacterScreen());
        } else {
            this.setScreenSignal.dispatch(new TitleScreen());
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
        this.setScreenSignal.dispatch(new DeathScreen());
    }

    public function onLegendsLoaded(event:GenericDataEvent):void {
        this.view.showFameList(XML(event.data));
    }

    private function onLoadError(event:TextErrorEvent):void {
        this.view.onLoadError(event.text);
    }

}
}
