package com.company.assembleegameclient.objects {
    import client.ui.panels.ForgePanel;
    import client.ui.panels.Panel;

    import com.company.assembleegameclient.game.GameSprite;

    public class Forge extends GameObject implements IInteractable {

        public function Forge(xml:XML) {
            super(xml);
            isInteractive_ = true;
        }

        public function getPanel(gs:GameSprite):Panel {
            return new ForgePanel(gs, this);
        }
    }
}
