package ui.mediators {
import client.ui.screens.LoadingScreen;

import game.signals.StringSignal2;

import robotlegs.bender.bundles.mvcs.Mediator;

/**
 * Mediator for an HTML text view (_F_1._zf).
 * Shows a "Loading..." placeholder until text arrives through the signal.
 */
public class HtmlTextMediator extends Mediator {

    private static const LOADING_HTML:String = '<p align="center">Loading...</p>';

    [Inject]
    public var view:LoadingScreen;
    [Inject]
    public var textSignal:StringSignal2;

    override public function initialize():void {
        this.textSignal.add(this.onText);
        this.view.setMessage(LOADING_HTML);
    }

    override public function destroy():void {
        this.textSignal.remove(this.onText);
    }

    private function onText(html:String):void {
        this.view.setMessage(html);
    }

}
}
