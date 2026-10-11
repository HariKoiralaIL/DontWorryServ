package client.tasks {

/** Runs its tasks one after another. Stops and fails as soon as one task fails. */
public class SequenceTask extends Task {

    private var tasks:Vector.<Task>;
    private var nextIndex:int;

    public function SequenceTask() {
        tasks = new Vector.<Task>();
    }

    public function add(task:Task):void {
        tasks.push(task);
    }

    override protected function startTask():void {
        nextIndex = 0;
        runNext();
    }

    override protected function onReset():void {
        var task:Task;
        for each (task in tasks) {
            task.reset();
        }
    }

    private function runNext():void {
        if (hasNext()) {
            startNext();
        } else {
            complete(true);
        }
    }

    private function hasNext():Boolean {
        return nextIndex < tasks.length;
    }

    private function startNext():void {
        var task:Task = tasks[nextIndex++];
        task.internalCompleted.addOnce(onTaskCompleted);
        task.start();
    }

    private function onTaskCompleted(task:Task, success:Boolean, error:String):void {
        if (success) {
            runNext();
        } else {
            complete(false, error);
        }
    }

}
}
