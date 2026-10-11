package client.tasks {
import signals.Signal;

/** Dispatched when a task completes; carries the task, a success flag and an error message. */
public class TaskCompletedSignal extends Signal {

    public function TaskCompletedSignal() {
        super(Task, Boolean, String);
    }

}
}
