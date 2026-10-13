package com.company.assembleegameclient.objects {
    import client.ui.panels.GuildRegisterPanel;

    import com.company.assembleegameclient.game.GameSprite;

    import client.ui.panels.Panel;

    public class GuildRegister extends GameObject implements IInteractable {

        public function GuildRegister(xml:XML) {
            super(xml);
            isInteractive_ = true;
        }

        public function getPanel(gs:GameSprite):Panel {
            return (new GuildRegisterPanel(gs));
        }

    }
}//package com.company.assembleegameclient.objects
