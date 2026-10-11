package signals.nativesignals {
import signals.IPrioritySignal;

import flash.events.Event;
import flash.events.IEventDispatcher;

// Formerly _j3. A signal that is bound to one event type on a native IEventDispatcher.
public interface INativeDispatcher extends IPrioritySignal {

    // formerly _S_b
    function get eventType():String;

    function get eventClass():Class;

    function get target():IEventDispatcher;

    function set target(value:IEventDispatcher):void;

    function dispatchEvent(event:Event):Boolean;
}
}
