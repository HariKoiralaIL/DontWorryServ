package commandcenter {
import commands.ICommandMapper;
import commands.ICommandUnmapper;
import commands.ICommandMappingConfig;

import commands.ICommandTrigger;
import commands.ICommandMapping;

import flash.utils.Dictionary;

public class CommandMapper implements ICommandMapper, ICommandUnmapper {

    private const mappings:Dictionary = new Dictionary();
    private var trigger:ICommandTrigger;

    public function CommandMapper(trigger:ICommandTrigger) {
        this.trigger = trigger;
    }

    public function toCommand(commandClass:Class):ICommandMappingConfig {
        return overwriteMapping(mappings[commandClass]) || createMapping(commandClass);
    }

    public function fromCommand(commandClass:Class):void {
        var mapping:ICommandMapping = mappings[commandClass];
        mapping && trigger.removeMapping(mapping);
        delete mappings[commandClass];
    }

    public function fromAll():void {
        var mapping:ICommandMapping;
        for each (mapping in mappings) {
            trigger.removeMapping(mapping);
            delete mappings[mapping.commandClass];
        }
    }

    private function createMapping(commandClass:Class):CommandMapping {
        var mapping:CommandMapping = new CommandMapping(commandClass);
        trigger.addMapping(mapping);
        mappings[commandClass] = mapping;
        return mapping;
    }

    private function overwriteMapping(mapping:CommandMapping):CommandMapping {
        if (!mapping) {
            return null;
        }
        mapping.invalidate();
        return mapping;
    }

}
}
