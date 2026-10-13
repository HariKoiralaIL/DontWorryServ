package com.company.assembleegameclient.objects {
    import com.company.assembleegameclient.game.GameSprite;

    import client.ui.panels.Panel;
    import client.ui.panels.ReforgePanel;

    public class Reforge extends GameObject implements IInteractable {
        public function Reforge(xml:XML) {
            super(xml);
            this.isInteractive_ = true;
        }

        public function getPanel(gs:GameSprite):Panel {
            return new ReforgePanel(gs, this);
        }
    }
}
