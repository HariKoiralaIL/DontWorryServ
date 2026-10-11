package commandextensions {

import eventcommandmap.EventCommandMap;

import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;

import robotlegs.bender.framework.impl.UID;
import commands.event.IEventCommandMap;

/**
 * Context extension that makes the event command map available for
 * injection: _X_y is mapped to a singleton EventCommandMap.
 */
public class EventCommandMapExtension implements IExtension {

    private const uid:String = UID.create(EventCommandMapExtension);

    public function extend(context:IContext):void {
        context.injector.map(IEventCommandMap).toSingleton(EventCommandMap);
    }

    public function toString():String {
        return this.uid;
    }

}
}
