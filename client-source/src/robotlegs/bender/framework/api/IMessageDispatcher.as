package robotlegs.bender.framework.api {
public interface IMessageDispatcher {

    function addMessageHandler(message:Object, handler:Function):void;

    function removeMessageHandler(message:Object, handler:Function):void;

    function hasMessageHandler(message:Object):Boolean;

    function dispatchMessage(message:Object, callback:Function = null, reverse:Boolean = false):void;

}
}//package robotlegs.bender.framework.api
