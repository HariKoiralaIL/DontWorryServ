package eventcommandmap {

import flash.events.IEventDispatcher;
import flash.utils.describeType;

import commandcenter.CommandMappingList;
import injection.Injector;

import commands.ICommandMapping;
import commands.ICommandTrigger;

/**
 * Listens for one event type on a dispatcher and hands matching events to
 * an EventCommandExecutor. The listener is attached when the first mapping
 * is added and detached when the last one is removed.
 */
public class EventCommandTrigger implements ICommandTrigger {

    private const mappings:CommandMappingList = new CommandMappingList();

    private var dispatcher:IEventDispatcher;
    private var eventType:String;
    private var executor:EventCommandExecutor;

    public function EventCommandTrigger(injector:Injector, dispatcher:IEventDispatcher, eventType:String, eventClass:Class = null) {
        this.dispatcher = dispatcher;
        this.eventType = eventType;
        this.executor = new EventCommandExecutor(this, this.mappings, injector, eventClass);
    }

    public function addMapping(mapping:ICommandMapping):void {
        this.verifyCommandClass(mapping);
        if (this.mappings.tail) {
            this.mappings.tail.next = mapping;
        } else {
            this.mappings.head = mapping;
            this.addListener();
        }
    }

    public function removeMapping(mapping:ICommandMapping):void {
        this.mappings.remove(mapping);
        if (!this.mappings.head) {
            this.removeListener();
        }
    }

    private function verifyCommandClass(mapping:ICommandMapping):void {
        if (describeType(mapping.commandClass).factory.method.(@name == "execute").length() == 0) {
            throw new Error("Command Class must expose an execute method");
        }
    }

    private function addListener():void {
        this.dispatcher.addEventListener(this.eventType, this.executor.execute);
    }

    private function removeListener():void {
        this.dispatcher.removeEventListener(this.eventType, this.executor.execute);
    }

}
}
