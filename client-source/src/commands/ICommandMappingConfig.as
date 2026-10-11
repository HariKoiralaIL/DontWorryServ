package commands {

public interface ICommandMappingConfig {

    function withGuards(... guards):ICommandMappingConfig;

    function withHooks(... hooks):ICommandMappingConfig;

    function once(value:Boolean = true):ICommandMappingConfig;

}
}