package ui.mediators {
import client.ui.screens.CurrentCharacterScreen;

import client.tasks.Task;

import com.company.assembleegameclient.appengine.SavedCharacter;

import game.dialogs.DeletingCharacterDialog;
import game.signals.NoArgSignal4;
import game.signals.SpriteSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

import services.DeleteCharacterTask;

/** Mediator for the "deleting character" progress dialog. Runs the delete task, then refreshes the character screen. */
public class DeletingCharacterDialogMediator extends Mediator {

    [Inject]
    public var view:DeletingCharacterDialog;
    [Inject]
    public var character:SavedCharacter;
    [Inject]
    public var deleteTask:DeleteCharacterTask;
    [Inject]
    public var reloadCharListSignal:NoArgSignal4;
    [Inject]
    public var setScreenSignal:SpriteSignal;

    override public function initialize():void {
        this.deleteTask.completed.addOnce(this.onDeleteCompleted);
        this.deleteTask.start();
    }

    private function onDeleteCompleted(task:Task, isOk:Boolean, error:String = ""):void {
        this.view.parent.removeChild(this.view);
        this.reloadCharListSignal.dispatch();
        this.setScreenSignal.dispatch(new CurrentCharacterScreen());
    }

}
}
