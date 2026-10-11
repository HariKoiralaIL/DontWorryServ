// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_zD_._G_9

package _zD_ {
import robotlegs.bender.bundles.mvcs.Mediator;

import game.dialogs.DeletingCharacterDialog;

import com.company.assembleegameclient.appengine.SavedCharacter;

import services.DeleteCharacterTask;

import game.signals.NoArgSignal4;
import game.signals.SpriteSignal;

import _F_1.CurrentCharacterScreen;

import client.tasks.Task;

public class _G_9 extends Mediator {

    [Inject]
    public var view:DeletingCharacterDialog;
    [Inject]
    public var character:SavedCharacter;
    [Inject]
    public var _yD_:DeleteCharacterTask;
    [Inject]
    public var _0D_p:NoArgSignal4;
    [Inject]
    public var _0_b:SpriteSignal;

    override public function initialize():void {
        this._yD_.completed.addOnce(this._S_f);
        this._yD_.start();
    }

    private function _S_f(_arg1:Task, _arg2:Boolean, _arg3:String = ""):void {
        this.view.parent.removeChild(this.view);
        this._0D_p.dispatch();
        this._0_b.dispatch(new CurrentCharacterScreen());
    }

}
}//package _zD_

