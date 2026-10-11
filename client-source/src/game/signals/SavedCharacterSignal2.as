package game.signals {
    import signals.Signal;
    import com.company.assembleegameclient.appengine.SavedCharacter;

    public class SavedCharacterSignal2 extends Signal {

        public function SavedCharacterSignal2() {
            super(SavedCharacter);
        }
    }
}
