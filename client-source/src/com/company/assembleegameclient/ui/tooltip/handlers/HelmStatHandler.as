// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.handlers.HelmStatHandler

package com.company.assembleegameclient.ui.tooltip.handlers {
public class HelmStatHandler extends SlotStatHandler {

    private var berserkAura:XML;
    private var speedy:XML;
    private var curBerserkAura:XML;
    private var curSpeedy:XML;
    private var armored:XML;
    private var curArmored:XML;

    override protected function compareSlots(xml3:XML, xml2:XML):void {
        this.findEffects(xml3, xml2);
        tooltipText = "";
        this.addBerserkLine();
        this.addSpeedyLine();
        this.addArmoredLine();
    }

    private function findEffects(xml3:XML, xml2:XML):void {
        this.berserkAura = this.findAuraEffect(xml3, "Berserk");
        this.speedy = this.findSelfEffect(xml3, "Speedy");
        this.armored = this.findSelfEffect(xml3, "Armored");

        this.curBerserkAura = this.findAuraEffect(xml2, "Berserk");
        this.curSpeedy = this.findSelfEffect(xml2, "Speedy");
        this.curArmored = this.findSelfEffect(xml2, "Armored");
    }

    private function findAuraEffect(xml:XML, typeName:String):XML {
        var matches:XMLList;
        var tag:XML;
        matches = xml.Activate.(text() == "ConditionEffectAura");
        for each (tag in matches) {
            if (tag.@effect == typeName) {
                return (tag);
            }
        }
        return (null);
    }

    private function findSelfEffect(xml:XML, typeName:String):XML {
        var matches:XMLList;
        var tag:XML;
        matches = xml.Activate.(text() == "ConditionEffectSelf");
        for each (tag in matches) {
            if (tag.@effect == typeName) {
                return (tag);
            }
        }
        return (null);
    }

    private function addBerserkLine():void {
        if ((((this.berserkAura == null)) || ((this.curBerserkAura == null)))) {
            return;
        }
        var _local1:Number = Number(this.berserkAura.@range);
        var _local2:Number = Number(this.curBerserkAura.@range);
        var _local3:Number = Number(this.berserkAura.@duration);
        var _local4:Number = Number(this.curBerserkAura.@duration);
        var _local5:Number = ((0.5 * _local1) + (0.5 * _local3));
        var _local6:Number = ((0.5 * _local2) + (0.5 * _local4));
        var _local7 = (((("Within " + _local1) + " sqrs\nBerserk for ") + _local3) + " secs\n");
        tooltipText = (tooltipText + ("Party Effect: " + colorize(_local7, compareColor((_local5 - _local6)))));
        handledXml[this.berserkAura.toXMLString()] = true;
    }

    private function addSpeedyLine():void {
        var _local1:Number;
        var _local2:Number;
        var _local3:String;
        if (((!((this.speedy == null))) && (!((this.curSpeedy == null))))) {
            _local1 = Number(this.speedy.@duration);
            _local2 = Number(this.curSpeedy.@duration);
            _local3 = (("Speedy for " + _local1) + " secs\n");
            tooltipText = (tooltipText + ("Effect on Self:\n" + colorize(_local3, compareColor((_local1 - _local2)))));
            handledXml[this.speedy.toXMLString()] = true;
        } else {
            if (((!((this.speedy == null))) && ((this.curSpeedy == null)))) {
                tooltipText = (tooltipText + ("Effect on Self:\n" + colorize((("Speedy for " + this.speedy.@duration) + " secs\n"), GREEN)));
                handledXml[this.speedy.toXMLString()] = true;
            }
        }
    }

    private function addArmoredLine():void {
        if (this.armored != null) {
            tooltipText = (tooltipText + ("Effect on Self:\n" + colorize((("Armored for " + this.armored.@duration) + " secs\n"), PURPLE)));
            handledXml[this.armored.toXMLString()] = true;
        }
    }

}
}//package com.company.assembleegameclient.ui.tooltip.handlers

