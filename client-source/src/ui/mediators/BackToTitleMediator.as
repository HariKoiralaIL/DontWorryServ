package ui.mediators {
import _F_1._C_Q_;
import _F_1._E_r;

import game.signals.SpriteSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

/** Mediator for the screen view _F_1._E_r. Its back signal returns to the title screen (_F_1._C_Q_). */
public class BackToTitleMediator extends Mediator {

    [Inject]
    public var view:_E_r;
    [Inject]
    public var setScreenSignal:SpriteSignal;

    override public function initialize():void {
        this.view._J_b.add(this.onBack);
    }

    override public function destroy():void {
        this.view._J_b.remove(this.onBack);
    }

    private function onBack():void {
        this.setScreenSignal.dispatch(new _C_Q_());
    }

}
}
