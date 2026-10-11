package spriteeditor {
import robotlegs.bender.bundles.mvcs.Mediator;

import env.ServerListState;

import _U_5._0_D_;

public class SpriteEditorScreenMediator extends Mediator {

    [Inject]
    public var view:SpriteEditorScreen;
    [Inject]
    public var serverListState:ServerListState;
    [Inject]
    public var setScreenSignal:_0_D_;

    override public function initialize():void {
        view.initialize(serverListState.servers);
        setScreenSignal.dispatch("/textureScreen");
    }

}
}
