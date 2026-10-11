package robotlegs.bender.extensions.viewManager.impl {
import views.IViewHandler;

import flash.display.DisplayObjectContainer;
import flash.events.Event;

/** Dispatched by the ViewManager when containers or view handlers are added or removed. */
public class ViewManagerEvent extends Event {

    public static const CONTAINER_ADD:String = "containerAdd";
    public static const CONTAINER_REMOVE:String = "containerRemove";
    public static const HANDLER_ADD:String = "handlerAdd";
    public static const HANDLER_REMOVE:String = "handlerRemove";

    private var _container:DisplayObjectContainer;
    private var _handler:IViewHandler;

    public function ViewManagerEvent(type:String, container:DisplayObjectContainer = null, handler:IViewHandler = null) {
        super(type);
        _container = container;
        _handler = handler;
    }

    public function get handler():IViewHandler {
        return _handler;
    }

    public function get container():DisplayObjectContainer {
        return _container;
    }

    override public function clone():Event {
        return new ViewManagerEvent(type, _container, _handler);
    }

}
}
