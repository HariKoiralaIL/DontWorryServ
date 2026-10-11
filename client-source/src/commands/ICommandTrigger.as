package commands {

public interface ICommandTrigger {

    function addMapping(mapping:ICommandMapping):void;

    function removeMapping(mapping:ICommandMapping):void;

}
}