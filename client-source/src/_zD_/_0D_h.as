// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_zD_._0D_h

package _zD_ {
import robotlegs.bender.bundles.mvcs.Mediator;

import _F_1._zf;

import game.signals.StringSignal2;

public class _0D_h extends Mediator {

    [Inject]
    public var view:_zf;
    [Inject]
    public var _07t:StringSignal2;

    override public function initialize():void {
        this._07t.add(this._nO_);
        this.view._02C_('<p align="center">Loading...</p>');
    }

    override public function destroy():void {
        this._07t.remove(this._nO_);
    }

    private function _nO_(_arg1:String):void {
        this.view._02C_(_arg1);
    }

}
}//package _zD_

