package eventsignals {
import signals.Signal;

import flash.utils.Dictionary;
import flash.events.IEventDispatcher;
import flash.events.Event;

/**
 * A Signal that fires whenever a given event type is dispatched by any mapped
 * dispatcher, passing along the value that was mapped to that dispatcher.
 */
public class EventRelaySignal extends Signal {

    private var eventType:String;
    /** dispatcher -> value to dispatch (weak keys, so mapped dispatchers can still be collected). */
    private var values:Dictionary;

    public function EventRelaySignal(eventType:String, ...valueClasses) {
        this.eventType = eventType;
        this.values = new Dictionary(true);
        super(valueClasses);
    }

    public function map(dispatcher:IEventDispatcher, value:*):void {
        this.values[dispatcher] = value;
        dispatcher.addEventListener(this.eventType, this.onEvent, false, 0, true);
    }

    private function onEvent(event:Event):void {
        dispatch(this.values[event.target]);
    }

}
}//package eventsignals
