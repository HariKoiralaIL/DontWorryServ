package rootview {
import robotlegs.bender.bundles.mvcs.Mediator;

import _U_5._dd;
import _U_5._6J_;

import flash.display.Sprite;

public class ScreensViewMediator extends Mediator {

    [Inject]
    public var view:ScreensView;
    /** Signal carrying the screen to show. */
    [Inject]
    public var setScreenSignal:_dd;
    /** Signal asking to go back to the previous screen. */
    [Inject]
    public var showPreviousScreenSignal:_6J_;

    override public function initialize():void {
        this.setScreenSignal.add(this.onSetScreen);
        this.showPreviousScreenSignal.add(this.onShowPreviousScreen);
    }

    override public function destroy():void {
        this.setScreenSignal.remove(this.onSetScreen);
        this.showPreviousScreenSignal.remove(this.onShowPreviousScreen);
    }

    private function onSetScreen(screen:Sprite):void {
        this.view.setScreen(screen);
    }

    private function onShowPreviousScreen():void {
        this.view.setScreen(this.view.getPreviousScreen());
    }

}
}//package rootview
