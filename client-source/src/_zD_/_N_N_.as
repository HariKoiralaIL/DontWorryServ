// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_zD_._N_N_

package _zD_ {
import robotlegs.bender.bundles.mvcs.Mediator;

import _F_1._01_;

import env.ServerListState;

import game.signals.SpriteSignal2;

import _F_1._C_Q_;

public class _N_N_ extends Mediator {

    [Inject]
    public var view:_01_;
    [Inject]
    public var _eJ_:ServerListState;
    [Inject]
    public var _T__:SpriteSignal2;

    override public function initialize():void {
        this.view._4s.add(this._G_P_);
        this.view.initialize(this._eJ_.servers);
    }

    override public function destroy():void {
        this.view._4s.remove(this._G_P_);
    }

    private function _G_P_():void {
        this._T__.dispatch(new _C_Q_());
    }

}
}//package _zD_

