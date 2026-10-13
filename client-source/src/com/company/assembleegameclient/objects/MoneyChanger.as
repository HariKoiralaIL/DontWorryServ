package com.company.assembleegameclient.objects {
    import client.ui.panels.BuyGoldPanel;

    import com.company.assembleegameclient.game.GameSprite;

    import client.ui.panels.Panel;

    public class MoneyChanger extends GameObject implements IInteractable {

        public function MoneyChanger(xml:XML) {
            super(xml);
            isInteractive_ = true;
        }

        public function getPanel(gs:GameSprite):Panel {
            return (new BuyGoldPanel(gs));
        }

    }
}//package com.company.assembleegameclient.objects
