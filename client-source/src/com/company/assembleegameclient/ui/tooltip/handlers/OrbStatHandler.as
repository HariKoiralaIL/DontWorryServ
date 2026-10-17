package com.company.assembleegameclient.ui.tooltip.handlers {
public class OrbStatHandler extends SlotStatHandler {

    private static const ORB_OF_CONFLICT:String = "Orb of Conflict";

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var stasis:XML = findStasisBlast(itemXML);
        var curStasis:XML = findStasisBlast(curItemXML);
        tooltipText = "";
        if (stasis != null && curStasis != null) {
            var duration:int = int(stasis.@duration);
            var curDuration:int = int(curStasis.@duration);
            tooltipText += "Stasis on group: " + colorize(duration + " secs\n", compareColor(duration - curDuration));
            handledXml[stasis.toXMLString()] = true;
            addUniqueEffect(itemXML);
        }
    }

    private function findStasisBlast(itemXML:XML):XML {
        var matches:XMLList = activateTags(itemXML, "StasisBlast");
        return matches.length() == 1 ? matches[0] : null;
    }

    private function addUniqueEffect(itemXML:XML):void {
        if (itemXML.@id != ORB_OF_CONFLICT) {
            return;
        }
        var selfTags:XMLList = activateTags(itemXML, "ConditionEffectSelf");
        var speedy:XML = selfTags.(@effect == "Speedy")[0];
        var damaging:XML = selfTags.(@effect == "Damaging")[0];
        tooltipText += selfEffectLine("Speedy", speedy.@duration, PURPLE);
        tooltipText += selfEffectLine("Damaging", damaging.@duration, PURPLE);
        handledXml[speedy.toXMLString()] = true;
        handledXml[damaging.toXMLString()] = true;
    }

}
}
