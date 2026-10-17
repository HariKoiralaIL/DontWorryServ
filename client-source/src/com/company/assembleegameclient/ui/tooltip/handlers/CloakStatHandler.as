package com.company.assembleegameclient.ui.tooltip.handlers {
public class CloakStatHandler extends SlotStatHandler {

    private static const PLANEWALKER:String = "Cloak of the Planewalker";

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var invisible:XML = findActivateByEffect(itemXML, "ConditionEffectSelf", "Invisible");
        var curInvisible:XML = findActivateByEffect(curItemXML, "ConditionEffectSelf", "Invisible");
        tooltipText = "";
        if (invisible != null && curInvisible != null) {
            tooltipText += invisibleLine(Number(invisible.@duration), Number(curInvisible.@duration));
            handledXml[invisible.toXMLString()] = true;
        }
        addUniqueEffect(itemXML);
    }

    private function addUniqueEffect(itemXML:XML):void {
        if (itemXML.@id == PLANEWALKER) {
            tooltipText += colorize("Teleport to Target\n", PURPLE);
            var teleportTag:XML = XML(activateTags(itemXML, "Teleport"))[0];
            handledXml[teleportTag.toXMLString()] = true;
        }
    }

    private function invisibleLine(duration:Number, curDuration:Number):String {
        return selfEffectLine("Invisible", duration, compareColor(duration - curDuration));
    }

}
}
