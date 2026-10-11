package game.dialogs {
    import account.Account;

    import flash.events.Event;

    /** Base for "not enough gold" prompts offering to open the gold shop. */
    public class BuyGoldDialog extends Dialog {

        public function BuyGoldDialog(message:String, analyticsPage:String) {
            super(message, "Not Enough Gold", "Cancel", "Buy Gold", analyticsPage);
            Account.getInstance().cacheOffers();
            addEventListener(BUTTON1_EVENT, this.onCancel);
            addEventListener(BUTTON2_EVENT, this.onBuyGold);
        }

        public function onCancel(e:Event):void {
            close();
        }

        public function onBuyGold(e:Event):void {
            Account.getInstance().showMoneyManagement(stage);
            close();
        }
    }
}
