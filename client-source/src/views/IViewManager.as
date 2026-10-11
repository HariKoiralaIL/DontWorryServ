package views {

import flash.display.DisplayObjectContainer;
import flash.events.IEventDispatcher;

/** Tracks the display containers being watched and the handlers notified about views added to them. */
public interface IViewManager extends IEventDispatcher {

    function get containers():Vector.<DisplayObjectContainer>;

    function addContainer(container:DisplayObjectContainer):void;

    function removeContainer(container:DisplayObjectContainer):void;

    function addViewHandler(handler:IViewHandler):void;

    function removeViewHandler(handler:IViewHandler):void;

    function removeAllHandlers():void;

}
}
