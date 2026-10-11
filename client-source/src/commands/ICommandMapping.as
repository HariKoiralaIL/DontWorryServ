package commands {

public interface ICommandMapping {

    function get commandClass():Class;

    function get guards():Array;

    function get hooks():Array;

    function get fireOnce():Boolean;

    function get next():ICommandMapping;

    function set next(value:ICommandMapping):void;

    function validate():void;

}
}