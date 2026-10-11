// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_zD_._2H_

package _zD_ {
import robotlegs.bender.bundles.mvcs.Mediator;

import _F_1._0H_2;

import env.ServerListState;

import game.signals.SpriteSignal2;

import client.signals.typed.GameInitSignal;

import _F_1.CurrentCharacterScreen;

import com.company.assembleegameclient.parameters.Parameters;

import client.game.GameInitData;

public class _2H_ extends Mediator {

    [Inject]
    public var view:_0H_2;
    [Inject]
    public var _eJ_:ServerListState;
    [Inject]
    public var _T__:SpriteSignal2;
    [Inject]
    public var _D_u:GameInitSignal;

    override public function initialize():void {
        this.view.play.add(this._fN_);
        this.view.close.add(this._of);
        this.view.initialize(this._eJ_.servers);
    }

    override public function destroy():void {
        this.view.play.remove(this._fN_);
        this.view.close.remove(this._fN_);
    }

    private function _of():void {
        this._T__.dispatch(new CurrentCharacterScreen());
    }

    private function _fN_(_arg1:int):void {
        Parameters.data_.playerObjectType = _arg1;
        Parameters.save();
        var _local2:GameInitData = new GameInitData();
        _local2.createCharacter = true;
        _local2.charId = this._eJ_.servers.nextCharId_;
        _local2.keyTime = -1;
        this._D_u.dispatch(_local2);
    }

}
}//package _zD_

