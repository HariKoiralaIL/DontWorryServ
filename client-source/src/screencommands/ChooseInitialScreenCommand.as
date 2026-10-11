package screencommands
{
    import rootview.PlayAtMessage;

    import _F_1._E_r;

    import _U_5._dd;

    import env.Domain;

    import flash.display.Sprite;

    public class ChooseInitialScreenCommand
    {
        [Inject]
        public var domain:Domain;
        [Inject]
        public var setScreenSignal:_dd;

        public function execute():void
        {
            this.setScreenSignal.dispatch(this.createInitialScreen());
        }

        private function createInitialScreen():Sprite
        {
            return this.domain.isAllowed() ? new _E_r() : new PlayAtMessage();
        }
    }
}
