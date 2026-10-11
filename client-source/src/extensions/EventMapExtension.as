package extensions {
import robotlegs.bender.extensions.eventManagement.api.IEventMap;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.impl.UID;

import events.EventMap;

public class EventMapExtension implements IExtension {

    private const _uid:String = UID.create(EventMapExtension);

    public function extend(context:IContext):void {
        context.injector.map(IEventMap).toType(EventMap);
    }

    public function toString():String {
        return _uid;
    }

}
}
