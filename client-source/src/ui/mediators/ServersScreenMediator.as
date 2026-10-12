package ui.mediators {
import client.ui.screens.ServersScreen;
import client.ui.screens.TitleScreen;

import env.ServerListState;

import game.signals.SpriteSignal2;

import robotlegs.bender.bundles.mvcs.Mediator;

/** Mediator for the servers screen (_F_1._01_). Close returns to the title screen (_F_1._C_Q_). */
public class ServersScreenMediator extends Mediator {

    [Inject]
    public var view:ServersScreen;
    [Inject]
    public var serverList:ServerListState;
    [Inject]
    public var changeScreenSignal:SpriteSignal2;

    override public function initialize():void {
        this.view.done.add(this.onClose);
        this.view.initialize(this.serverList.servers);
    }

    override public function destroy():void {
        this.view.done.remove(this.onClose);
    }

    private function onClose():void {
        this.changeScreenSignal.dispatch(new TitleScreen());
    }

}
}
