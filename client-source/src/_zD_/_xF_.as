// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_zD_._xF_

package _zD_ {
import robotlegs.bender.bundles.mvcs.Mediator;

import _F_1.CurrentCharacterScreen;

import env.ServerListState;

import layers.AddViewToLayerSignal;

import offers.IBeginnersOfferModel;

import game.signals.AnalyticsEventSignal;
import game.signals.NoArgSignal4;
import game.signals.SpriteSignal;
import game.signals.SpriteSignal2;

import client.signals.typed.GameInitSignal;

import services.AnalyticsEvent;

import com.company.util._0A_s;
import com.company.assembleegameclient.parameters.Parameters;

import _F_1._0H_2;
import _F_1._C_Q_;

import com.company.assembleegameclient.appengine.SavedCharacter;

import client.game.GameInitData;

public class _xF_ extends Mediator {

    [Inject]
    public var view:CurrentCharacterScreen;
    [Inject]
    public var _eJ_:ServerListState;
    [Inject]
    public var _n7:AddViewToLayerSignal;
    [Inject]
    public var beginnersPackage:IBeginnersOfferModel;
    [Inject]
    public var _o_:AnalyticsEventSignal;
    [Inject]
    public var _0D_p:NoArgSignal4;
    [Inject]
    public var _0_b:SpriteSignal;
    [Inject]
    public var _T__:SpriteSignal2;
    [Inject]
    public var _D_u:GameInitSignal;

    override public function initialize():void {
        this._T_Q_();
        this.view.close.add(this._of);
        this.view._n7.add(this._yk);
        this.view.newCharacter.add(this._8b);
        this.view._1V_.add(this._8b);
        this.view.chooseName.add(this._08d);
        this.view._D_u.add(this._I_S_);
        this.view.initialize(this._eJ_.servers);
        if (this.beginnersPackage.shouldShowNow()) {
            this._n7.dispatch();
        }
        if (this.beginnersPackage.isAvailable()) {
            this.view._u_();
        }
    }

    override public function destroy():void {
        this.view.close.remove(this._of);
        this.view._n7.remove(this._yk);
        this.view.newCharacter.remove(this._8b);
        this.view.chooseName.remove(this._08d);
        this.view._1V_.remove(this._8b);
        this.view._D_u.remove(this._I_S_);
    }

    private function _T_Q_():void {
        var _local2:AnalyticsEvent;
        var _local1:String = _0A_s._mP_();
        if (Parameters.data_.lastDailyAnalytics != _local1) {
            _local2 = new AnalyticsEvent();
            _local2.category = "joinDate";
            _local2.action = Parameters.data_.joinDate;
            this._o_.dispatch(_local2);
            Parameters.data_.lastDailyAnalytics = _local1;
            Parameters.save();
        }
    }

    private function _8b():void {
        this._T__.dispatch(new _0H_2());
    }

    private function _yk():void {
        this._n7.dispatch();
    }

    private function _of():void {
        this._T__.dispatch(new _C_Q_());
    }

    private function _08d():void {
        this._0D_p.dispatch();
        this._0_b.dispatch(new CurrentCharacterScreen());
    }

    private function _I_S_():void {
        var _local1:SavedCharacter = this._eJ_.servers.savedChars_[0];
        this._eJ_.count = _local1.charId();
        var _local2:AnalyticsEvent = new AnalyticsEvent();
        _local2.category = "character";
        _local2.action = "select";
        _local2.label = _local1._jp();
        _local2.value = _local1.level();
        this._o_.dispatch(_local2);
        var _local3:GameInitData = new GameInitData();
        _local3.createCharacter = false;
        _local3.charId = _local1.charId();
        _local3.isNewGame = true;
        this._D_u.dispatch(_local3);
    }

}
}//package _zD_

