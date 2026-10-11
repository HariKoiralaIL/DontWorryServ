package robotlegs.bender.framework.impl {
import flash.utils.Dictionary;

import robotlegs.bender.framework.api.IMessageDispatcher;

/**
 * Dispatches messages to registered handlers, supporting synchronous handlers
 * and asynchronous handlers that signal completion through a callback.
 */
public final class MessageDispatcher implements IMessageDispatcher {

    private const _handlers:Dictionary = new Dictionary();

    public function addMessageHandler(message:Object, handler:Function):void {
        var messageHandlers:Array = _handlers[message];
        if (messageHandlers) {
            if (messageHandlers.indexOf(handler) == -1) {
                messageHandlers.push(handler);
            }
        } else {
            _handlers[message] = [handler];
        }
    }

    public function hasMessageHandler(message:Object):Boolean {
        return _handlers[message] != null;
    }

    public function removeMessageHandler(message:Object, handler:Function):void {
        var messageHandlers:Array = _handlers[message];
        var index:int = messageHandlers ? messageHandlers.indexOf(handler) : -1;
        if (index != -1) {
            messageHandlers.splice(index, 1);
            if (messageHandlers.length == 0) {
                delete _handlers[message];
            }
        }
    }

    public function dispatchMessage(message:Object, callback:Function = null, reverse:Boolean = false):void {
        var messageHandlers:Array = _handlers[message];
        if (messageHandlers) {
            messageHandlers = messageHandlers.concat();
            if (!reverse) {
                messageHandlers.reverse();
            }
            new MessageRunner(message, messageHandlers, callback).run();
        } else if (callback) {
            safelyCallBack(callback);
        }
    }

}
}

import robotlegs.bender.framework.impl.safelyCallBack;

/**
 * Runs a message's handlers one after another. Handlers are consumed from the
 * end of the array, so the dispatcher passes them in reverse order.
 */
class MessageRunner {

    private var _message:Object;
    private var _handlers:Array;
    private var _callback:Function;

    public function MessageRunner(message:Object, handlers:Array, callback:Function) {
        _message = message;
        _handlers = handlers;
        _callback = callback;
    }

    public function run():void {
        next();
    }

    private function next():void {
        var handler:Function;
        var handled:Boolean;
        while ((handler = _handlers.pop())) {
            if (handler.length == 0) {
                handler();
            } else if (handler.length == 1) {
                handler(_message);
            } else if (handler.length == 2) {
                handler(_message, function (error:Object = null, message:Object = null):void {
                    if (handled) {
                        return;
                    }
                    handled = true;
                    if (error || _handlers.length == 0) {
                        if (_callback) {
                            safelyCallBack(_callback, error, _message);
                        }
                    } else {
                        next();
                    }
                });
                return;
            } else {
                throw new Error("Bad handler signature");
            }
        }
        if (_callback) {
            safelyCallBack(_callback, null, _message);
        }
    }

}
