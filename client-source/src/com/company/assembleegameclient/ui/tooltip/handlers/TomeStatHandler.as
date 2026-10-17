package com.company.assembleegameclient.ui.tooltip.handlers {
public class TomeStatHandler extends SlotStatHandler {

    private static const PURIFICATION:String = "Tome of Purification";
    private static const HOLY_PROTECTION:String = "Tome of Holy Protection";

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var nova:XMLList = activateTags(itemXML, "HealNova");
        var curNova:XMLList = activateTags(curItemXML, "HealNova");
        tooltipText = "";
        if (nova.length() == 1 && curNova.length() == 1) {
            var range:int = int(itemXML.Activate.@range);
            var curRange:int = int(curItemXML.Activate.@range);
            var amount:int = int(itemXML.Activate.@amount);
            var curAmount:int = int(curItemXML.Activate.@amount);
            var score:Number = 0.5 * range + 0.5 * amount;
            var curScore:Number = 0.5 * curRange + 0.5 * curAmount;
            if (itemXML.@id == PURIFICATION) {
                range = 6;
            }
            var text:String = amount + " HP within " + range + " sqrs\n";
            tooltipText += "Party Heal: " + colorize(text, compareColor(score - curScore));
            handledXml[nova.toXMLString()] = true;
        }
        addUniqueEffect(itemXML);
    }

    private function addUniqueEffect(itemXML:XML):void {
        var tag:XML;
        if (itemXML.@id == PURIFICATION) {
            tag = activateTags(itemXML, "RemoveNegativeConditions")[0];
            tooltipText += colorize("Removes negative conditions\n", PURPLE);
            handledXml[tag.toXMLString()] = true;
        } else if (itemXML.@id == HOLY_PROTECTION) {
            tag = activateTags(itemXML, "ConditionEffectSelf")[0];
            tooltipText += selfEffectLine("Armored", tag.@duration, PURPLE);
            handledXml[tag.toXMLString()] = true;
        }
    }

}
}
