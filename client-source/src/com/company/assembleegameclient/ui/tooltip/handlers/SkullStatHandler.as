// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.handlers.SkullStatHandler

package com.company.assembleegameclient.ui.tooltip.handlers {
public class SkullStatHandler extends SlotStatHandler {

    override protected function compareSlots(xml5:XML, xml2:XML):void {
        var xml3:XML;
        var xml4:XML;
        var _local5:Number;
        var _local6:Number;
        var _local7:int;
        var _local8:int;
        var _local9:Number;
        var _local10:Number;
        xml3 = this.findVampireBlast(xml5);
        xml4 = this.findVampireBlast(xml2);
        tooltipText = "";
        if (((!((xml3 == null))) && (!((xml4 == null))))) {
            _local5 = Number(xml3.@radius);
            _local6 = Number(xml4.@radius);
            _local7 = int(xml3.@totalDamage);
            _local8 = int(xml4.@totalDamage);
            _local9 = ((0.5 * _local5) + (0.5 * _local7));
            _local10 = ((0.5 * _local6) + (0.5 * _local8));
            tooltipText = (tooltipText + ("Steal: " + colorize((((_local7 + " HP within ") + _local5) + " sqrs\n"), compareColor((_local9 - _local10)))));
            handledXml[xml3.toXMLString()] = true;
        }
    }

    private function findVampireBlast(xml:XML):XML {
        var matches:XMLList;
        matches = xml.Activate.(text() == "VampireBlast");
        return ((((matches.length()) >= 1) ? matches[0] : null));
    }

}
}//package com.company.assembleegameclient.ui.tooltip.handlers

