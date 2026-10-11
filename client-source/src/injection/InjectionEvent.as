package injection
{
    import flash.events.Event;

    public class InjectionEvent extends Event
    {
        public static const POST_INSTANTIATE:String = "postInstantiate";
        public static const PRE_CONSTRUCT:String = "preConstruct";
        public static const POST_CONSTRUCT:String = "postConstruct";

        public var instance;
        public var instanceType:Class;

        public function InjectionEvent(type:String, instance:Object, instanceType:Class)
        {
            super(type);
            this.instance = instance;
            this.instanceType = instanceType;
        }

        override public function clone():Event
        {
            return new InjectionEvent(type, this.instance, this.instanceType);
        }
    }
}
