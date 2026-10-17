package com.company.assembleegameclient.ui.tooltip.handlers {
public class TrapStatHandler extends SlotStatHandler {

    private static const CORAL_VENOM_TRAP:String = "Coral Venom Trap";

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var trap:XML = findTrap(itemXML);
        var curTrap:XML = findTrap(curItemXML);
        tooltipText = "";
        if (trap == null || curTrap == null) {
            return;
        }
        if (itemXML.@id == CORAL_VENOM_TRAP) {
            addCoralVenomLine(itemXML);
        } else {
            addSlowTrapLine(trap, curTrap);
        }
    }

    private function addCoralVenomLine(itemXML:XML):void {
        var tag:XML = activateTags(itemXML, "Trap")[0];
        var text:String = tag.@totalDamage + " HP within " + tag.@radius + " sqrs\n"
                + "Paralyzed for " + tag.@condDuration + " seconds\n";
        tooltipText += "Trap: " + colorize(text, PURPLE);
        handledXml[tag.toXMLString()] = true;
    }

    private function addSlowTrapLine(trap:XML, curTrap:XML):void {
        var radius:Number = Number(trap.@radius);
        var curRadius:Number = Number(curTrap.@radius);
        var damage:int = int(trap.@totalDamage);
        var curDamage:int = int(curTrap.@totalDamage);
        var duration:int = int(trap.@condDuration);
        var curDuration:int = int(curTrap.@condDuration);
        var score:Number = 0.33 * radius + 0.33 * damage + 0.33 * duration;
        var curScore:Number = 0.33 * curRadius + 0.33 * curDamage + 0.33 * curDuration;
        var text:String = damage + " HP within " + radius + " sqrs\n Slowed for " + duration + " seconds\n";
        tooltipText += "Trap: " + colorize(text, compareColor(score - curScore));
        handledXml[trap.toXMLString()] = true;
    }

    private function findTrap(itemXML:XML):XML {
        var matches:XMLList = activateTags(itemXML, "Trap");
        return matches.length() >= 1 ? matches[0] : null;
    }

}
}
