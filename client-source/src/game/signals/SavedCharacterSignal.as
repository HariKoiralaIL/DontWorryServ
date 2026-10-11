package game.signals {
    import signals.Signal;
    import com.company.assembleegameclient.appengine.SavedCharacter;

    public class SavedCharacterSignal extends Signal {

        public function SavedCharacterSignal() {
            super(SavedCharacter);
        }
    }
}
