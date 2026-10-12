package ui.mediators {
import _F_1.CurrentCharacterScreen;
import _F_1._0H_2;
import _F_1._C_Q_;

import client.game.GameInitData;
import client.signals.typed.GameInitSignal;

import com.company.assembleegameclient.appengine.SavedCharacter;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.util._0A_s;

import env.ServerListState;

import game.signals.AnalyticsEventSignal;
import game.signals.NoArgSignal4;
import game.signals.SpriteSignal;
import game.signals.SpriteSignal2;

import layers.AddViewToLayerSignal;

import offers.IBeginnersOfferModel;

import robotlegs.bender.bundles.mvcs.Mediator;

import services.AnalyticsEvent;

/** Mediator for the character selection screen (_F_1.CurrentCharacterScreen). */
public class CurrentCharacterScreenMediator extends Mediator {

    [Inject]
    public var view:CurrentCharacterScreen;
    [Inject]
    public var serverList:ServerListState;
    [Inject]
    public var addViewToLayerSignal:AddViewToLayerSignal;
    [Inject]
    public var beginnersPackage:IBeginnersOfferModel;
    [Inject]
    public var analyticsEventSignal:AnalyticsEventSignal;
    [Inject]
    public var reloadCharListSignal:NoArgSignal4;
    [Inject]
    public var setScreenSignal:SpriteSignal;
    [Inject]
    public var changeScreenSignal:SpriteSignal2;
    [Inject]
    public var gameInitSignal:GameInitSignal;

    override public function initialize():void {
        this.trackDailyJoinDate();
        this.view.close.add(this.onClose);
        this.view._n7.add(this.onBeginnersOfferClicked);
        this.view.newCharacter.add(this.onNewCharacter);
        this.view._1V_.add(this.onNewCharacter);
        this.view.chooseName.add(this.onChooseName);
        this.view._D_u.add(this.onPlayFirstCharacter);
        this.view.initialize(this.serverList.servers);
        if (this.beginnersPackage.shouldShowNow()) {
            this.addViewToLayerSignal.dispatch();
        }
        if (this.beginnersPackage.isAvailable()) {
            this.view._u_();
        }
    }

    override public function destroy():void {
        this.view.close.remove(this.onClose);
        this.view._n7.remove(this.onBeginnersOfferClicked);
        this.view.newCharacter.remove(this.onNewCharacter);
        this.view.chooseName.remove(this.onChooseName);
        this.view._1V_.remove(this.onNewCharacter);
        this.view._D_u.remove(this.onPlayFirstCharacter);
    }

    /** Sends the "joinDate" analytics event at most once per day. */
    private function trackDailyJoinDate():void {
        var today:String = _0A_s._mP_();
        if (Parameters.data_.lastDailyAnalytics != today) {
            var analyticsEvent:AnalyticsEvent = new AnalyticsEvent();
            analyticsEvent.category = "joinDate";
            analyticsEvent.action = Parameters.data_.joinDate;
            this.analyticsEventSignal.dispatch(analyticsEvent);
            Parameters.data_.lastDailyAnalytics = today;
            Parameters.save();
        }
    }

    private function onNewCharacter():void {
        this.changeScreenSignal.dispatch(new _0H_2());
    }

    private function onBeginnersOfferClicked():void {
        this.addViewToLayerSignal.dispatch();
    }

    private function onClose():void {
        this.changeScreenSignal.dispatch(new _C_Q_());
    }

    private function onChooseName():void {
        this.reloadCharListSignal.dispatch();
        this.setScreenSignal.dispatch(new CurrentCharacterScreen());
    }

    private function onPlayFirstCharacter():void {
        var character:SavedCharacter = this.serverList.servers.savedChars_[0];
        this.serverList.count = character.charId();
        var analyticsEvent:AnalyticsEvent = new AnalyticsEvent();
        analyticsEvent.category = "character";
        analyticsEvent.action = "select";
        analyticsEvent.label = character._jp();
        analyticsEvent.value = character.level();
        this.analyticsEventSignal.dispatch(analyticsEvent);
        var initData:GameInitData = new GameInitData();
        initData.createCharacter = false;
        initData.charId = character.charId();
        initData.isNewGame = true;
        this.gameInitSignal.dispatch(initData);
    }

}
}
