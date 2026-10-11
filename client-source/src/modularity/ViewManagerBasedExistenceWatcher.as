package modularity {
import views.IViewManager;

import flash.display.DisplayObjectContainer;

import injection.Injector;

import robotlegs.bender.extensions.viewManager.impl.ViewManagerEvent;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.ILogger;
import robotlegs.bender.framework.impl.UID;

/**
 * Listens on every container registered with the view manager for child
 * contexts announcing themselves and links each child's injector to this
 * context's injector. Also follows containers being added or removed.
 */
public class ViewManagerBasedExistenceWatcher {

    private const uid:String = UID.create(ViewManagerBasedExistenceWatcher);

    private var logger:ILogger;
    private var injector:Injector;
    private var viewManager:IViewManager;
    private var childContext:IContext;

    public function ViewManagerBasedExistenceWatcher(context:IContext, viewManager:IViewManager) {
        this.logger = context.getLogger(this);
        this.injector = context.injector;
        this.viewManager = viewManager;
        context.lifecycle.whenDestroying(this.destroy);
        this.init();
    }

    public function toString():String {
        return this.uid;
    }

    private function init():void {
        var container:DisplayObjectContainer;
        for each (container in this.viewManager.containers) {
            this.logger.debug("Adding context existence event listener to container {0}", [container]);
            container.addEventListener(ModularContextEvent.CONTEXT_ADD, this.onContextAdded);
        }
        this.viewManager.addEventListener(ViewManagerEvent.CONTAINER_ADD, this.onContainerAdded);
        this.viewManager.addEventListener(ViewManagerEvent.CONTAINER_REMOVE, this.onContainerRemoved);
    }

    private function destroy():void {
        var container:DisplayObjectContainer;
        for each (container in this.viewManager.containers) {
            this.logger.debug("Removing context existence event listener from container {0}", [container]);
            container.removeEventListener(ModularContextEvent.CONTEXT_ADD, this.onContextAdded);
        }
        this.viewManager.removeEventListener(ViewManagerEvent.CONTAINER_ADD, this.onContainerAdded);
        this.viewManager.removeEventListener(ViewManagerEvent.CONTAINER_REMOVE, this.onContainerRemoved);
        if (this.childContext) {
            this.logger.debug("Unlinking parent injector for child context {0}", [this.childContext]);
            this.childContext.injector.parent = null;
        }
    }

    private function onContainerAdded(event:ViewManagerEvent):void {
        this.logger.debug("Adding context existence event listener to container {0}", [event.container]);
        event.container.addEventListener(ModularContextEvent.CONTEXT_ADD, this.onContextAdded);
    }

    private function onContainerRemoved(event:ViewManagerEvent):void {
        this.logger.debug("Removing context existence event listener from container {0}", [event.container]);
        event.container.removeEventListener(ModularContextEvent.CONTEXT_ADD, this.onContextAdded);
    }

    private function onContextAdded(event:ModularContextEvent):void {
        event.stopImmediatePropagation();
        this.childContext = event.context;
        this.logger.debug("Context existence event caught. Configuring child context {0}", [this.childContext]);
        this.childContext.injector.parent = this.injector;
    }
}
}
