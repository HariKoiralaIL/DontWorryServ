package com.company.assembleegameclient.objects {

    import client.ui.panels.Panel;
    import client.ui.panels.TextPanel;

    import com.company.assembleegameclient.game.GameSprite;

    public class ClosedGiftChest extends GameObject implements IInteractable {

        public function ClosedGiftChest(xml:XML) {
            super(xml);
        }

        public function getPanel(gs:GameSprite):Panel {
            return (new TextPanel(gs));
        }

    }
}//package com.company.assembleegameclient.objects
