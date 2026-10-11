package robotlegs.bender.extensions.viewManager.impl {
import flash.display.DisplayObjectContainer;
import flash.events.Event;

/** Dispatched by the ContainerRegistry when containers are added or removed. */
public class ContainerRegistryEvent extends Event {

    public static const CONTAINER_ADD:String = "containerAdd";
    public static const CONTAINER_REMOVE:String = "containerRemove";
    public static const ROOT_CONTAINER_ADD:String = "rootContainerAdd";
    public static const ROOT_CONTAINER_REMOVE:String = "rootContainerRemove";

    private var _container:DisplayObjectContainer;

    public function ContainerRegistryEvent(type:String, container:DisplayObjectContainer) {
        super(type);
        _container = container;
    }

    public function get container():DisplayObjectContainer {
        return _container;
    }

    override public function clone():Event {
        return new ContainerRegistryEvent(type, _container);
    }

}
}
