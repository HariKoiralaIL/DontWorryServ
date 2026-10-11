package mediators {

public interface IMediatorMappingConfig {

    function withGuards(... guards):IMediatorMappingConfig;

    function withHooks(... hooks):IMediatorMappingConfig;

}
}