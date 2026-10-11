package mediators {

public interface IMediatorMapper {

    function toMediator(mediatorClass:Class):IMediatorMappingConfig;

}
}