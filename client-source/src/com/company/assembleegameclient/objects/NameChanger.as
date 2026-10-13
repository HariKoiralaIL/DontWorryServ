package com.company.assembleegameclient.objects {
    import client.ui.panels.NameChangerPanel;

    import com.company.assembleegameclient.game.GameSprite;

    import client.ui.panels.Panel;

    public class NameChanger extends GameObject implements IInteractable {

        public function NameChanger(xml:XML) {
            super(xml);
            isInteractive_ = true;
        }
        public var rank_:int = 0;

        public function setRank(rank:int):void {
            this.rank_ = rank;
        }

        public function getPanel(gs:GameSprite):Panel {
            return (new NameChangerPanel(gs, this.rank_));
        }

    }
}//package com.company.assembleegameclient.objects
