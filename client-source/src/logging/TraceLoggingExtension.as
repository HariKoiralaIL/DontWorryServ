package logging
{
    import robotlegs.bender.framework.impl.UID;

    import robotlegs.bender.framework.api.IExtension;
    import robotlegs.bender.framework.api.IContext;

    import com.company.log.TraceLogTarget;

    public class TraceLoggingExtension implements IExtension
    {
        private const uid_:String = UID.create(TraceLoggingExtension);

        public function extend(context:IContext):void
        {
            context.addLogTarget(new TraceLogTarget(context));
        }

        public function toString():String
        {
            return this.uid_;
        }
    }
}
