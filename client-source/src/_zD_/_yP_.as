// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_zD_._yP_

package _zD_ {
import robotlegs.bender.bundles.mvcs.Mediator;

import client.signals.DataSignalB;
import client.signals.DataSignalA;

import _U_5._zz;

import client.enums.PositionSlot;

public class _yP_ extends Mediator {

    [Inject]
    public var view:_Y_w;
    [Inject]
    public var _09X_:DataSignalB;
    [Inject]
    public var _h5:DataSignalA;
    [Inject]
    public var _X_v:_zz;

    override public function initialize():void {
        this._09X_.add(this._sg);
        this._h5.add(this._jj);
        this._X_v.add(this._R_Z_);
    }

    override public function destroy():void {
        this._09X_.remove(this._sg);
        this._h5.remove(this._jj);
        this._X_v.remove(this._R_Z_);
    }

    private function _sg(_arg1:PositionSlot):void {
        this.view._09X_(_arg1);
    }

    private function _jj(_arg1:PositionSlot):void {
        this.view._h5(_arg1);
    }

    private function _R_Z_():void {
        this.view.parent.removeChild(this.view);
    }

}
}//package _zD_

