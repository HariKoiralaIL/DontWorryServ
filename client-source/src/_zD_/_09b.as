// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_zD_._09b

package _zD_ {
import robotlegs.bender.bundles.mvcs.Mediator;

import _F_1._U_W_;

import env.ServerListState;
import env.DeathRecord;

import game.signals.SpriteSignal2;
import game.signals.NoArgSignal2;
import game.signals.StringSignal;

import services.LoadFameTask;

import client.tasks.Task;

import _F_1._3V_;

public class _09b extends Mediator {

    [Inject]
    public var view:_U_W_;
    [Inject]
    public var _0I_s:ServerListState;
    [Inject]
    public var _0K_K_:DeathRecord;
    [Inject]
    public var _T__:SpriteSignal2;
    [Inject]
    public var _S_a:NoArgSignal2;
    [Inject]
    public var _o_:StringSignal;
    [Inject]
    public var fame:LoadFameTask;

    override public function initialize():void {
        this.view._0M_S_.add(this._m9);
        var _local1 = !(this._0K_K_._sr);
        this.view._yK_(_local1);
        if (((this._0K_K_.info) && (this._0K_K_.info.background))) {
            this.view._K_f(this._0K_K_.info.background);
        }
        this._o_.dispatch("/fame");
        if (this._0K_K_._dA_) {
            this._0K_K_._dA_ = false;
            this.fame.accountId = this._0I_s.servers.accountId_;
            this.fame.charId = this._0I_s.count;
        } else {
            this.fame.accountId = this._0K_K_._Z__;
            this.fame.charId = this._0K_K_._J_u;
        }
        this.fame.completed.addOnce(this._qU_);
        this.fame.start();
    }

    override public function destroy():void {
        this.view._0M_S_.remove(this._m9);
        if (this._0K_K_.info) {
            ((this._0K_K_.info.background) && (this._0K_K_.info.background.dispose()));
            this._0K_K_.info.background = null;
        }
    }

    private function _qU_(_arg1:Task, _arg2:Boolean, _arg3:String = ""):void {
        this.view._tC_(this.fame.name, this.fame.level, this.fame.objectType);
        this.view._ec(this.fame.createdOn, this.fame.killedBy);
        this.view._sQ_(this.fame.character);
        this.view._0__(this.fame.totalFame, this.fame.xml);
    }

    private function _m9():void {
        if (this._0K_K_._sr) {
            this._T__.dispatch(new _3V_());
        } else {
            this._S_a.dispatch();
        }
    }

}
}//package _zD_

