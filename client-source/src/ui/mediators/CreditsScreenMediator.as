package ui.mediators {
import _F_1._0H_h;
import _F_1._C_Q_;

import game.signals.SpriteSignal2;

import robotlegs.bender.bundles.mvcs.Mediator;

/** Mediator for the credits screen (_F_1._0H_h). Close returns to the title screen (_F_1._C_Q_). */
public class CreditsScreenMediator extends Mediator {

    [Inject]
    public var view:_0H_h;
    [Inject]
    public var changeScreenSignal:SpriteSignal2;

    override public function initialize():void {
        this.view.close.add(this.onClose);
        this.view.initialize();
    }

    override public function destroy():void {
        this.view.close.remove(this.onClose);
    }

    private function onClose():void {
        this.changeScreenSignal.dispatch(new _C_Q_());
    }

}
}
