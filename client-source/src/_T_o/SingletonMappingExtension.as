package _T_o {
import robotlegs.bender.framework.impl.UID;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IContext;
import commandmap.ISignalCommandMap;
import signalcommands.SignalCommandMap;

// Formerly _083. A context extension: when installed, it maps _U_A_ to a single shared
// instance of _T_7 in the context's injector.
//
// NOTE: _D_v (the extension interface), _L_y (the context), _078 (unique-id helper),
// _U_A_ and _T_7 (the mapped types) and the context's _O_R_ (injector) property come
// from other packages and keep their obfuscated names until those are refactored.
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
