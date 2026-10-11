package commands {

import flash.display.Sprite;

import env.ServerListState;

import services.LoadCharacterListTask;
import client.tasks.DispatchSignalTask;
import client.tasks.TaskTracker;
import client.tasks.SequenceTask;
import _F_1._zf;
import _U_5._dd;

/**
 * Shows `view`. If the server list is enabled, a placeholder (_zf) is
 * shown first and the real view is only dispatched once the
 * pre-load task has finished.
 */
public class ShowViewCommand {

    [Inject]
    public var serverListState:ServerListState;
    [Inject]
    public var showViewSignal:_dd;
    [Inject]
    public var view:Sprite;
    [Inject]
    public var taskMonitor:TaskTracker;
    [Inject]
    public var preloadTask:LoadCharacterListTask;

    public function execute():void {
        if (this.serverListState.enabled) {
            this.showAfterPreload();
        } else {
            this.showViewSignal.dispatch(this.view);
        }
    }

    private function showAfterPreload():void {
        this.showViewSignal.dispatch(new _zf());
        var taskGroup:SequenceTask = new SequenceTask();
        taskGroup.add(this.preloadTask);
        taskGroup.add(new DispatchSignalTask(this.showViewSignal, this.view));
        this.taskMonitor.add(taskGroup);
        taskGroup.start();
    }

}
}
