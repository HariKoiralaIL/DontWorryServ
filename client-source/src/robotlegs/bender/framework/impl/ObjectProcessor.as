package robotlegs.bender.framework.impl {
import _qj._pn;

/**
 * Passes objects through a list of (matcher, handler) pairs.
 */
public class ObjectProcessor {

    private const _handlers:Array = [];

    public function addObjectHandler(matcher:_pn, handler:Function):void {
        _handlers.push(new ObjectHandler(matcher, handler));
    }

    public function processObject(object:Object):void {
        var handler:ObjectHandler;
        for each (handler in _handlers) {
            handler.handle(object);
        }
    }

}
}

import _qj._pn;

class ObjectHandler {

    private var _matcher:_pn;
    private var _handler:Function;

    public function ObjectHandler(matcher:_pn, handler:Function) {
        _matcher = matcher;
        _handler = handler;
    }

    public function handle(object:Object):void {
        if (_matcher.matches(object)) {
            _handler(object);
        }
    }

}
