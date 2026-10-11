package events {
import flash.events.IEventDispatcher;

public class EventMapConfig {

    private var _dispatcher:IEventDispatcher;
    private var _eventString:String;
    private var _listener:Function;
    private var _eventClass:Class;
    private var _callback:Function;
    private var _useCapture:Boolean;

    public function EventMapConfig(dispatcher:IEventDispatcher, eventString:String, listener:Function, eventClass:Class, callback:Function, useCapture:Boolean) {
        _dispatcher = dispatcher;
        _eventString = eventString;
        _listener = listener;
        _eventClass = eventClass;
        _callback = callback;
        _useCapture = useCapture;
    }

    public function get dispatcher():IEventDispatcher {
        return _dispatcher;
    }

    public function get eventString():String {
        return _eventString;
    }

    public function get listener():Function {
        return _listener;
    }

    public function get eventClass():Class {
        return _eventClass;
    }

    public function get callback():Function {
        return _callback;
    }

    public function get useCapture():Boolean {
        return _useCapture;
    }

}
}
