package game.dialogs {
    public class NameNeedsRegistrationDialog extends Dialog {

        public function NameNeedsRegistrationDialog() {
            super("In order to select a unique name, you must be a registered user.", "Not Registered", "Cancel", "Register", "/chooseNameNeedRegister");
        }
    }
}
