package screencommands
{
    import _zD_._Y_w;

    import flash.display.DisplayObjectContainer;

    public class AddCornerViewCommand
    {
        [Inject]
        public var contextView:DisplayObjectContainer;

        public function execute():void
        {
            var view:_Y_w = new _Y_w();
            view.x = 4;
            view.y = 4;
            this.contextView.addChild(view);
        }
    }
}
