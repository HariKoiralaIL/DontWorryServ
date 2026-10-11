package client.tasks {
import flash.errors.IllegalOperationError;

import signals.Signal;

/**
 * Base class for an asynchronous unit of work. Subclasses override startTask()
 * and call complete() when they finish.
 */
public class Task {

    private var _startedSignal:TaskStartedSignal;
    private var _completedSignal:TaskCompletedSignal;
    private var _internalCompletedSignal:TaskCompletedSignal;
    private var _hasStarted:Boolean;
    private var _hasCompleted:Boolean;
    private var _succeeded:Boolean;
    private var _error:String;

    /** Error message passed to complete(), if any. */
    public function get error():String {
        return _error;
    }

    /** Dispatched when the task starts. */
    final public function get started():Signal {
        _startedSignal = _startedSignal || new TaskStartedSignal();
        return _startedSignal;
    }

    /** Dispatched when the task completes, before internalCompleted. */
    final public function get completed():TaskCompletedSignal {
        _completedSignal = _completedSignal || new TaskCompletedSignal();
        return _completedSignal;
    }

    public function get hasStarted():Boolean {
        return _hasStarted;
    }

    public function get hasCompleted():Boolean {
        return _hasCompleted;
    }

    public function get succeeded():Boolean {
        return _succeeded;
    }

    /** Completion signal reserved for classes in this package (e.g. SequenceTask). */
    internal final function get internalCompleted():TaskCompletedSignal {
        _internalCompletedSignal = _internalCompletedSignal || new TaskCompletedSignal();
        return _internalCompletedSignal;
    }

    final public function start():void {
        if (!_hasStarted) {
            _hasStarted = true;
            if (_startedSignal) {
                _startedSignal.dispatch(this);
            }
            startTask();
        }
    }

    final public function reset():void {
        if (_hasStarted) {
            _hasStarted = false;
            if (!_hasCompleted) {
                throw new IllegalOperationError("Unable to Task.reset() when a task is ongoing");
            }
        }
        if (_startedSignal) {
            _startedSignal.removeAll();
        }
        if (_completedSignal) {
            _completedSignal.removeAll();
        }
        if (_internalCompletedSignal) {
            _internalCompletedSignal.removeAll();
        }
        onReset();
    }

    /** Override to perform the work; call complete() when done. */
    protected function startTask():void {
    }

    /** Override to clear any state when the task is reset. */
    protected function onReset():void {
    }

    final protected function complete(success:Boolean, error:String = ""):void {
        _succeeded = success;
        _error = error;
        _hasCompleted = true;
        if (_completedSignal) {
            _completedSignal.dispatch(this, success, error);
        }
        if (_internalCompletedSignal) {
            _internalCompletedSignal.dispatch(this, success, error);
        }
    }

}
}
