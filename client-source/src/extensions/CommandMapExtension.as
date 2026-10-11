package extensions {
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.impl.UID;

import commands.ICommandCenter;

import commandcenter.CommandCenter;

// A context extension: when installed, it maps ICommandCenter to a single shared
// CommandCenter instance in the context's injector.
public class CommandMapExtension implements IExtension {

    private const _uid:String = UID.create(CommandMapExtension);

    public function extend(context:IContext):void {
        context.injector.map(ICommandCenter).toSingleton(CommandCenter);
    }

    public function toString():String {
        return _uid;
    }

}
}
