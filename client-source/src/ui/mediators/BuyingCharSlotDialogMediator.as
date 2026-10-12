package ui.mediators {
import _F_1.CurrentCharacterScreen;

import flash.events.Event;

import game.dialogs.BuyingCharSlotDialog;
import game.signals.NoArgSignal4;
import game.signals.SpriteSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

/** Mediator for the "buying character slot" dialog. When done, reloads characters and shows the character screen. */
public class BuyingCharSlotDialogMediator extends Mediator {

    [Inject]
    public var view:BuyingCharSlotDialog;
    [Inject]
    public var reloadCharListSignal:NoArgSignal4;
    [Inject]
    public var setScreenSignal:SpriteSignal;

    override public function initialize():void {
        addViewListener(Event.COMPLETE, this.onComplete);
    }

    override public function destroy():void {
        removeViewListener(Event.COMPLETE, this.onComplete);
    }

    private function onComplete(event:Event):void {
        this.reloadCharListSignal.dispatch();
        this.setScreenSignal.dispatch(new CurrentCharacterScreen());
    }

}
}
