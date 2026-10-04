// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.handlers.CloakStatHandler

package com.company.assembleegameclient.ui.tooltip.handlers {
public class CloakStatHandler extends SlotStatHandler {

    override protected function compareSlots(xml5:XML, xml2:XML):void {
        var xml3:XML;
        var xml4:XML;
        var _local5:Number;
        var _local6:Number;
        xml3 = this.findInvisibleEffect(xml5);
        xml4 = this.findInvisibleEffect(xml2);
        tooltipText = "";
        if (((!((xml3 == null))) && (!((xml4 == null))))) {
            _local5 = Number(xml3.@duration);
            _local6 = Number(xml4.@duration);
            tooltipText = (tooltipText + this.invisibleLine(_local5, _local6));
            handledXml[xml3.toXMLString()] = true;
        }
        this.addUniqueEffect(xml5);
    }

    private function addUniqueEffect(itemXML:XML):void {
        var teleportTag:XML;
        if (itemXML.@id == "Cloak of the Planewalker") {
            tooltipText = (tooltipText + colorize("Teleport to Target\n", PURPLE));
            teleportTag = XML(itemXML.Activate.(text() == "Teleport"))[0];
            handledXml[teleportTag.toXMLString()] = true;
        }
    }

    private function findInvisibleEffect(xml:XML):XML {
        var matches:XMLList;
        var conditionTag:XML;
        matches = xml.Activate.(text() == "ConditionEffectSelf");
        for each (conditionTag in matches) {
            if (conditionTag.(@effect == "Invisible")) {
                return (conditionTag);
            }
        }
        return (null);
    }

    private function invisibleLine(_arg1:Number, _arg2:Number):String {
        var _local3 = "";
        var _local4:String = compareColor((_arg1 - _arg2));
        _local3 = "Effect on Self:\n";
        return ((_local3 + colorize((("Invisible for " + _arg1) + " secs\n"), _local4)));
    }

}
}//package com.company.assembleegameclient.ui.tooltip.handlers

