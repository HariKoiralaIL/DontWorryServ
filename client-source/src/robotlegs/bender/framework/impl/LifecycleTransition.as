package robotlegs.bender.framework.impl {
import robotlegs.bender.framework.api.LifecycleEvent;

/**
 * One state transition of a Lifecycle (e.g. uninitialized -> initializing -> active).
 * Runs the registered "before" handlers, then dispatches the transition events.
 */
public class LifecycleTransition {

    private const _fromStates:Vector.<String> = new Vector.<String>();
    private const _dispatcher:MessageDispatcher = new MessageDispatcher();
    private const _callbacks:Array = [];

    private var _name:String;
    private var _lifecycle:Lifecycle;
    private var _transitionState:String;
    private var _finalState:String;
    private var _preTransitionEvent:String;
    private var _transitionEvent:String;
    private var _postTransitionEvent:String;
    private var _reverse:Boolean;

    public function LifecycleTransition(name:String, lifecycle:Lifecycle) {
        _name = name;
        _lifecycle = lifecycle;
    }

    public function fromStates(...states):LifecycleTransition {
        var state:String;
        for each (state in states) {
            _fromStates.push(state);
        }
        return this;
    }

    public function toStates(transitionState:String, finalState:String):LifecycleTransition {
        _transitionState = transitionState;
        _finalState = finalState;
        return this;
    }

    public function withEvents(preTransitionEvent:String, transitionEvent:String, postTransitionEvent:String):LifecycleTransition {
        _preTransitionEvent = preTransitionEvent;
        _transitionEvent = transitionEvent;
        _postTransitionEvent = postTransitionEvent;
        if (_reverse) {
            _lifecycle.addReversedEventTypes(preTransitionEvent, transitionEvent, postTransitionEvent);
        }
        return this;
    }

    public function inReverse():LifecycleTransition {
        _reverse = true;
        _lifecycle.addReversedEventTypes(_preTransitionEvent, _transitionEvent, _postTransitionEvent);
        return this;
    }

    public function addBeforeHandler(handler:Function):LifecycleTransition {
        _dispatcher.addMessageHandler(_name, handler);
        return this;
    }

    public function enter(callback:Function = null):void {
        var initialState:String;
        if (_lifecycle.state == _finalState) {
            if (callback) {
                safelyCallBack(callback, null, _name);
            }
            return;
        }
        if (_lifecycle.state == _transitionState) {
            if (callback) {
                _callbacks.push(callback);
            }
            return;
        }
        if (isInvalidTransition()) {
            reportError("Invalid transition", [callback]);
            return;
        }
        initialState = _lifecycle.state;
        if (callback) {
            _callbacks.push(callback);
        }
        setState(_transitionState);
        _dispatcher.dispatchMessage(_name, function (error:Object):void {
            var queued:Function;
            if (error) {
                setState(initialState);
                reportError(error, _callbacks);
                return;
            }
            dispatch(_preTransitionEvent);
            dispatch(_transitionEvent);
            setState(_finalState);
            var pending:Array = _callbacks.concat();
            _callbacks.length = 0;
            for each (queued in pending) {
                safelyCallBack(queued, null, _name);
            }
            dispatch(_postTransitionEvent);
        }, _reverse);
    }

    private function isInvalidTransition():Boolean {
        return _fromStates.length > 0 && _fromStates.indexOf(_lifecycle.state) == -1;
    }

    private function setState(state:String):void {
        if (state) {
            _lifecycle.setCurrentState(state);
        }
    }

    private function dispatch(type:String):void {
        if (type && _lifecycle.hasEventListener(type)) {
            _lifecycle.dispatchEvent(new LifecycleEvent(type));
        }
    }

    private function reportError(reason:Object, callbacks:Array = null):void {
        var errorEvent:LifecycleEvent;
        var callback:Function;
        var error:Error = (reason is Error) ? (reason as Error) : new Error(reason);
        if (_lifecycle.hasEventListener(LifecycleEvent.ERROR)) {
            errorEvent = new LifecycleEvent(LifecycleEvent.ERROR);
            errorEvent.error = error;
            _lifecycle.dispatchEvent(errorEvent);
            if (callbacks) {
                for each (callback in callbacks) {
                    if (callback) {
                        safelyCallBack(callback, error, _name);
                    }
                }
                callbacks.length = 0;
            }
        } else {
            throw error;
        }
    }

}
}
