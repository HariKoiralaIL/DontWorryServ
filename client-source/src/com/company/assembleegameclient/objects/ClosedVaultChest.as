package com.company.assembleegameclient.objects {
    import com.company.assembleegameclient.ui.tooltip.TitleDescriptionToolTip;
    import com.company.assembleegameclient.ui.tooltip.ToolTip;

    import flash.display.BitmapData;

    public class ClosedVaultChest extends SellableObject {

        public function ClosedVaultChest(xml:XML) {
            super(xml);
        }

        override public function soldObjectName():String {
            return ("Vault Chest");
        }

        override public function soldObjectInternalName():String {
            return ("Vault Chest");
        }

        override public function getTooltip():ToolTip {
            return (new TitleDescriptionToolTip(0x2A2A2A, 0x9B9B9B, this.soldObjectName(), ("A chest that will safely store 8 items and is " + "accessible by all of your characters."), 200));
        }

        override public function getIcon():BitmapData {
            return (ObjectLibrary.getRedrawnTextureFromType(ObjectLibrary.idToType_["Vault Chest"], 80, true));
        }

    }
}//package com.company.assembleegameclient.objects
