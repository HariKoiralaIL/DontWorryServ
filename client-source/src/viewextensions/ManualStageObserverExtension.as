package viewextensions {

import injection.Injector;

import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;

import robotlegs.bender.framework.impl.UID;
import robotlegs.bender.extensions.viewManager.impl.StageObserver;
import robotlegs.bender.extensions.viewManager.impl.ContainerRegistry;

/**
 * Installs a single shared _L_W_ observer for all contexts that use this
 * extension. The observer is created when the first context initializes and
 * destroyed when the last context using it is destroyed.
 */
public class ManualStageObserverExtension implements IExtension {

    private static var observer:StageObserver;
    private static var installCount:uint;

    private const uid:String = UID.create(ManualStageObserverExtension);

    private var injector:Injector;

    public function extend(context:IContext):void {
        installCount++;
        this.injector = context.injector;
        context.lifecycle.whenInitializing(this.handleContextInitialize);
        context.lifecycle.whenDestroying(this.handleContextDestroy);
    }

    public function toString():String {
        return this.uid;
    }

    private function handleContextInitialize():void {
        if (observer == null) {
            var registry:ContainerRegistry = this.injector.getInstance(ContainerRegistry);
            observer = new StageObserver(registry);
        }
    }

    private function handleContextDestroy():void {
        installCount--;
        if (installCount == 0) {
            observer.destroy();
            observer = null;
        }
    }

}
}
