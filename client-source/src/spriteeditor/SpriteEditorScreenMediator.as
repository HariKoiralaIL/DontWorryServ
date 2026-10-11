package spriteeditor {
import robotlegs.bender.bundles.mvcs.Mediator;

import env.ServerListState;

import game.signals.StringSignal;

public class SpriteEditorScreenMediator extends Mediator {

    [Inject]
    public var view:SpriteEditorScreen;
    [Inject]
    public var serverListState:ServerListState;
    [Inject]
    public var setScreenSignal:StringSignal;

    override public function initialize():void {
        view.initialize(serverListState.servers);
        setScreenSignal.dispatch("/textureScreen");
    }

}
}
