package com.company.assembleegameclient.objects {
    import client.ui.panels.ChangeCharactersPanel;

    import com.company.assembleegameclient.game.GameSprite;

    import client.ui.panels.Panel;

    public class CharacterChanger extends GameObject implements IInteractable {

        public function CharacterChanger(xml:XML) {
            super(xml);
            isInteractive_ = true;
        }

        public function getPanel(gs:GameSprite):Panel {
            return (new ChangeCharactersPanel(gs));
        }

    }
}//package com.company.assembleegameclient.objects
