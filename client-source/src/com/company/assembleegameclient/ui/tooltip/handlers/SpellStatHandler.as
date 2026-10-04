// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.handlers.SpellStatHandler

package com.company.assembleegameclient.ui.tooltip.handlers {
public class SpellStatHandler extends SlotStatHandler {

    private var itemXML:XML;
    private var curItemXML:XML;
    private var projectileXml:XML;
    private var curProjectileXml:XML;

    override protected function compareSlots(xml2:XML, xml:XML):void {
        this.itemXML = xml2;
        this.curItemXML = xml;
        this.projectileXml = xml2.Projectile[0];
        this.curProjectileXml = xml.Projectile[0];
        tooltipText = this.damageLine();
        tooltipText = (tooltipText + this.rangeLine());
        handledXml[this.projectileXml.toXMLString()] = true;
    }

    private function damageLine():String {
        var _local1:int = int(this.projectileXml.MinDamage);
        var _local2:int = int(this.projectileXml.MaxDamage);
        var _local3:int = int(this.curProjectileXml.MinDamage);
        var _local4:int = int(this.curProjectileXml.MaxDamage);
        var _local5:Number = ((_local1 + _local2) / 2);
        var _local6:Number = ((_local3 + _local4) / 2);
        var _local7:String = compareColor((_local5 - _local6));
        var _local8:String = (( _local1 == _local2) ? _local2.toString() : _local1 + " - " + _local2);
        return ('Damage: <font color="' + _local7 + '">' + _local8 + "</font>\n");
    }

    private function rangeLine():String {
        var _local1:Number = ((Number(this.projectileXml.Speed) * Number(this.projectileXml.LifetimeMS)) / 10000);
        var _local2:Number = ((Number(this.curProjectileXml.Speed) * Number(this.curProjectileXml.LifetimeMS)) / 10000);
        var _local3:String = compareColor(_local1 - _local2);
        return ('Range: <font color="' + _local3 + '">' + _local1 + "</font>\n");
    }

}
}//package com.company.assembleegameclient.ui.tooltip.handlers

