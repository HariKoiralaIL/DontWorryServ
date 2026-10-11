package game.dialogs {
    import flash.events.Event;

    public class NotEnoughKeysDialog extends Dialog {

        public function NotEnoughKeysDialog() {
            super("You do not have enough Keys for this item.  You gain Keys when you kill Bosses in Dungeons!", "Not Enough Keys", "Ok", null, "/notEnoughKeys");
            addEventListener(BUTTON1_EVENT, this.onOk);
        }

        public function onOk(e:Event):void {
            close();
        }
    }
}
