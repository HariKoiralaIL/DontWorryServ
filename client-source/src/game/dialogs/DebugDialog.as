package game.dialogs {
    import flash.events.Event;

    public class DebugDialog extends Dialog {

        public function DebugDialog(message:String) {
            super(message, "Debug", "OK", null, null);
            addEventListener(BUTTON1_EVENT, this.onOk);
        }

        private function onOk(e:Event):void {
            close();
        }
    }
}
