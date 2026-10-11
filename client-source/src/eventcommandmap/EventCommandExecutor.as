package eventcommandmap {

import flash.events.Event;

import commandcenter.CommandMappingList;
import injection.Injector;

import commands.ICommandMapping;
import commands.ICommandTrigger;

/**
 * Runs every command mapped to an event trigger when a matching event is
 * dispatched. The event is made available to commands through injection
 * (as Event, and as its concrete class when that differs from Event).
 */
public class EventCommandExecutor {

    private var trigger:ICommandTrigger;
    private var mappings:CommandMappingList;
    private var injector:Injector;
    private var mappedEventClass:Class;
    private var factory:CommandFactory;

    public function EventCommandExecutor(trigger:ICommandTrigger, mappings:CommandMappingList, injector:Injector, mappedEventClass:Class) {
        this.trigger = trigger;
        this.mappings = mappings;
        this.injector = injector.createChildInjector();
        this.mappedEventClass = mappedEventClass;
        this.factory = new CommandFactory(this.injector);
    }

    public function execute(event:Event):void {
        var eventClass:Class = event["constructor"] as Class;
        if (this.matchesMappedEventClass(eventClass)) {
            this.executeMappings(event, eventClass);
        }
    }

    private function matchesMappedEventClass(eventClass:Class):Boolean {
        return !this.mappedEventClass || eventClass == this.mappedEventClass;
    }

    private function isNotBaseEventClass(eventClass:Class):Boolean {
        return eventClass != Event;
    }

    private function mapEventForInjection(event:Event, eventClass:Class):void {
        this.injector.map(Event).toValue(event);
        if (this.isNotBaseEventClass(eventClass)) {
            this.injector.map(this.mappedEventClass || eventClass).toValue(event);
        }
    }

    private function unmapEventForInjection(eventClass:Class):void {
        this.injector.unmap(Event);
        if (this.isNotBaseEventClass(eventClass)) {
            this.injector.unmap(this.mappedEventClass || eventClass);
        }
    }

    private function executeMappings(event:Event, eventClass:Class):void {
        var command:Object;
        var mapping:ICommandMapping = this.mappings.head;
        while (mapping) {
            mapping.validate();
            this.mapEventForInjection(event, eventClass);
            command = this.factory.create(mapping);
            this.unmapEventForInjection(eventClass);
            if (command) {
                this.removeMappingIfFireOnce(mapping);
                command.execute();
            }
            mapping = mapping.next;
        }
    }

    private function removeMappingIfFireOnce(mapping:ICommandMapping):void {
        if (mapping.fireOnce) {
            this.trigger.removeMapping(mapping);
        }
    }

}
}
