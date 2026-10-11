package robotlegs.bender.extensions.viewManager.impl {

import flash.display.DisplayObjectContainer;
import flash.events.EventDispatcher;

import views.IViewHandler;
import views.IViewManager;

/**
 * Keeps the list of watched containers and view handlers, and keeps the
 * container registry in sync with both lists.
 */
public class ViewManager extends EventDispatcher implements IViewManager {

    private const _containers:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
    private const _handlers:Vector.<IViewHandler> = new Vector.<IViewHandler>();

    private var _registry:ContainerRegistry;

    public function ViewManager(registry:ContainerRegistry) {
        this._registry = registry;
    }

    public function get containers():Vector.<DisplayObjectContainer> {
        return this._containers;
    }

    public function addContainer(container:DisplayObjectContainer):void {
        var handler:IViewHandler;
        if (!this.validateContainer(container)) {
            return;
        }
        this._containers.push(container);
        for each (handler in this._handlers) {
            this._registry.addContainer(container).addHandler(handler);
        }
        dispatchEvent(new ViewManagerEvent(ViewManagerEvent.CONTAINER_ADD, container));
    }

    public function removeContainer(container:DisplayObjectContainer):void {
        var handler:IViewHandler;
        var index:int = this._containers.indexOf(container);
        if (index == -1) {
            return;
        }
        this._containers.splice(index, 1);
        var binding:ContainerBinding = this._registry.getBinding(container);
        for each (handler in this._handlers) {
            binding.removeHandler(handler);
        }
        dispatchEvent(new ViewManagerEvent(ViewManagerEvent.CONTAINER_REMOVE, container));
    }

    public function addViewHandler(handler:IViewHandler):void {
        var container:DisplayObjectContainer;
        if (this._handlers.indexOf(handler) != -1) {
            return;
        }
        this._handlers.push(handler);
        for each (container in this._containers) {
            this._registry.addContainer(container).addHandler(handler);
        }
        dispatchEvent(new ViewManagerEvent(ViewManagerEvent.HANDLER_ADD, null, handler));
    }

    public function removeViewHandler(handler:IViewHandler):void {
        var container:DisplayObjectContainer;
        var index:int = this._handlers.indexOf(handler);
        if (index == -1) {
            return;
        }
        this._handlers.splice(index, 1);
        for each (container in this._containers) {
            this._registry.getBinding(container).removeHandler(handler);
        }
        dispatchEvent(new ViewManagerEvent(ViewManagerEvent.HANDLER_REMOVE, null, handler));
    }

    public function removeAllHandlers():void {
        var container:DisplayObjectContainer;
        var binding:ContainerBinding;
        var handler:IViewHandler;
        for each (container in this._containers) {
            binding = this._registry.getBinding(container);
            for each (handler in this._handlers) {
                binding.removeHandler(handler);
            }
        }
    }

    /** False if the container is already registered; throws if it overlaps an existing one. */
    private function validateContainer(container:DisplayObjectContainer):Boolean {
        var existing:DisplayObjectContainer;
        for each (existing in this._containers) {
            if (container == existing) {
                return false;
            }
            if (existing.contains(container) || container.contains(existing)) {
                throw new Error("Containers can not be nested");
            }
        }
        return true;
    }

}
}
