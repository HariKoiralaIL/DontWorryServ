package eventcommandmap {

import flash.events.IEventDispatcher;
import flash.utils.Dictionary;

import injection.Injector;

import commands.ICommandCenter;
import commands.ICommandTrigger;
import commands.ICommandMapper;
import commands.ICommandUnmapper;
import commands.event.IEventCommandMap;

/**
 * Maps commands to events. One EventCommandTrigger is created and cached per
 * (event type, event class) pair.
 */
public class EventCommandMap implements IEventCommandMap {

    private const triggers:Dictionary = new Dictionary();

    private var injector:Injector;
    private var dispatcher:IEventDispatcher;
    private var commandCenter:ICommandCenter;

    public function EventCommandMap(injector:Injector, dispatcher:IEventDispatcher, commandCenter:ICommandCenter) {
        this.injector = injector;
        this.dispatcher = dispatcher;
        this.commandCenter = commandCenter;
    }

    public function map(eventType:String, eventClass:Class = null):ICommandMapper {
        var key:String = this.getKey(eventType, eventClass);
        var trigger:ICommandTrigger = this.triggers[key] = this.triggers[key] || this.createTrigger(eventType, eventClass);
        return this.commandCenter.map(trigger);
    }

    public function unmap(eventType:String, eventClass:Class = null):ICommandUnmapper {
        return this.commandCenter.unmap(this.getTrigger(eventType, eventClass));
    }

    private function getKey(eventType:String, eventClass:Class):String {
        return eventType + eventClass;
    }

    private function createTrigger(eventType:String, eventClass:Class = null):ICommandTrigger {
        return new EventCommandTrigger(this.injector, this.dispatcher, eventType, eventClass);
    }

    private function getTrigger(eventType:String, eventClass:Class = null):ICommandTrigger {
        return this.triggers[this.getKey(eventType, eventClass)];
    }

}
}
