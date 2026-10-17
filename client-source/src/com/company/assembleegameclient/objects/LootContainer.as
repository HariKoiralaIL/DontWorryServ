package com.company.assembleegameclient.objects {
    import com.company.util.PointUtil;

    import audio.SoundEffects;

    import com.company.assembleegameclient.map.GameMap;

    import client.ui.panels.ContainerPanel;

    import com.company.assembleegameclient.game.GameSprite;

    import client.ui.panels.Panel;

    public class LootContainer extends GameObject implements IInteractable {

        public function LootContainer(xml:XML) {
            super(xml);
            isInteractive_ = true;
            this.isLoot_ = xml.hasOwnProperty("Loot");
            this.ownerId_ = -1;
        }
        public var isLoot_:Boolean;
        public var ownerId_:int;

        override public function addTo(map:GameMap, x:Number, y:Number):Boolean {
            if (!super.addTo(map, x, y)) {
                return (false);
            }
            if (map_.player_ == null) {
                return (true);
            }
            var _local4:Number = PointUtil.distanceXY(map_.player_.x_, map_.player_.y_, x, y);
            if (((this.isLoot_) && ((_local4 < 10)))) {
                SoundEffects.play("loot_appears");
            }
            return (true);
        }

        public function setOwnerId(ownerId:int):void {
            this.ownerId_ = ownerId;
            isInteractive_ = (((this.ownerId_ < 0)) || (this.isOwnedByPlayer()));
        }

        public function isOwnedByPlayer():Boolean {
            return ((map_.player_.accountId_ == this.ownerId_));
        }

        public function getPanel(gs:GameSprite):Panel {
            return (new ContainerPanel(gs, this));
        }

    }
}//package com.company.assembleegameclient.objects
