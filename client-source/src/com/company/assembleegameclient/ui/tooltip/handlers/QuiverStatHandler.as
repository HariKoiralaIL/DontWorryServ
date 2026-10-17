package com.company.assembleegameclient.ui.tooltip.handlers {
public class QuiverStatHandler extends SlotStatHandler {

    private var weaponHandler:WeaponStatHandler;

    public function QuiverStatHandler() {
        weaponHandler = new WeaponStatHandler();
    }

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var condition:XMLList = findShotCondition(itemXML);
        var curCondition:XMLList = findShotCondition(curItemXML);

        weaponHandler.compare(itemXML, curItemXML);
        tooltipText = weaponHandler.tooltipText;
        for (var key:String in weaponHandler.handledXml) {
            handledXml[key] = true;
        }

        if (condition.length() == 1 && curCondition.length() == 1) {
            var duration:Number = Number(condition[0].@duration);
            var text:String = " " + condition.text() + " for " + duration + " secs\n";
            var html:String = "Shot Effect:\n" + colorize(text, YELLOW);
            tooltipText += html;
            handledXml[condition[0].toXMLString()] = html;
        }
    }

    private function findShotCondition(itemXML:XML):XMLList {
        return itemXML.Projectile.ConditionEffect.(text() == "Slowed" || text() == "Paralyzed" || text() == "Dazed");
    }

}
}
