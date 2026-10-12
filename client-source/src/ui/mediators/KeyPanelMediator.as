package ui.mediators {
import client.enums.PositionSlot;
import client.signals.DataSignalA;
import client.signals.DataSignalB;

import game.signals.SingletonSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

/** Mediator for the KeyPanel: shows/hides key icons on signals and removes the panel on request. */
public class KeyPanelMediator extends Mediator {

    [Inject]
    public var view:KeyPanel;
    [Inject]
    public var showKeySignal:DataSignalB;
    [Inject]
    public var hideKeySignal:DataSignalA;
    [Inject]
    public var removePanelSignal:SingletonSignal;

    override public function initialize():void {
        this.showKeySignal.add(this.onShowKey);
        this.hideKeySignal.add(this.onHideKey);
        this.removePanelSignal.add(this.onRemovePanel);
    }

    override public function destroy():void {
        this.showKeySignal.remove(this.onShowKey);
        this.hideKeySignal.remove(this.onHideKey);
        this.removePanelSignal.remove(this.onRemovePanel);
    }

    private function onShowKey(slot:PositionSlot):void {
        this.view.showKey(slot);
    }

    private function onHideKey(slot:PositionSlot):void {
        this.view.hideKey(slot);
    }

    private function onRemovePanel():void {
        this.view.parent.removeChild(this.view);
    }

}
}
