package com.company.assembleegameclient.ui.tooltip.handlers {
public class ArmorStatHandler extends SlotStatHandler {

    private static const DEFENSE_STAT:String = "21";

    public function ArmorStatHandler() {
        tooltipText = "";
    }

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var defenseTags:XMLList = itemXML.ActivateOnEquip.(@stat == DEFENSE_STAT);
        var curDefenseTags:XMLList = curItemXML.ActivateOnEquip.(@stat == DEFENSE_STAT);
        if (defenseTags.length() == 1 && curDefenseTags.length() == 1) {
            var defense:int = int(defenseTags.@amount);
            var curDefense:int = int(curDefenseTags.@amount);
            onEquipText[defenseTags[0].toXMLString()] = defenseLine(defense, curDefense);
        }
    }

    private function defenseLine(defense:int, curDefense:int):String {
        return colorize("+" + defense + " Defense", compareColor(defense - curDefense));
    }

}
}
