package com.company.assembleegameclient.ui.tooltip.handlers {
public class SpellStatHandler extends SlotStatHandler {

    private var projectileXml:XML;
    private var curProjectileXml:XML;

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        projectileXml = itemXML.Projectile[0];
        curProjectileXml = curItemXML.Projectile[0];
        tooltipText = damageLine() + rangeLine();
        handledXml[projectileXml.toXMLString()] = true;
    }

    private function damageLine():String {
        var minDamage:int = int(projectileXml.MinDamage);
        var maxDamage:int = int(projectileXml.MaxDamage);
        var curMinDamage:int = int(curProjectileXml.MinDamage);
        var curMaxDamage:int = int(curProjectileXml.MaxDamage);
        var avg:Number = (minDamage + maxDamage) / 2;
        var curAvg:Number = (curMinDamage + curMaxDamage) / 2;
        var text:String = minDamage == maxDamage ? maxDamage.toString() : minDamage + " - " + maxDamage;
        return "Damage: " + colorize(text, compareColor(avg - curAvg)) + "\n";
    }

    private function rangeLine():String {
        var range:Number = projectileRange(projectileXml);
        var curRange:Number = projectileRange(curProjectileXml);
        return "Range: " + colorize(range.toString(), compareColor(range - curRange)) + "\n";
    }

    private function projectileRange(projectile:XML):Number {
        return Number(projectile.Speed) * Number(projectile.LifetimeMS) / 10000;
    }

}
}
