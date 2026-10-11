package robotlegs.bender.extensions.viewManager.impl {
import flash.events.Event;

/** Dispatched by a ContainerBinding. */
public class ContainerBindingEvent extends Event {

    /** The binding no longer has any handlers. */
    public static const BINDING_EMPTY:String = "bindingEmpty";

    public function ContainerBindingEvent(type:String) {
        super(type);
    }

    override public function clone():Event {
        return new ContainerBindingEvent(type);
    }

}
}
