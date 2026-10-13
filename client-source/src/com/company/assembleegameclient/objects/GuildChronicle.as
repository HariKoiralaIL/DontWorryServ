package com.company.assembleegameclient.objects {
    import client.ui.panels.GuildChroniclePanel;

    import com.company.assembleegameclient.game.GameSprite;

    import client.ui.panels.Panel;

    public class GuildChronicle extends GameObject implements IInteractable {

        public function GuildChronicle(xml:XML) {
            super(xml);
            isInteractive_ = true;
        }

        public function getPanel(gs:GameSprite):Panel {
            return (new GuildChroniclePanel(gs));
        }

    }
}//package com.company.assembleegameclient.objects
