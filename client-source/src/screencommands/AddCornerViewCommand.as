package screencommands
{
    import ui.mediators.KeyPanel;

    import flash.display.DisplayObjectContainer;

    public class AddCornerViewCommand
    {
        [Inject]
        public var contextView:DisplayObjectContainer;

        public function execute():void
        {
            var view:KeyPanel = new KeyPanel();
            view.x = 4;
            view.y = 4;
            this.contextView.addChild(view);
        }
    }
}
