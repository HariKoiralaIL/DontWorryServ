// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_zD_._uf

package _zD_ {
import robotlegs.bender.bundles.mvcs.Mediator;

import _F_1._E_r;

import game.signals.SpriteSignal;

import _F_1._C_Q_;

public class _uf extends Mediator {

    [Inject]
    public var view:_E_r;
    [Inject]
    public var _T__:SpriteSignal;

    override public function initialize():void {
        this.view._J_b.add(this._E_R_);
    }

    override public function destroy():void {
        this.view._J_b.remove(this._E_R_);
    }

    private function _E_R_():void {
        this._T__.dispatch(new _C_Q_());
    }

}
}//package _zD_

