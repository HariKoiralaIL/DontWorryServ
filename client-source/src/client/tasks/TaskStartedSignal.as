package client.tasks {
import signals.Signal;

/** Dispatched when a task starts; carries the task. */
public class TaskStartedSignal extends Signal {

    public function TaskStartedSignal() {
        super(Task);
    }

}
}
