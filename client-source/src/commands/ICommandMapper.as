package commands {

public interface ICommandMapper {

    function toCommand(commandClass:Class):ICommandMappingConfig;

}
}