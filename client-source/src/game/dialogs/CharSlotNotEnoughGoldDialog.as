package game.dialogs {
    public class CharSlotNotEnoughGoldDialog extends BuyGoldDialog {

        public function CharSlotNotEnoughGoldDialog(price:int) {
            super("Another character slot costs " + price + " Gold.  Would you like to buy Gold?", "/charSlotNeedGold");
        }
    }
}
