package robotlegs.bender.extensions.viewManager.impl {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

/**
 * Hands out one ContainerBinding per container and keeps track of how bindings nest:
 * each binding's parent is the binding of the closest registered ancestor container,
 * and bindings without a parent are root bindings.
 */
public class ContainerRegistry extends EventDispatcher {

    private const _bindings:Vector.<ContainerBinding> = new Vector.<ContainerBinding>();
    private const _rootBindings:Vector.<ContainerBinding> = new Vector.<ContainerBinding>();
    private const _bindingByContainer:Dictionary = new Dictionary();

    public function get bindings():Vector.<ContainerBinding> {
        return _bindings;
    }

    public function get rootBindings():Vector.<ContainerBinding> {
        return _rootBindings;
    }

    /** Returns the binding for a container, creating it on first use. */
    public function addContainer(container:DisplayObjectContainer):ContainerBinding {
        var binding:ContainerBinding = _bindingByContainer[container];
        if (!binding) {
            binding = createBinding(container);
        }
        _bindingByContainer[container] = binding;
        return binding;
    }

    /** Removes and returns the binding for a container (null if it has none). */
    public function removeContainer(container:DisplayObjectContainer):ContainerBinding {
        var binding:ContainerBinding = _bindingByContainer[container];
        if (binding) {
            removeBinding(binding);
        }
        return binding;
    }

    /** Finds the binding of the closest registered ancestor of a view, or null. */
    public function findParentBinding(target:DisplayObject):ContainerBinding {
        var binding:ContainerBinding;
        var parent:DisplayObjectContainer = target.parent;
        while (parent) {
            binding = _bindingByContainer[parent];
            if (binding) {
                return binding;
            }
            parent = parent.parent;
        }
        return null;
    }

    public function getBinding(container:DisplayObjectContainer):ContainerBinding {
        return _bindingByContainer[container];
    }

    private function createBinding(container:DisplayObjectContainer):ContainerBinding {
        var other:ContainerBinding;
        var binding:ContainerBinding = new ContainerBinding(container);
        _bindings.push(binding);
        binding.addEventListener(ContainerBindingEvent.BINDING_EMPTY, onBindingEmpty);
        binding.parent = findParentBinding(container);
        if (binding.parent == null) {
            addRootBinding(binding);
        }
        for each (other in _bindingByContainer) {
            if (container.contains(other.container)) {
                if (!other.parent) {
                    removeRootBinding(other);
                    other.parent = binding;
                } else if (!container.contains(other.parent.container)) {
                    other.parent = binding;
                }
            }
        }
        dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.CONTAINER_ADD, binding.container));
        return binding;
    }

    private function removeBinding(binding:ContainerBinding):void {
        var other:ContainerBinding;
        delete _bindingByContainer[binding.container];
        var index:int = _bindings.indexOf(binding);
        _bindings.splice(index, 1);
        binding.removeEventListener(ContainerBindingEvent.BINDING_EMPTY, onBindingEmpty);
        if (!binding.parent) {
            removeRootBinding(binding);
        }
        for each (other in _bindingByContainer) {
            if (other.parent == binding) {
                other.parent = binding.parent;
                if (!other.parent) {
                    addRootBinding(other);
                }
            }
        }
        dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.CONTAINER_REMOVE, binding.container));
    }

    private function addRootBinding(binding:ContainerBinding):void {
        _rootBindings.push(binding);
        dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.ROOT_CONTAINER_ADD, binding.container));
    }

    private function removeRootBinding(binding:ContainerBinding):void {
        var index:int = _rootBindings.indexOf(binding);
        _rootBindings.splice(index, 1);
        dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.ROOT_CONTAINER_REMOVE, binding.container));
    }

    private function onBindingEmpty(event:ContainerBindingEvent):void {
        removeBinding(event.target as ContainerBinding);
    }

}
}
