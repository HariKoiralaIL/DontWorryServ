// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.handlers.WeaponStatHandler

package com.company.assembleegameclient.ui.tooltip.handlers {
import com.company.assembleegameclient.ui.tooltip.TooltipText;

public class WeaponStatHandler extends SlotStatHandler {

    private var itemXML:XML;
    private var curItemXML:XML;
    private var itemData:Object;
    private var curItemData:Object;
    private var projectileXml:XML;
    private var curProjectileXml:XML;

    override protected function compareSlotsData(xml2:XML, xml:XML, _arg3:Object, _arg4:Object):void {
        var _local3:String;
        this.itemXML = xml2;
        this.curItemXML = xml;
        this.itemData = _arg3;
        this.curItemData = _arg4;
        _local3 = "";
        tooltipText = "";
        if (xml2.hasOwnProperty("NumProjectiles")) {
            _local3 = this.numShotsLine();
            tooltipText = (tooltipText + _local3);
            handledXml[xml2.NumProjectiles.toXMLString()] = _local3;
        }
        if (xml2.hasOwnProperty("Projectile")) {
            _local3 = this.rangeLines();
            tooltipText = (tooltipText + _local3);
            handledXml[xml2.Projectile.toXMLString()] = _local3;
        }
        this.rateOfFireLine();
    }

    private function rangeLines():String {
        var _local1:String = this.damageLine();
        var _local2:Number = ((Number(this.projectileXml.Speed) * Number(this.projectileXml.LifetimeMS)) / 10000);
        var _local3:Number = ((Number(this.curProjectileXml.Speed) * Number(this.curProjectileXml.LifetimeMS)) / 10000);
        var _local4:String = TooltipText.formatNumber(_local2);
        _local1 = (_local1 + (colorize("Projectile Range: ", GRAY) + colorize((_local4 + "\n"), compareColor((_local2 - _local3)))));
        if (this.projectileXml.hasOwnProperty("MultiHit")) {
            _local1 = (_local1 + colorize("Shots hit multiple targets\n", YELLOW));
        }
        if (this.projectileXml.hasOwnProperty("PassesCover")) {
            _local1 = (_local1 + colorize("Shots pass through obstacles\n", YELLOW));
        }
        return (_local1);
    }

    private function numShotsLine():String {
        var _local1:int = int(this.itemXML.NumProjectiles);
        var _local2:int = int(this.curItemXML.NumProjectiles);
        var _local3:String = compareColor((_local1 - _local2));
        return (((colorize("Number of Shots: ", GRAY) + colorize(_local1.toString(), _local3)) + "\n"));
    }

    private function damageLine():String {
        var _local1:Boolean = false;
        var _local9:int = 0;
        var _local10:int = 0;
        this.projectileXml = XML(this.itemXML.Projectile);
        var _local2:int = int(this.projectileXml.MinDamage);
        var _local3:int = int(this.projectileXml.MaxDamage);
        var customMin:int = (this.itemData != null && this.itemData.hasOwnProperty("MinDamage")) ? int(this.itemData.MinDamage) : 0;
        var customMax:int = (this.itemData != null && this.itemData.hasOwnProperty("MaxDamage")) ? int(this.itemData.MaxDamage) : 0;
        var addString:String = (customMin != 0 && customMax != 0) ? " <font color=\"#" + (customMin > 0 || customMax > 0 ? "1CABFF" : "FF6863") + "\">(" + (customMin > 0 ? "+" : "-") + customMin + "-" + customMax + " DMG)</font>"
                : customMin != 0 ? " <font color=\"#" + (customMin > 0 ? "1CABFF" : "FF6863") + "\">(" + (customMin > 0 ? "+" : "-") + customMin + " Minimum DMG)</font>"
                : customMax != 0 ? " <font color=\"#" + (customMax > 0 ? "1CABFF" : "FF6863") + "\">(" + (customMax > 0 ? "+" : "-") + customMax + " Maximum DMG)</font>"
                : "";
        _local2 += customMin;
        _local3 += customMax;
        if(this.itemData != null && this.itemData.hasOwnProperty("DmgPercentage") && this.itemData.DmgPercentage != 0) {
            _local1 = true;
            _local9 = int(this.itemData.DmgPercentage);
            _local2 += (_local2 * (_local9 / 100));
            _local3 += (_local3 * (_local9 / 100));
        }
        var _local4:Number = ((_local3 + _local2) / 2);
        trace(_local4);
        this.curProjectileXml = XML(this.curItemXML.Projectile);
        var _local5:int = int(this.curProjectileXml.MinDamage);
        var _local6:int = int(this.curProjectileXml.MaxDamage);
        var customMin2:int = (this.curItemData != null && this.curItemData.hasOwnProperty("MinDamage")) ? int(this.curItemData.MinDamage) : 0;
        var customMax2:int = (this.curItemData != null && this.curItemData.hasOwnProperty("MaxDamage")) ? int(this.curItemData.MaxDamage) : 0;
        _local5 += customMin2;
        _local6 += customMax2;
        if(this.curItemData != null && this.curItemData.hasOwnProperty("DmgPercentage") && this.curItemData.DmgPercentage != 0) {
            _local1 = true;
            _local10 = int(this.curItemData.DmgPercentage);
            _local5 += (_local5 * (_local10 / 100));
            _local6 += (_local6 * (_local10 / 100));
        }
        var _local7:Number = ((_local6 + _local5) / 2);
        trace(_local7);
        var _local8:String = (((_local2 == _local3)) ? _local2 : ((_local2 + " - ") + _local3)).toString();
        var _local11:int = (_local9 - _local10);
        var _local12:String = (_local9 < 0 ? "-" : "+") + _local9.toString();
        return (((colorize("Attack Damage: ", GRAY) + colorize(_local8, compareColor((_local4 - _local7)))) + addString + "\n")) +
                (_local1 ? (colorize("Damage Multiplier: ", GRAY) + colorize(_local12, compareColor(_local11)) + "%\n") : "");
    }

    private function rateOfFireLine():void {
        if ((((this.itemXML.RateOfFire.length() == 0)) || ((this.curItemXML.RateOfFire.length() == 0)))) {
            return;
        }
        var _local1:Number = Number(this.curItemXML.RateOfFire[0]);
        var _local2:Number = Number(this.itemXML.RateOfFire[0]);
        var _local3:int = int(((_local2 / _local1) * 100));
        var _local4:int = (_local3 - 100);
        if (_local4 == 0) {
            return;
        }
        var _local5:String = compareColor(_local4);
        var _local6:String = _local4.toString();
        if (_local4 > 0) {
            _local6 = ("+" + _local6);
        }
        _local6 = colorize((_local6 + "%"), _local5);
        tooltipText = (tooltipText + (("Rate of Fire: " + _local6) + "\n"));
        handledXml[this.itemXML.RateOfFire[0].toXMLString()];
    }

}
}//package com.company.assembleegameclient.ui.tooltip.handlers

