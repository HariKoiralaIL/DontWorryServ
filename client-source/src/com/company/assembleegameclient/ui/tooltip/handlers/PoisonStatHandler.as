// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.handlers.PoisonStatHandler

package com.company.assembleegameclient.ui.tooltip.handlers {
public class PoisonStatHandler extends SlotStatHandler {

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var activate:XMLList;
        var otherActivate:XMLList;
        var damage:int;
        var otherDamage:int;
        var radius:Number;
        var otherRadius:Number;
        var duration:Number;
        var otherDuration:Number;
        var avg:Number;
        var otherAvg:Number;
        var text:String;
        activate = itemXML.Activate.(text() == "PoisonGrenade");
        otherActivate = curItemXML.Activate.(text() == "PoisonGrenade");
        tooltipText = "";
        if ((((activate.length() == 1)) && ((otherActivate.length() == 1)))) {
            damage = int(activate[0].@totalDamage);
            otherDamage = int(otherActivate[0].@totalDamage);
            radius = Number(activate[0].@radius);
            otherRadius = Number(otherActivate[0].@radius);
            duration = Number(activate[0].@duration);
            otherDuration = Number(otherActivate[0].@duration);
            avg = (((0.33 * damage) + (0.33 * radius)) + (0.33 * duration));
            otherAvg = (((0.33 * otherDamage) + (0.33 * otherRadius)) + (0.33 * otherDuration));
            text = (((((damage + " HP over ") + duration) + " secs within ") + radius) + " sqrs\n");
            tooltipText = (tooltipText + ("Poison Grenade: " + colorize(text, compareColor((avg - otherAvg)))));
            handledXml[activate[0].toXMLString()] = true;
        }
    }

}
}//package com.company.assembleegameclient.ui.tooltip.handlers

