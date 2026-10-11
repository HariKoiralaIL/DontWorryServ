package commandextensions {

import eventcommandmap.EventCommandMap;

import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;

import robotlegs.bender.framework.impl.UID;
import _j1._X_y;

/**
 * Context extension that makes the event command map available for
 * injection: _X_y is mapped to a singleton EventCommandMap.
 */
public class EventCommandMapExtension implements IExtension {

    private const uid:String = UID.create(EventCommandMapExtension);

    public function extend(context:IContext):void {
        context.injector.map(_X_y).toSingleton(EventCommandMap);
    }

    public function toString():String {
        return this.uid;
    }

}
}
