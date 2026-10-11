package mediators {

public interface IMediatorMappingFinder {

    function forMediator(mediatorClass:Class):IMediatorMapping;

}
}