package com.company.assembleegameclient.objects {
    import client.ui.panels.MarketPanel;

    import com.company.assembleegameclient.game.GameSprite;

    import client.ui.panels.Panel;

    public class MarketplaceGround extends GameObject implements IInteractable {

        public function MarketplaceGround(xml:XML) {
            super(xml);
            isInteractive_ = true;
        }

        public function getPanel(gs:GameSprite):Panel {
            return (new MarketPanel(gs));
        }

    }
}//package com.company.assembleegameclient.objects
