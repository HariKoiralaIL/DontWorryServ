package mediators
{
    import views.IViewHandler;

    public interface IMediatorViewHandler extends IViewHandler
    {
        function addMapping(mapping:IMediatorMapping):void;

        function removeMapping(mapping:IMediatorMapping):void;

        function handleItem(item:Object, type:Class):void;
    }
}
