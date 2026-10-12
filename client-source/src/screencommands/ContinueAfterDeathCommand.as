package screencommands
{
    import services.LoadCharacterListTask;

    import client.tasks.DispatchSignalTask;
    import client.tasks.TaskTracker;
    import client.tasks.SequenceTask;

    import client.ui.screens.DeathScreen;

    import game.signals.SpriteSignal2;

    import env.DeathRecord;
    import env.ServerListState;

    public class ContinueAfterDeathCommand
    {
        [Inject]
        public var deathRecord:DeathRecord;
        [Inject]
        public var serverListState:ServerListState;
        [Inject]
        public var promptTask:LoadCharacterListTask;
        [Inject]
        public var taskMonitor:TaskTracker;
        [Inject]
        public var setScreenSignal:SpriteSignal2;

        public function execute():void
        {
            if (this.serverListState.servers.accountId_ == -1 && this.deathRecord._sr)
            {
                this.runPromptSequence();
            }
            else
            {
                this.setScreenSignal.dispatch(new DeathScreen());
            }
        }

        private function runPromptSequence():void
        {
            this.deathRecord._dA_ = true;
            var sequence:SequenceTask = new SequenceTask();
            sequence.add(this.promptTask);
            sequence.add(new DispatchSignalTask(this.setScreenSignal, new DeathScreen()));
            this.taskMonitor.add(sequence);
            sequence.start();
        }
    }
}
