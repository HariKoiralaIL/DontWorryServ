package com.company.assembleegameclient.ui.tooltip.handlers {
public class ShieldStatHandler extends SlotStatHandler {

    private static const SHIELD_OF_OGMUR:String = "Shield of Ogmur";

    private var weaponHandler:WeaponStatHandler;

    public function ShieldStatHandler() {
        weaponHandler = new WeaponStatHandler();
    }

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        weaponHandler.compare(itemXML, curItemXML);
        tooltipText = weaponHandler.tooltipText;
        for (var key:String in weaponHandler.handledXml) {
            handledXml[key] = weaponHandler.handledXml[key];
        }
        addOgmurEffect(itemXML);
    }

    private function addOgmurEffect(itemXML:XML):void {
        if (itemXML.@id == SHIELD_OF_OGMUR) {
            var tag:XML = itemXML.ConditionEffect.(text() == "Armor Broken")[0];
            var line:String = "Party Effect: " + colorize("Armor Broken for " + tag.@duration + " secs\n", PURPLE);
            tooltipText += line;
            handledXml[tag.toXMLString()] = line;
        }
    }

}
}
