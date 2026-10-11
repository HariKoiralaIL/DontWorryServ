package client.tasks {

/** Keeps track of tasks until they complete. Tasks are added but not started here. */
public class TaskTracker {

    private var tasks:Vector.<Task>;

    public function TaskTracker() {
        tasks = new <Task>[];
    }

    public function add(task:Task):void {
        tasks.push(task);
        task.completed.addOnce(onTaskCompleted);
    }

    public function contains(task:Task):Boolean {
        return tasks.indexOf(task) != -1;
    }

    private function onTaskCompleted(task:Task, success:Boolean, error:String = ""):void {
        tasks.splice(tasks.indexOf(task), 1);
    }

}
}
