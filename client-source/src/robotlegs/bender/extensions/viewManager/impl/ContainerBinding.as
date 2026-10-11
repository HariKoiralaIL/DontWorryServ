package robotlegs.bender.extensions.viewManager.impl {
import views.IViewHandler;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.EventDispatcher;

/**
 * Holds the view handlers attached to one container and forwards views to them.
 * Dispatches BINDING_EMPTY when its last handler is removed.
 */
public class ContainerBinding extends EventDispatcher {

    private const _handlers:Vector.<IViewHandler> = new Vector.<IViewHandler>();

    private var _container:DisplayObjectContainer;
    private var _parent:ContainerBinding;

    public function ContainerBinding(container:DisplayObjectContainer) {
        _container = container;
    }

    public function get parent():ContainerBinding {
        return _parent;
    }

    public function set parent(value:ContainerBinding):void {
        _parent = value;
    }

    public function get container():DisplayObjectContainer {
        return _container;
    }

    public function get numHandlers():uint {
        return _handlers.length;
    }

    public function addHandler(handler:IViewHandler):void {
        if (_handlers.indexOf(handler) > -1) {
            return;
        }
        _handlers.push(handler);
    }

    public function removeHandler(handler:IViewHandler):void {
        var index:int = _handlers.indexOf(handler);
        if (index > -1) {
            _handlers.splice(index, 1);
            if (_handlers.length == 0) {
                dispatchEvent(new ContainerBindingEvent(ContainerBindingEvent.BINDING_EMPTY));
            }
        }
    }

    public function handleView(view:DisplayObject, type:Class):void {
        var handler:IViewHandler;
        var count:uint = _handlers.length;
        var i:int = 0;
        while (i < count) {
            handler = _handlers[i] as IViewHandler;
            handler.handleView(view, type);
            i++;
        }
    }

}
}
