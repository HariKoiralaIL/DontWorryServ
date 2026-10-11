package client.tasks {

/** Task that calls a function and then completes successfully. */
public class CallbackTask extends Task {

    private var callback:Function;
    private var args:Array;

    public function CallbackTask(callback:Function, ...args) {
        this.callback = callback;
        this.args = args;
    }

    override protected function startTask():void {
        callback.apply(args);
        complete(true);
    }

}
}
