package com.company.assembleegameclient.ui.tooltip.handlers {
public class ScepterStatHandler extends SlotStatHandler {

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var lightning:XMLList = activateTags(itemXML, "Lightning");
        var curLightning:XMLList = activateTags(curItemXML, "Lightning");
        tooltipText = "";
        if (lightning.length() == 1 && curLightning.length() == 1) {
            var damage:int = int(lightning[0].@totalDamage);
            var curDamage:int = int(curLightning[0].@totalDamage);
            var targets:int = int(lightning[0].@maxTargets);
            tooltipText += "Lightning: " + colorize(damage + " to " + targets + " targets\n", compareColor(damage - curDamage));
            handledXml[lightning[0].toXMLString()] = true;
        }
        if (itemXML.Activate.@condEffect) {
            var condition:String = itemXML.Activate.@condEffect;
            var duration:Number = itemXML.Activate.@condDuration;
            var text:String = " " + condition + " for " + duration + " secs\n";
            tooltipText += "Shot Effect:\n" + colorize(text, YELLOW);
        }
    }

}
}
