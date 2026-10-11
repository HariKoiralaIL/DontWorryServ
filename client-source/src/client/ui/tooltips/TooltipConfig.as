package client.ui.tooltips {
import mediators.IMediatorMap;

import rootview.Layers;

import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IContext;

/**
 * Robotlegs config for the tooltip view: maps ToolTipView to its mediator and,
 * once the context has initialized, adds a ToolTipView to the tooltips layer.
 * Formerly _R_Q_.TooltipConfig (originally _0K_S_).
 */
public class TooltipConfig implements IConfig {

    [Inject]
    public var context:IContext;
    [Inject]
    public var mediatorMap:IMediatorMap;
    [Inject]
    public var layers:Layers;

    public function configure():void {
        this.mediatorMap.map(ToolTipView).toMediator(ToolTipViewMediator);
        this.context.lifecycle.afterInitializing(this.init);
    }

    private function init():void {
        this.layers.tooltips.addChild(new ToolTipView());
    }
}
}
