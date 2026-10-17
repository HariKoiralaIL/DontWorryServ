package com.company.assembleegameclient.ui.tooltip.handlers {
import com.company.assembleegameclient.ui.tooltip.TooltipText;

public class WeaponStatHandler extends SlotStatHandler {

    private static const BONUS_COLOR:String = "1CABFF";
    private static const PENALTY_COLOR:String = "FF6863";

    private var itemXML:XML;
    private var curItemXML:XML;
    private var itemData:Object;
    private var curItemData:Object;
    private var projectileXml:XML;
    private var curProjectileXml:XML;

    override protected function compareSlotsData(itemXML:XML, curItemXML:XML, itemData:Object, curItemData:Object):void {
        this.itemXML = itemXML;
        this.curItemXML = curItemXML;
        this.itemData = itemData;
        this.curItemData = curItemData;
        tooltipText = "";

        var line:String;
        if (itemXML.hasOwnProperty("NumProjectiles")) {
            line = numShotsLine();
            tooltipText += line;
            handledXml[itemXML.NumProjectiles.toXMLString()] = line;
        }
        if (itemXML.hasOwnProperty("Projectile")) {
            line = rangeLines();
            tooltipText += line;
            handledXml[itemXML.Projectile.toXMLString()] = line;
        }
        rateOfFireLine();
    }

    private function numShotsLine():String {
        var shots:int = int(itemXML.NumProjectiles);
        var curShots:int = int(curItemXML.NumProjectiles);
        return colorize("Number of Shots: ", GRAY) + colorize(shots.toString(), compareColor(shots - curShots)) + "\n";
    }

    private function rangeLines():String {
        var text:String = damageLine();
        var range:Number = projectileRange(projectileXml);
        var curRange:Number = projectileRange(curProjectileXml);
        text += colorize("Projectile Range: ", GRAY)
                + colorize(TooltipText.formatNumber(range) + "\n", compareColor(range - curRange));
        if (projectileXml.hasOwnProperty("MultiHit")) {
            text += colorize("Shots hit multiple targets\n", YELLOW);
        }
        if (projectileXml.hasOwnProperty("PassesCover")) {
            text += colorize("Shots pass through obstacles\n", YELLOW);
        }
        return text;
    }

    private function projectileRange(projectile:XML):Number {
        return Number(projectile.Speed) * Number(projectile.LifetimeMS) / 10000;
    }

    private function damageLine():String {
        projectileXml = XML(itemXML.Projectile);
        curProjectileXml = XML(curItemXML.Projectile);

        var customMin:int = customValue(itemData, "MinDamage");
        var customMax:int = customValue(itemData, "MaxDamage");
        var percent:int = customValue(itemData, "DmgPercentage");
        var curPercent:int = customValue(curItemData, "DmgPercentage");
        var hasMultiplier:Boolean = percent != 0 || curPercent != 0;

        var minDamage:int = int(projectileXml.MinDamage) + customMin;
        var maxDamage:int = int(projectileXml.MaxDamage) + customMax;
        minDamage += minDamage * (percent / 100);
        maxDamage += maxDamage * (percent / 100);

        var curMinDamage:int = int(curProjectileXml.MinDamage) + customValue(curItemData, "MinDamage");
        var curMaxDamage:int = int(curProjectileXml.MaxDamage) + customValue(curItemData, "MaxDamage");
        curMinDamage += curMinDamage * (curPercent / 100);
        curMaxDamage += curMaxDamage * (curPercent / 100);

        var avg:Number = (maxDamage + minDamage) / 2;
        var curAvg:Number = (curMaxDamage + curMinDamage) / 2;
        var range:String = (minDamage == maxDamage ? minDamage : minDamage + " - " + maxDamage).toString();

        var text:String = colorize("Attack Damage: ", GRAY) + colorize(range, compareColor(avg - curAvg))
                + customDamageSuffix(customMin, customMax) + "\n";
        if (hasMultiplier) {
            var sign:String = percent < 0 ? "-" : "+";
            text += colorize("Damage Multiplier: ", GRAY)
                    + colorize(sign + percent, compareColor(percent - curPercent)) + "%\n";
        }
        return text;
    }

    private function customValue(data:Object, key:String):int {
        return (data != null && data.hasOwnProperty(key)) ? int(data[key]) : 0;
    }

    private function customDamageSuffix(customMin:int, customMax:int):String {
        if (customMin != 0 && customMax != 0) {
            var color:String = (customMin > 0 || customMax > 0) ? BONUS_COLOR : PENALTY_COLOR;
            return damageNote(color, (customMin > 0 ? "+" : "-") + customMin + "-" + customMax + " DMG");
        }
        if (customMin != 0) {
            return damageNote(customMin > 0 ? BONUS_COLOR : PENALTY_COLOR,
                    (customMin > 0 ? "+" : "-") + customMin + " Minimum DMG");
        }
        if (customMax != 0) {
            return damageNote(customMax > 0 ? BONUS_COLOR : PENALTY_COLOR,
                    (customMax > 0 ? "+" : "-") + customMax + " Maximum DMG");
        }
        return "";
    }

    private function damageNote(color:String, text:String):String {
        return ' <font color="#' + color + '">(' + text + ")</font>";
    }

    private function rateOfFireLine():void {
        if (itemXML.RateOfFire.length() == 0 || curItemXML.RateOfFire.length() == 0) {
            return;
        }
        var rate:Number = Number(itemXML.RateOfFire[0]);
        var curRate:Number = Number(curItemXML.RateOfFire[0]);
        var change:int = int(rate / curRate * 100) - 100;
        if (change == 0) {
            return;
        }
        var text:String = (change > 0 ? "+" : "") + change;
        tooltipText += "Rate of Fire: " + colorize(text + "%", compareColor(change)) + "\n";
    }

}
}
