package game.dialogs {
    public class CharSlotNeedsRegistrationDialog extends Dialog {

        public function CharSlotNeedsRegistrationDialog() {
            super("In order to have more than one character slot, you must be a registered user.", "Not Registered", "Cancel", "Register", "/charSlotNeedRegister");
        }
    }
}
