package commandcenter {
import commands.ICommandCenter;
import commands.ICommandTrigger;

import commands.ICommandUnmapper;
import commands.ICommandMapper;

import flash.utils.Dictionary;

public class CommandCenter implements commands.ICommandCenter  {

    private const mappers:Dictionary = new Dictionary();
    private const NULL_UNMAPPER:ICommandUnmapper = new NullCommandUnmapper();

    public function map(trigger:ICommandTrigger):ICommandMapper {
        return mappers[trigger] = mappers[trigger] || new CommandMapper(trigger);
    }

    public function unmap(trigger:ICommandTrigger):ICommandUnmapper {
        return mappers[trigger] || NULL_UNMAPPER;
    }

}
}
