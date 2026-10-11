package com.company.assembleegameclient.objects {
    import client.ui.panels.ForgePanel;
    import client.ui.panels.Panel;

    import com.company.assembleegameclient.game.GameSprite;

    public class Forge extends GameObject implements _G_4 {

        public function Forge(param1:XML) {
            super(param1);
            _064 = true;
        }

        public function getPanel(param1:GameSprite):Panel {
            return new ForgePanel(param1, this);
        }
    }
}