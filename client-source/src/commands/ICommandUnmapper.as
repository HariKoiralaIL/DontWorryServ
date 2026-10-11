package commands {

public interface ICommandUnmapper {

    function fromCommand(commandClass:Class):void;

    function fromAll():void;

}
}