package robotlegs.bender.framework.impl {
import matchers.Matcher;

/**
 * Passes objects through a list of (matcher, handler) pairs.
 */
public class ObjectProcessor {

    private const _handlers:Array = [];

    public function addObjectHandler(matcher:Matcher, handler:Function):void {
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

import matchers.Matcher;

class ObjectHandler {

    private var _matcher:Matcher;
    private var _handler:Function;

    public function ObjectHandler(matcher:Matcher, handler:Function) {
        _matcher = matcher;
        _handler = handler;
    }

    public function handle(object:Object):void {
        if (_matcher.matches(object)) {
            _handler(object);
        }
    }

}
