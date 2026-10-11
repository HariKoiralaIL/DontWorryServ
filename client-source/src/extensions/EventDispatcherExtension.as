package extensions {
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.impl.UID;

import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

public class EventDispatcherExtension implements IExtension {

    private const _uid:String = UID.create(EventDispatcherExtension);
    private var _eventDispatcher:IEventDispatcher;

    public function EventDispatcherExtension(eventDispatcher:IEventDispatcher = null) {
        _eventDispatcher = eventDispatcher || new EventDispatcher();
    }

    public function extend(context:IContext):void {
        context.injector.map(IEventDispatcher).toValue(_eventDispatcher);
    }

    public function toString():String {
        return _uid;
    }

}
}
