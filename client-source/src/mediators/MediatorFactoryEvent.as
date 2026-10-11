package mediators
{
    import flash.events.Event;

    public class MediatorFactoryEvent extends Event
    {
        public static const MEDIATOR_CREATE:String = "mediatorCreate";
        public static const MEDIATOR_REMOVE:String = "mediatorRemove";

        private var mediator_:Object;
        private var view_:Object;
        private var mapping_:IMediatorMapping;
        private var factory_:IMediatorFactory;

        public function MediatorFactoryEvent(type:String, mediator:Object, view:Object, mapping:IMediatorMapping, factory:IMediatorFactory)
        {
            super(type);
            this.mediator_ = mediator;
            this.view_ = view;
            this.mapping_ = mapping;
            this.factory_ = factory;
        }

        public function get factory():IMediatorFactory
        {
            return this.factory_;
        }

        public function get mediator():Object
        {
            return this.mediator_;
        }

        public function get view():Object
        {
            return this.view_;
        }

        public function get mapping():IMediatorMapping
        {
            return this.mapping_;
        }

        override public function clone():Event
        {
            return new MediatorFactoryEvent(type, this.mediator_, this.view_, this.mapping_, this.factory_);
        }
    }
}
