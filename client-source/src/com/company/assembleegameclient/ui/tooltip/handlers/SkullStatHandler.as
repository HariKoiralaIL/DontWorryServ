package com.company.assembleegameclient.ui.tooltip.handlers {
public class SkullStatHandler extends SlotStatHandler {

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var blast:XML = findVampireBlast(itemXML);
        var curBlast:XML = findVampireBlast(curItemXML);
        tooltipText = "";
        if (blast != null && curBlast != null) {
            var radius:Number = Number(blast.@radius);
            var curRadius:Number = Number(curBlast.@radius);
            var damage:int = int(blast.@totalDamage);
            var curDamage:int = int(curBlast.@totalDamage);
            var score:Number = 0.5 * radius + 0.5 * damage;
            var curScore:Number = 0.5 * curRadius + 0.5 * curDamage;
            var text:String = damage + " HP within " + radius + " sqrs\n";
            tooltipText += "Steal: " + colorize(text, compareColor(score - curScore));
            handledXml[blast.toXMLString()] = true;
        }
    }

    private function findVampireBlast(itemXML:XML):XML {
        var matches:XMLList = activateTags(itemXML, "VampireBlast");
        return matches.length() >= 1 ? matches[0] : null;
    }

}
}
