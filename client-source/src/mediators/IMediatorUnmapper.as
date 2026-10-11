package mediators {

public interface IMediatorUnmapper {

    function fromMediator(mediatorClass:Class):void;

    function fromMediators():void;

}
}