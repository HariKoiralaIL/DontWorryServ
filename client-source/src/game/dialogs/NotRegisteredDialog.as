package game.dialogs {
    import account.Account;

    import flash.events.Event;

    public class NotRegisteredDialog extends Dialog {

        public function NotRegisteredDialog(message:String) {
            super(message, "Not Registered", "Cancel", "Register", "/needRegister");
            addEventListener(BUTTON1_EVENT, this.onCancel);
            addEventListener(BUTTON2_EVENT, this.onRegister);
        }

        private function onCancel(e:Event):void {
            close();
        }

        private function onRegister(e:Event):void {
            Account.getInstance().showInGameRegister(stage);
            close();
        }
    }
}
