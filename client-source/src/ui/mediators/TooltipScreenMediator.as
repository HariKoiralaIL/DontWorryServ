package ui.mediators {
import _F_1._05p;
import _F_1._C_Q_;

import com.company.assembleegameclient.ui.tooltip.ToolTip;

import env.ServerListState;

import flash.display.Sprite;

import game.signals.NoArgSignal4;
import game.signals.NoArgSignal5;
import game.signals.SpriteSignal;
import game.signals.ToolTipSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

/**
 * Mediator for the screen view _F_1._05p: forwards its tooltips and lets it
 * navigate to another screen class (defaults to the title screen, _F_1._C_Q_).
 */
public class TooltipScreenMediator extends Mediator {

    [Inject]
    public var view:_05p;
    /** Unused; kept so dependency injection behaves exactly as before. */
    [Inject]
    public var serverList:ServerListState;
    [Inject]
    public var showToolTipSignal:ToolTipSignal;
    [Inject]
    public var hideToolTipSignal:NoArgSignal5;
    [Inject]
    public var reloadCharListSignal:NoArgSignal4;
    [Inject]
    public var setScreenSignal:SpriteSignal;

    override public function initialize():void {
        this.view.tooltip.add(this.onToolTip);
        this.view._03I_.add(this.onChangeScreen);
    }

    override public function destroy():void {
        this.view.tooltip.remove(this.onToolTip);
        this.view._03I_.remove(this.onChangeScreen);
        this.view.destroy();
        this.hideToolTipSignal.dispatch();
    }

    private function onToolTip(toolTip:ToolTip):void {
        this.showToolTipSignal.dispatch(toolTip);
    }

    private function onChangeScreen(screenClass:Class):void {
        var targetClass:Class = (screenClass != null) ? screenClass : _C_Q_;
        var screen:Sprite = new targetClass();
        this.reloadCharListSignal.dispatch();
        this.setScreenSignal.dispatch(screen);
    }

}
}
