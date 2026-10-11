// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_zD_._9M_

package _zD_ {
import robotlegs.bender.bundles.mvcs.Mediator;

import com.company.assembleegameclient.screens.charrects.CurrentCharacterRect;

import _U_5._7e;

import client.signals.typed.GameInitSignal;

import _U_5._V_l;

import com.company.assembleegameclient.appengine.SavedCharacter;

import services.AnalyticsEvent;

import client.game.GameInitData;

public class _9M_ extends Mediator {

    [Inject]
    public var view:CurrentCharacterRect;
    [Inject]
    public var _o_:_7e;
    [Inject]
    public var _D_u:GameInitSignal;
    [Inject]
    public var _0K_q:_V_l;

    override public function initialize():void {
        this.view.selected.add(this._0A_U_);
        this.view.deleteCharacter.add(this._pk);
    }

    override public function destroy():void {
        this.view.selected.remove(this._0A_U_);
        this.view.deleteCharacter.remove(this._pk);
    }

    private function _0A_U_(_arg1:SavedCharacter):void {
        this._7D_(_arg1);
        this._nz(_arg1);
    }

    private function _7D_(_arg1:SavedCharacter):void {
        var _local2:AnalyticsEvent = new AnalyticsEvent();
        _local2.category = "character";
        _local2.action = "select";
        _local2.label = _arg1._jp();
        _local2.value = _arg1.level();
        this._o_.dispatch(_local2);
    }

    private function _nz(_arg1:SavedCharacter):void {
        var _local2:GameInitData = new GameInitData();
        _local2.createCharacter = false;
        _local2.charId = _arg1.charId();
        _local2.isNewGame = true;
        this._D_u.dispatch(_local2);
    }

    private function _pk(_arg1:SavedCharacter):void {
        this._0K_q.dispatch(_arg1);
    }

}
}//package _zD_

