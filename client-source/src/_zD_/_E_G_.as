// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_zD_._E_G_

package _zD_ {
import robotlegs.bender.bundles.mvcs.Mediator;

import _0L_C_._Z_t;

import game.signals.NoArgSignal4;
import game.signals.SpriteSignal;

import flash.events.Event;

import _F_1.CurrentCharacterScreen;

public class _E_G_ extends Mediator {

    [Inject]
    public var view:_Z_t;
    [Inject]
    public var _0B_a:NoArgSignal4;
    [Inject]
    public var _0_b:SpriteSignal;

    override public function initialize():void {
        addViewListener(Event.COMPLETE, this.onComplete);
    }

    override public function destroy():void {
        removeViewListener(Event.COMPLETE, this.onComplete);
    }

    private function onComplete(_arg1:Event):void {
        this._0B_a.dispatch();
        this._0_b.dispatch(new CurrentCharacterScreen());
    }

}
}//package _zD_

