package com.company.assembleegameclient.ui.tooltip.handlers {
public class PrismStatHandler extends SlotStatHandler {

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var decoy:XMLList = activateTags(itemXML, "Decoy");
        var curDecoy:XMLList = activateTags(curItemXML, "Decoy");
        tooltipText = "";
        if (decoy.length() == 1 && curDecoy.length() == 1) {
            var duration:Number = Number(decoy[0].@duration);
            var curDuration:Number = Number(curDecoy[0].@duration);
            tooltipText += "Decoy: " + colorize(duration + " secs\n", compareColor(duration - curDuration));
            handledXml[decoy[0].toXMLString()] = true;
        }
    }

}
}
