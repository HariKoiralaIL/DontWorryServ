// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.handlers.OrbStatHandler

package com.company.assembleegameclient.ui.tooltip.handlers {
public class OrbStatHandler extends SlotStatHandler {

    override protected function compareSlots(xml4:XML, xml:XML):void {
        var xml2:XML;
        var xml3:XML;
        var _local5:int;
        var _local6:int;
        var _local7:String;
        xml2 = this.findStasisBlast(xml4);
        xml3 = this.findStasisBlast(xml);
        tooltipText = "";
        if (((!((xml2 == null))) && (!((xml3 == null))))) {
            _local5 = int(xml2.@duration);
            _local6 = int(xml3.@duration);
            _local7 = compareColor((_local5 - _local6));
            tooltipText = (tooltipText + ("Stasis on group: " + colorize((_local5 + " secs\n"), _local7)));
            handledXml[xml2.toXMLString()] = true;
            this.addUniqueEffect(xml4);
        }
    }

    private function findStasisBlast(orbXML:XML):XML {
        var matches:XMLList;
        matches = orbXML.Activate.(text() == "StasisBlast");
        return ((((matches.length()) == 1) ? matches[0] : null));
    }

    private function addUniqueEffect(itemXML:XML):void {
        var selfTags:XMLList;
        var speedy:XML;
        var damaging:XML;
        if (itemXML.@id == "Orb of Conflict") {
            selfTags = itemXML.Activate.(text() == "ConditionEffectSelf");
            speedy = selfTags.(@effect == "Speedy")[0];
            damaging = selfTags.(@effect == "Damaging")[0];
            tooltipText = (tooltipText + ("Effect on Self:\n" + colorize((("Speedy for " + speedy.@duration) + " secs\n"), PURPLE)));
            tooltipText = (tooltipText + ("Effect on Self:\n" + colorize((("Damaging for " + damaging.@duration) + "secs\n"), PURPLE)));
            handledXml[speedy.toXMLString()] = true;
            handledXml[damaging.toXMLString()] = true;
        }
    }

}
}//package com.company.assembleegameclient.ui.tooltip.handlers

