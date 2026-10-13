package com.company.assembleegameclient.objects {
    import client.ui.panels.GuildHallPanel;

    import com.company.assembleegameclient.game.GameSprite;

    import client.ui.panels.Panel;

    public class GuildHallPortal extends GameObject implements IInteractable {

        public function GuildHallPortal(xml:XML) {
            super(xml);
            isInteractive_ = true;
        }

        public function getPanel(gs:GameSprite):Panel {
            return (new GuildHallPanel(gs, this));
        }

    }
}//package com.company.assembleegameclient.objects
