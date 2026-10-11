package client.ui.panels {
import account.Account;

import com.company.assembleegameclient.game.GameSprite;

public class BuyGoldPanel extends InteractButtonPanel {

    public function BuyGoldPanel(gs:GameSprite) {
        super(gs, "Buy Realm Gold", "Buy");
        Account.getInstance().cacheOffers();
    }

    override protected function onInteract():void {
        Account.getInstance().showMoneyManagement(stage);
    }
}
}
