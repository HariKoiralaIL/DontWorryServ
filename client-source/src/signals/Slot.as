package signals {
public class Slot implements ISlot {

    protected var _signal:IOnceSignal;
    protected var _enabled:Boolean = true;
    protected var _listener:Function;
    protected var _priority:int = 0;
    protected var _params:Array;
    protected var _once:Boolean = false;

    public function Slot(listener:Function, signal:IOnceSignal, once:Boolean = false, priority:int = 0) {
        _listener = listener;
        _once = once;
        _signal = signal;
        _priority = priority;
        verifyListener(listener);
    }

    public function get once():Boolean {
        return _once;
    }

    public function get listener():Function {
        return _listener;
    }

    public function set listener(value:Function):void {
        if (null == value) {
            throw new ArgumentError("Given listener is null.\nDid you want to set enabled to false instead?");
        }
        verifyListener(value);
        _listener = value;
    }

    public function get priority():int {
        return _priority;
    }

    public function get enabled():Boolean {
        return _enabled;
    }

    public function set enabled(value:Boolean):void {
        _enabled = value;
    }

    public function get params():Array {
        return _params;
    }

    public function set params(value:Array):void {
        _params = value;
    }

    public function execute0():void {
        if (!_enabled) {
            return;
        }
        if (_once) {
            remove();
        }
        if (_params && _params.length) {
            _listener.apply(null, _params);
            return;
        }
        _listener();
    }

    public function execute1(value:Object):void {
        if (!_enabled) {
            return;
        }
        if (_once) {
            remove();
        }
        if (_params && _params.length) {
            _listener.apply(null, [value].concat(_params));
            return;
        }
        _listener(value);
    }

    public function execute(valueObjects:Array):void {
        if (!_enabled) {
            return;
        }
        if (_once) {
            remove();
        }
        if (_params && _params.length) {
            valueObjects = valueObjects.concat(_params);
        }
        var len:int = valueObjects.length;
        if (len == 0) {
            _listener();
        } else if (len == 1) {
            _listener(valueObjects[0]);
        } else if (len == 2) {
            _listener(valueObjects[0], valueObjects[1]);
        } else if (len == 3) {
            _listener(valueObjects[0], valueObjects[1], valueObjects[2]);
        } else {
            _listener.apply(null, valueObjects);
        }
    }

    public function toString():String {
        return "[Slot listener: " + _listener + ", once: " + _once + ", priority: " + _priority + ", enabled: " + _enabled + "]";
    }

    public function remove():void {
        _signal.remove(_listener);
    }

    protected function verifyListener(listener:Function):void {
        if (null == listener) {
            throw new ArgumentError("Given listener is null.");
        }
        if (null == _signal) {
            throw new Error("Internal signal reference has not been set yet.");
        }
    }

}
}
