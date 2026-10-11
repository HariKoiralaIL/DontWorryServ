package robotlegs.bender.framework.api {
public interface ILogTarget {

    function log(source:Object, level:uint, timestamp:int, message:String, params:Array = null):void;

}
}//package robotlegs.bender.framework.api
