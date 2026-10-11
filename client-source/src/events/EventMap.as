package events {
import robotlegs.bender.extensions.eventManagement.api.IEventMap;

import flash.events.Event;
import flash.events.IEventDispatcher;

public class EventMap implements IEventMap {

    private const _listeners:Vector.<EventMapConfig> = new Vector.<EventMapConfig>();
    private const _suspendedListeners:Vector.<EventMapConfig> = new Vector.<EventMapConfig>();
    private var _eventDispatcher:IEventDispatcher;
    private var _suspended:Boolean = false;

    public function EventMap(eventDispatcher:IEventDispatcher) {
        _eventDispatcher = eventDispatcher;
    }

    public function mapListener(dispatcher:IEventDispatcher, eventString:String, listener:Function, eventClass:Class = null, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void {
        var config:EventMapConfig;
        var callback:Function;
        eventClass = eventClass || Event;
        var currentListeners:Vector.<EventMapConfig> = _suspended ? _suspendedListeners : _listeners;
        var i:int = currentListeners.length - 1;
        while (i >= 0) {
            config = currentListeners[i];
            if (matches(config, dispatcher, eventString, listener, eventClass, useCapture)) {
                return;
            }
            i--;
        }
        if (eventClass != Event) {
            callback = function (event:Event):void {
                routeEventToListener(event, listener, eventClass);
            };
        } else {
            callback = listener;
        }
        config = new EventMapConfig(dispatcher, eventString, listener, eventClass, callback, useCapture);
        currentListeners.push(config);
        if (!_suspended) {
            dispatcher.addEventListener(eventString, callback, useCapture, priority, useWeakReference);
        }
    }

    public function unmapListener(dispatcher:IEventDispatcher, eventString:String, listener:Function, eventClass:Class = null, useCapture:Boolean = false):void {
        var config:EventMapConfig;
        eventClass = eventClass || Event;
        var currentListeners:Vector.<EventMapConfig> = _suspended ? _suspendedListeners : _listeners;
        var i:int = currentListeners.length;
        while (i--) {
            config = currentListeners[i];
            if (matches(config, dispatcher, eventString, listener, eventClass, useCapture)) {
                if (!_suspended) {
                    dispatcher.removeEventListener(eventString, config.callback, useCapture);
                }
                currentListeners.splice(i, 1);
                return;
            }
        }
    }

    public function unmapListeners():void {
        var config:EventMapConfig;
        var currentListeners:Vector.<EventMapConfig> = _suspended ? _suspendedListeners : _listeners;
        while ((config = currentListeners.pop())) {
            if (!_suspended) {
                config.dispatcher.removeEventListener(config.eventString, config.callback, config.useCapture);
            }
        }
    }

    public function suspend():void {
        var config:EventMapConfig;
        if (_suspended) {
            return;
        }
        _suspended = true;
        while ((config = _listeners.pop())) {
            config.dispatcher.removeEventListener(config.eventString, config.callback, config.useCapture);
            _suspendedListeners.push(config);
        }
    }

    public function resume():void {
        var config:EventMapConfig;
        if (!_suspended) {
            return;
        }
        _suspended = false;
        while ((config = _suspendedListeners.pop())) {
            config.dispatcher.addEventListener(config.eventString, config.callback, config.useCapture);
            _listeners.push(config);
        }
    }

    private function matches(config:EventMapConfig, dispatcher:IEventDispatcher, eventString:String, listener:Function, eventClass:Class, useCapture:Boolean):Boolean {
        return config.dispatcher == dispatcher
            && config.eventString == eventString
            && config.listener == listener
            && config.useCapture == useCapture
            && config.eventClass == eventClass;
    }

    private function routeEventToListener(event:Event, listener:Function, originalEventClass:Class):void {
        if (event is originalEventClass) {
            listener(event);
        }
    }

}
}
