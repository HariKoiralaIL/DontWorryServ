package game.dialogs {
    public class NotEnoughGoldDialog extends BuyGoldDialog {

        public function NotEnoughGoldDialog() {
            super("You do not have enough Gold for this item.  Would you like to buy Gold?", "/notEnoughGold");
        }
    }
}
