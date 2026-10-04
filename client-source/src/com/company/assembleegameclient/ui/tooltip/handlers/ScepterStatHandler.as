// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.handlers.ScepterStatHandler

package com.company.assembleegameclient.ui.tooltip.handlers {
public class ScepterStatHandler extends SlotStatHandler {

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var result:XMLList;
        var otherResult:XMLList;
        var damage:int;
        var otherDamage:int;
        var textColor:String;
        var targets:int;
        var otherTargets:int;
        var condition:String;
        var duration:Number;
        var compositeStr:String;
        var htmlStr:String;
        result = itemXML.Activate.(text() == "Lightning");
        otherResult = curItemXML.Activate.(text() == "Lightning");
        tooltipText = "";
        if ((((result.length() == 1)) && ((otherResult.length() == 1)))) {
            damage = int(result[0].@totalDamage);
            otherDamage = int(otherResult[0].@totalDamage);
            textColor = compareColor((damage - otherDamage));
            targets = int(result[0].@maxTargets);
            otherTargets = int(otherResult[0].@maxTargets);
            tooltipText = (tooltipText + ("Lightning: " + colorize((((damage + " to ") + targets) + " targets\n"), compareColor((damage - otherDamage)))));
            handledXml[result[0].toXMLString()] = true;
        }
        if (itemXML.Activate.@condEffect) {
            condition = itemXML.Activate.@condEffect;
            duration = itemXML.Activate.@condDuration;
            compositeStr = ((((" " + condition) + " for ") + duration) + " secs\n");
            htmlStr = ("Shot Effect:\n" + colorize(compositeStr, YELLOW));
            tooltipText = (tooltipText + htmlStr);
        }
    }

}
}//package com.company.assembleegameclient.ui.tooltip.handlers

