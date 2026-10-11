package robotlegs.bender.extensions.viewManager.impl {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.utils.getQualifiedClassName;

/**
 * Watches root containers and hands every view added to the stage beneath them
 * to the handlers of the closest registered container, ignoring framework classes
 * (mx.*, spark.* and flash.*).
 */
public class StageObserver {

    private const _filter:RegExp = /^mx\.|^spark\.|^flash\./;

    private var _registry:ContainerRegistry;

    public function StageObserver(registry:ContainerRegistry) {
        var binding:ContainerBinding;
        _registry = registry;
        _registry.addEventListener(ContainerRegistryEvent.ROOT_CONTAINER_ADD, onRootContainerAdd);
        _registry.addEventListener(ContainerRegistryEvent.ROOT_CONTAINER_REMOVE, onRootContainerRemove);
        for each (binding in _registry.rootBindings) {
            addRootListener(binding.container);
        }
    }

    public function destroy():void {
        var binding:ContainerBinding;
        _registry.removeEventListener(ContainerRegistryEvent.ROOT_CONTAINER_ADD, onRootContainerAdd);
        _registry.removeEventListener(ContainerRegistryEvent.ROOT_CONTAINER_REMOVE, onRootContainerRemove);
        for each (binding in _registry.rootBindings) {
            removeRootListener(binding.container);
        }
    }

    private function addRootListener(container:DisplayObjectContainer):void {
        container.addEventListener(Event.ADDED_TO_STAGE, onViewAddedToStage, true);
        container.addEventListener(Event.ADDED_TO_STAGE, onContainerAddedToStage);
    }

    private function removeRootListener(container:DisplayObjectContainer):void {
        container.removeEventListener(Event.ADDED_TO_STAGE, onViewAddedToStage, true);
        container.removeEventListener(Event.ADDED_TO_STAGE, onContainerAddedToStage);
    }

    private function onRootContainerAdd(event:ContainerRegistryEvent):void {
        addRootListener(event.container);
    }

    private function onRootContainerRemove(event:ContainerRegistryEvent):void {
        removeRootListener(event.container);
    }

    /** A view was added somewhere below a root container (capture phase). */
    private function onViewAddedToStage(event:Event):void {
        var view:DisplayObject = event.target as DisplayObject;
        var className:String = getQualifiedClassName(view);
        var isFrameworkClass:Boolean = _filter.test(className);
        if (isFrameworkClass) {
            return;
        }
        var type:Class = view["constructor"];
        var binding:ContainerBinding = _registry.findParentBinding(view);
        while (binding) {
            binding.handleView(view, type);
            binding = binding.parent;
        }
    }

    /** A root container itself was added to the stage. */
    private function onContainerAddedToStage(event:Event):void {
        var container:DisplayObjectContainer = event.target as DisplayObjectContainer;
        container.removeEventListener(Event.ADDED_TO_STAGE, onContainerAddedToStage);
        var type:Class = container["constructor"];
        var binding:ContainerBinding = _registry.getBinding(container);
        binding.handleView(container, type);
    }

}
}
