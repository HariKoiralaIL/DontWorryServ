package viewextensions {

import injection.Injector;

import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;

import robotlegs.bender.framework.impl.UID;
import robotlegs.bender.extensions.viewManager.impl.ViewManager;
import robotlegs.bender.extensions.viewManager.impl.ContainerRegistry;
import views.IViewManager;

/**
 * Maps the shared _t5 registry (one instance for all contexts) and a
 * singleton IViewManager into the context's injector, and removes the
 * handlers and mappings again when the context is destroyed.
 */
public class ViewManagerExtension implements IExtension {

    private static var registry:ContainerRegistry;

    private const uid:String = UID.create(ViewManagerExtension);

    private var injector:Injector;
    private var viewManager:IViewManager;

    public function extend(context:IContext):void {
        this.injector = context.injector;
        registry = registry || new ContainerRegistry();
        this.injector.map(ContainerRegistry).toValue(registry);
        this.injector.map(IViewManager).toSingleton(ViewManager);
        context.lifecycle.whenInitializing(this.handleContextInitialize);
        context.lifecycle.whenDestroying(this.handleContextDestroy);
    }

    public function toString():String {
        return this.uid;
    }

    private function handleContextInitialize():void {
        this.viewManager = this.injector.getInstance(IViewManager);
    }

    private function handleContextDestroy():void {
        this.viewManager.removeAllHandlers();
        this.injector.unmap(IViewManager);
        this.injector.unmap(ContainerRegistry);
    }

}
}
