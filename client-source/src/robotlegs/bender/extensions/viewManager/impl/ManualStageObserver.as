package robotlegs.bender.extensions.viewManager.impl {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

/**
 * Handles views that announce themselves by dispatching a ConfigureViewEvent
 * which bubbles up to a registered container.
 */
public class ManualStageObserver {

    private var _registry:ContainerRegistry;

    public function ManualStageObserver(registry:ContainerRegistry) {
        var binding:ContainerBinding;
        _registry = registry;
        _registry.addEventListener(ContainerRegistryEvent.CONTAINER_ADD, onContainerAdd);
        _registry.addEventListener(ContainerRegistryEvent.CONTAINER_REMOVE, onContainerRemove);
        for each (binding in _registry.bindings) {
            addContainerListener(binding.container);
        }
    }

    public function destroy():void {
        var binding:ContainerBinding;
        _registry.removeEventListener(ContainerRegistryEvent.CONTAINER_ADD, onContainerAdd);
        _registry.removeEventListener(ContainerRegistryEvent.CONTAINER_REMOVE, onContainerRemove);
        for each (binding in _registry.bindings) {
            removeContainerListener(binding.container);
        }
    }

    private function addContainerListener(container:DisplayObjectContainer):void {
        container.addEventListener(ConfigureViewEvent.CONFIGURE_VIEW, onConfigureView);
    }

    private function removeContainerListener(container:DisplayObjectContainer):void {
        container.removeEventListener(ConfigureViewEvent.CONFIGURE_VIEW, onConfigureView);
    }

    private function onContainerAdd(event:ContainerRegistryEvent):void {
        addContainerListener(event.container);
    }

    private function onContainerRemove(event:ContainerRegistryEvent):void {
        removeContainerListener(event.container);
    }

    private function onConfigureView(event:ConfigureViewEvent):void {
        var view:DisplayObject;
        event.stopImmediatePropagation();
        var container:DisplayObjectContainer = event.currentTarget as DisplayObjectContainer;
        view = event.target as DisplayObject;
        var type:Class = view["constructor"];
        _registry.getBinding(container).handleView(view, type);
    }

}
}
