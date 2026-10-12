package game.signals {
    import signals.Signal;
    import com.company.assembleegameclient.net.messages.incoming.Death;

    public class DeathSignal extends Signal {

        public function DeathSignal() {
            super(Death);
        }
    }
}
