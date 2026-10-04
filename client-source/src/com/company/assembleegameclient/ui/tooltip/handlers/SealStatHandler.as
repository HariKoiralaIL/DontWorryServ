// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.handlers.SealStatHandler

package com.company.assembleegameclient.ui.tooltip.handlers {
public class SealStatHandler extends SlotStatHandler {

    private var healingAura:XML;
    private var damagingAura:XML;
    private var curHealingAura:XML;
    private var curDamagingAura:XML;

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var tag:XML;
        tooltipText = "";
        this.healingAura = this.findAura(itemXML, "Healing");
        this.damagingAura = this.findAura(itemXML, "Damaging");
        this.curHealingAura = this.findAura(curItemXML, "Healing");
        this.curDamagingAura = this.findAura(curItemXML, "Damaging");
        if (this.hasAllAuras()) {
            this.healingLine();
            this.damagingLine();
            if (itemXML.@id == "Seal of Blasphemous Prayer") {
                tag = itemXML.Activate.(text() == "ConditionEffectSelf")[0];
                tooltipText = (tooltipText + ("Effect on Self:\n" + colorize((("Invulnerable for " + tag.@duration) + " secs\n"), PURPLE)));
                handledXml[tag.toXMLString()] = true;
            }
        }
    }

    private function hasAllAuras():Boolean {
        return (((((((!((this.healingAura == null))) && (!((this.damagingAura == null))))) && (!((this.curHealingAura == null))))) && (!((this.curDamagingAura == null)))));
    }

    private function findAura(xml:XML, effectName:String):XML {
        var matches:XMLList;
        var tag:XML;
        matches = xml.Activate.(text() == "ConditionEffectAura");
        for each (tag in matches) {
            if (tag.@effect == effectName) {
                return (tag);
            }
        }
        return (null);
    }

    private function healingLine():void {
        var _local1:int = int(this.healingAura.@duration);
        var _local2:int = int(this.curHealingAura.@duration);
        var _local3:Number = Number(this.healingAura.@range);
        var _local4:Number = Number(this.curHealingAura.@range);
        var _local5:Number = (((0.5 * _local1) * 0.5) * _local3);
        var _local6:Number = (((0.5 * _local2) * 0.5) * _local4);
        var _local7 = (((("Within " + this.healingAura.@range) + " sqrs\nHealing for ") + _local1) + " seconds\n");
        tooltipText = (tooltipText + ("Party Effect: " + colorize(_local7, compareColor((_local5 - _local6)))));
        handledXml[this.healingAura.toXMLString()] = true;
    }

    private function damagingLine():void {
        var _local1:int = int(this.damagingAura.@duration);
        var _local2:int = int(this.curDamagingAura.@duration);
        var _local3:Number = Number(this.damagingAura.@range);
        var _local4:Number = Number(this.curDamagingAura.@range);
        var _local5:Number = (((0.5 * _local1) * 0.5) * _local3);
        var _local6:Number = (((0.5 * _local2) * 0.5) * _local4);
        var _local7 = (((("Within " + this.damagingAura.@range) + " sqrs\nDamaging for ") + _local1) + " seconds\n");
        tooltipText = (tooltipText + ("Party Effect: " + colorize(_local7, compareColor((_local5 - _local6)))));
        handledXml[this.damagingAura.toXMLString()] = true;
    }

}
}//package com.company.assembleegameclient.ui.tooltip.handlers

