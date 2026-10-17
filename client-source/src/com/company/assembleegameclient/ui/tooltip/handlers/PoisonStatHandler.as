package com.company.assembleegameclient.ui.tooltip.handlers {
public class PoisonStatHandler extends SlotStatHandler {

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var grenade:XMLList = activateTags(itemXML, "PoisonGrenade");
        var curGrenade:XMLList = activateTags(curItemXML, "PoisonGrenade");
        tooltipText = "";
        if (grenade.length() == 1 && curGrenade.length() == 1) {
            var damage:int = int(grenade[0].@totalDamage);
            var curDamage:int = int(curGrenade[0].@totalDamage);
            var radius:Number = Number(grenade[0].@radius);
            var curRadius:Number = Number(curGrenade[0].@radius);
            var duration:Number = Number(grenade[0].@duration);
            var curDuration:Number = Number(curGrenade[0].@duration);
            var score:Number = 0.33 * damage + 0.33 * radius + 0.33 * duration;
            var curScore:Number = 0.33 * curDamage + 0.33 * curRadius + 0.33 * curDuration;
            var text:String = damage + " HP over " + duration + " secs within " + radius + " sqrs\n";
            tooltipText += "Poison Grenade: " + colorize(text, compareColor(score - curScore));
            handledXml[grenade[0].toXMLString()] = true;
        }
    }

}
}
