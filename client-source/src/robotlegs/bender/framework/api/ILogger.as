package robotlegs.bender.framework.api {
public interface ILogger {

    function debug(message:*, params:Array = null):void;

    function info(message:*, params:Array = null):void;

    function warn(message:*, params:Array = null):void;

    function error(message:*, params:Array = null):void;

    function fatal(message:*, params:Array = null):void;

}
}//package robotlegs.bender.framework.api
