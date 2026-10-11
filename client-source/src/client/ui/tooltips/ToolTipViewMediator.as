// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.ui.tooltips.ToolTipViewMediator

package client.ui.tooltips {
import robotlegs.bender.bundles.mvcs.Mediator;

import game.signals.ToolTipSignal;
import game.signals.NoArgSignal5;

import com.company.assembleegameclient.ui.tooltip.ToolTip;

public class ToolTipViewMediator extends Mediator {

    [Inject]
    public var view:ToolTipView;
    [Inject]
    public var showSignal:ToolTipSignal;
    [Inject]
    public var hideSignal:NoArgSignal5;

    override public function initialize():void {
        this.showSignal.add(this.onShow);
        this.hideSignal.add(this.onHide);
    }

    override public function destroy():void {
        this.showSignal.remove(this.onShow);
        this.hideSignal.remove(this.onHide);
    }

    private function onShow(_arg1:ToolTip):void {
        this.view.show(_arg1);
    }

    private function onHide():void {
        this.view.hide();
    }

}
}//package client.ui.tooltips

