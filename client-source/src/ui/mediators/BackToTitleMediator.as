package ui.mediators {
    import client.ui.screens.AccountLoadingScreen;
    import client.ui.screens.TitleScreen;

    import game.signals.SpriteSignal;

    import robotlegs.bender.bundles.mvcs.Mediator;

    /** Mediator for AccountLoadingScreen: once the account has loaded, switches to the title screen. */
    public class BackToTitleMediator extends Mediator {

        [Inject]
        public var view:AccountLoadingScreen;
        [Inject]
        public var setScreenSignal:SpriteSignal;

        override public function initialize():void {
            this.view.accountLoaded.add(this.onAccountLoaded);
        }

        override public function destroy():void {
            this.view.accountLoaded.remove(this.onAccountLoaded);
        }

        private function onAccountLoaded():void {
            this.setScreenSignal.dispatch(new TitleScreen());
        }

    }
}