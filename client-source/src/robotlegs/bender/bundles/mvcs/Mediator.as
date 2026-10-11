package robotlegs.bender.bundles.mvcs {

import flash.events.Event;
import flash.events.IEventDispatcher;

import mediators.IMediator;

import robotlegs.bender.extensions.eventManagement.api.IEventMap;

/**
 * Base class for view mediators. Keeps track of the listeners it registers
 * so they can all be removed when the mediator is destroyed.
 *
 * Note: _0F_H_ is the event map type. Its methods (_08r = add listener,
 * _0M_v = remove listener, _0I_p = remove all listeners) are left as they
 * are here, so rename them when that class is refactored.
 */
public class Mediator implements IMediator {

    [Inject]
    public var eventMap:IEventMap;
    [Inject]
    public var eventDispatcher:IEventDispatcher;

    private var _viewComponent:Object;

    public function set viewComponent(view:Object):void {
        this._viewComponent = view;
    }

    public function initialize():void {
    }

    public function destroy():void {
        this.eventMap.unmapListeners();
    }

    /** Listens to an event on the view. */
    protected function addViewListener(type:String, listener:Function, eventClass:Class = null):void {
        this.eventMap.mapListener(IEventDispatcher(this._viewComponent), type, listener, eventClass);
    }

    /** Listens to an event on the shared event dispatcher. */
    protected function addContextListener(type:String, listener:Function, eventClass:Class = null):void {
        this.eventMap.mapListener(this.eventDispatcher, type, listener, eventClass);
    }

    protected function removeViewListener(type:String, listener:Function, eventClass:Class = null):void {
        this.eventMap.unmapListener(IEventDispatcher(this._viewComponent), type, listener, eventClass);
    }

    protected function removeContextListener(type:String, listener:Function, eventClass:Class = null):void {
        this.eventMap.unmapListener(this.eventDispatcher, type, listener, eventClass);
    }

    /** Dispatches the event on the shared dispatcher, but only if something is listening. */
    protected function dispatch(event:Event):void {
        if (this.eventDispatcher.hasEventListener(event.type)) {
            this.eventDispatcher.dispatchEvent(event);
        }
    }

}
}//package robotlegs.bender.bundles.mvcs
