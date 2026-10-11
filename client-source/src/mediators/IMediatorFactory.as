package mediators
{
    import flash.events.IEventDispatcher;

    public interface IMediatorFactory extends IEventDispatcher
    {
        function getMediator(item:Object, mapping:IMediatorMapping):Object;

        function createMediators(item:Object, type:Class, mappings:Array):Array;

        function removeMediators(item:Object):void;

        function removeAllMediators():void;
    }
}
