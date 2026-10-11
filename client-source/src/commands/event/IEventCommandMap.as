package commands.event {
import commands.ICommandMapper;
import commands.ICommandUnmapper;

public interface IEventCommandMap {

    function map(eventType:String, eventClass:Class = null):ICommandMapper;

    function unmap(eventType:String, eventClass:Class = null):ICommandUnmapper;

}
}
