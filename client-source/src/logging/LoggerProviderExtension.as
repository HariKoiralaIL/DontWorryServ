package logging
{
    import logging.LoggerProvider;

    import robotlegs.bender.framework.impl.UID;

    import robotlegs.bender.framework.api.IExtension;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.ILogger;

    public class LoggerProviderExtension implements IExtension
    {
        private const uid_:String = UID.create(LoggerProviderExtension);

        public function extend(context:IContext):void
        {
            context.injector.map(ILogger).toProvider(new LoggerProvider(context));
        }

        public function toString():String
        {
            return this.uid_;
        }
    }
}
