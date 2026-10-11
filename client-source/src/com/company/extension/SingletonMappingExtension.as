package com.company.extension {
import robotlegs.bender.framework.impl.UID;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IContext;
import commandmap.ISignalCommandMap;
import signalcommands.SignalCommandMap;

// Formerly _083. A context extension: when installed, it maps ISignalCommandMap
// to a single shared SignalCommandMap instance in the context's injector.
public class SingletonMappingExtension implements IExtension {

    private const uid_:String = UID.create(SingletonMappingExtension);   // formerly _ul

    public function extend(context:IContext):void {
        context.injector.map(ISignalCommandMap).toSingleton(SignalCommandMap);
    }

    public function toString():String {
        return this.uid_;
    }
}
}
