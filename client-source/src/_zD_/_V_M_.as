// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_zD_._V_M_

package _zD_ {
import robotlegs.bender.bundles.mvcs.Mediator;

import _F_1._05p;

import env.ServerListState;

import game.signals.ToolTipSignal;
import game.signals.NoArgSignal5;
import game.signals.NoArgSignal4;
import game.signals.SpriteSignal;

import com.company.assembleegameclient.ui.tooltip.ToolTip;

import _F_1._C_Q_;

import flash.display.Sprite;

public class _V_M_ extends Mediator {

    [Inject]
    public var view:_05p;
    [Inject]
    public var _eJ_:ServerListState;
    [Inject]
    public var _0C__:ToolTipSignal;
    [Inject]
    public var _H_F_:NoArgSignal5;
    [Inject]
    public var _0B_a:NoArgSignal4;
    [Inject]
    public var _0_b:SpriteSignal;

    override public function initialize():void {
        this.view.tooltip.add(this._Y_Y_);
        this.view._03I_.add(this._C_R_);
    }

    override public function destroy():void {
        this.view.tooltip.remove(this._Y_Y_);
        this.view._03I_.remove(this._C_R_);
        this.view.destroy();
        this._H_F_.dispatch();
    }

    private function _Y_Y_(_arg1:ToolTip):void {
        this._0C__.dispatch(_arg1);
    }

    private function _C_R_(_arg1:Class):void {
        var _local2:Sprite = new (((_arg1) || (_C_Q_)))();
        this._0B_a.dispatch();
        this._0_b.dispatch(_local2);
    }

}
}//package _zD_

