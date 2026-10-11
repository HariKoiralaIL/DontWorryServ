package commands {

public interface ICommandCenter {

    function map(trigger:ICommandTrigger):ICommandMapper;

    function unmap(trigger:ICommandTrigger):ICommandUnmapper;

}
}