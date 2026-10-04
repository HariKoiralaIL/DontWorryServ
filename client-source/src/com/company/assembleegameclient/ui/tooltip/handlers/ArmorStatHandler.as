// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.handlers.ArmorStatHandler

package com.company.assembleegameclient.ui.tooltip.handlers {
public class ArmorStatHandler extends SlotStatHandler {

    private static const DEFENSE_STAT:String = "21";

    public function ArmorStatHandler() {
        tooltipText = "";
    }
    private var defenseTags:XMLList;
    private var curDefenseTags:XMLList;

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var defense:int;
        var otherDefense:int;
        this.defenseTags = itemXML.ActivateOnEquip.(@stat == DEFENSE_STAT);
        this.curDefenseTags = curItemXML.ActivateOnEquip.(@stat == DEFENSE_STAT);
        if ((((this.defenseTags.length() == 1)) && ((this.curDefenseTags.length() == 1)))) {
            defense = int(this.defenseTags.@amount);
            otherDefense = int(this.curDefenseTags.@amount);
            onEquipText[this.defenseTags[0].toXMLString()] = this.defenseLine(defense, otherDefense);
        }
    }

    private function defenseLine(_arg1:int, _arg2:int):String {
        var _local3:String = compareColor((_arg1 - _arg2));
        return (colorize((("+" + _arg1) + " Defense"), _local3));
    }

}
}//package com.company.assembleegameclient.ui.tooltip.handlers

