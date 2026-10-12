package screencommands
{
    import rootview.PlayAtMessage;

    import client.ui.screens.AccountLoadingScreen;

    import game.signals.SpriteSignal2;

    import env.Domain;

    import flash.display.Sprite;

    public class ChooseInitialScreenCommand
    {
        [Inject]
        public var domain:Domain;
        [Inject]
        public var setScreenSignal:SpriteSignal2;

        public function execute():void
        {
            this.setScreenSignal.dispatch(this.createInitialScreen());
        }

        private function createInitialScreen():Sprite
        {
            return this.domain.isAllowed() ? new AccountLoadingScreen() : new PlayAtMessage();
        }
    }
}
