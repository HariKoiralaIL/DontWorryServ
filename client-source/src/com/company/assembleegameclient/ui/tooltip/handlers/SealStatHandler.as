package com.company.assembleegameclient.ui.tooltip.handlers {
public class SealStatHandler extends SlotStatHandler {

    private static const BLASPHEMOUS_PRAYER:String = "Seal of Blasphemous Prayer";

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var healing:XML = findAura(itemXML, "Healing");
        var damaging:XML = findAura(itemXML, "Damaging");
        var curHealing:XML = findAura(curItemXML, "Healing");
        var curDamaging:XML = findAura(curItemXML, "Damaging");

        tooltipText = "";
        if (healing == null || damaging == null || curHealing == null || curDamaging == null) {
            return;
        }
        addAuraLine("Healing", healing, curHealing);
        addAuraLine("Damaging", damaging, curDamaging);
        if (itemXML.@id == BLASPHEMOUS_PRAYER) {
            var tag:XML = activateTags(itemXML, "ConditionEffectSelf")[0];
            tooltipText += selfEffectLine("Invulnerable", tag.@duration, PURPLE);
            handledXml[tag.toXMLString()] = true;
        }
    }

    private function findAura(itemXML:XML, effect:String):XML {
        return findActivateByEffect(itemXML, "ConditionEffectAura", effect);
    }

    private function addAuraLine(effect:String, aura:XML, curAura:XML):void {
        var duration:int = int(aura.@duration);
        var curDuration:int = int(curAura.@duration);
        var range:Number = Number(aura.@range);
        var curRange:Number = Number(curAura.@range);
        var score:Number = 0.5 * duration * 0.5 * range;
        var curScore:Number = 0.5 * curDuration * 0.5 * curRange;
        var text:String = "Within " + aura.@range + " sqrs\n" + effect + " for " + duration + " seconds\n";
        tooltipText += "Party Effect: " + colorize(text, compareColor(score - curScore));
        handledXml[aura.toXMLString()] = true;
    }

}
}
