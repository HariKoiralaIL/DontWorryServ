package com.company.assembleegameclient.ui.tooltip.handlers {
public class HelmStatHandler extends SlotStatHandler {

    private var berserkAura:XML;
    private var curBerserkAura:XML;
    private var speedy:XML;
    private var curSpeedy:XML;
    private var armored:XML;

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        berserkAura = findActivateByEffect(itemXML, "ConditionEffectAura", "Berserk");
        speedy = findActivateByEffect(itemXML, "ConditionEffectSelf", "Speedy");
        armored = findActivateByEffect(itemXML, "ConditionEffectSelf", "Armored");
        curBerserkAura = findActivateByEffect(curItemXML, "ConditionEffectAura", "Berserk");
        curSpeedy = findActivateByEffect(curItemXML, "ConditionEffectSelf", "Speedy");

        tooltipText = "";
        addBerserkLine();
        addSpeedyLine();
        addArmoredLine();
    }

    private function addBerserkLine():void {
        if (berserkAura == null || curBerserkAura == null) {
            return;
        }
        var range:Number = Number(berserkAura.@range);
        var curRange:Number = Number(curBerserkAura.@range);
        var duration:Number = Number(berserkAura.@duration);
        var curDuration:Number = Number(curBerserkAura.@duration);
        var score:Number = 0.5 * range + 0.5 * duration;
        var curScore:Number = 0.5 * curRange + 0.5 * curDuration;
        var text:String = "Within " + range + " sqrs\nBerserk for " + duration + " secs\n";
        tooltipText += "Party Effect: " + colorize(text, compareColor(score - curScore));
        handledXml[berserkAura.toXMLString()] = true;
    }

    private function addSpeedyLine():void {
        if (speedy == null) {
            return;
        }
        if (curSpeedy != null) {
            var duration:Number = Number(speedy.@duration);
            var curDuration:Number = Number(curSpeedy.@duration);
            tooltipText += selfEffectLine("Speedy", duration, compareColor(duration - curDuration));
        } else {
            tooltipText += selfEffectLine("Speedy", speedy.@duration, GREEN);
        }
        handledXml[speedy.toXMLString()] = true;
    }

    private function addArmoredLine():void {
        if (armored != null) {
            tooltipText += selfEffectLine("Armored", armored.@duration, PURPLE);
            handledXml[armored.toXMLString()] = true;
        }
    }

}
}
