package client.tasks {
import signals.Signal;

/** Task that dispatches a signal with the given arguments and then completes successfully. */
public class DispatchSignalTask extends Task {

    private var signal:Signal;
    private var args:Array;

    public function DispatchSignalTask(signal:Signal, ...args) {
        this.signal = signal;
        this.args = args;
    }

    override protected function startTask():void {
        signal.dispatch.apply(null, args);
        complete(true);
    }

}
}
