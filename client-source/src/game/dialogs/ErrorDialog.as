package game.dialogs {
    public class ErrorDialog extends Dialog {

        public function ErrorDialog(message:String) {
            super("An error has occured:\n" + message, "D'oh, this isn't good", "Ok", null, "/error");
        }
    }
}
