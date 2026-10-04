// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.handlers.ShieldStatHandler

package com.company.assembleegameclient.ui.tooltip.handlers {
public class ShieldStatHandler extends SlotStatHandler {

    public function ShieldStatHandler() {
        this.weaponHandler = new WeaponStatHandler();
    }
    private var weaponHandler:WeaponStatHandler;

    override protected function compareSlots(xml2:XML, xml:XML):void {
        var _local3:String;
        this.weaponHandler._N_Q_(xml2, xml);
        tooltipText = this.weaponHandler.tooltipText;
        for (_local3 in this.weaponHandler.handledXml) {
            handledXml[_local3] = this.weaponHandler.handledXml[_local3];
        }
        this.addOgmurEffect(xml2);
    }

    private function addOgmurEffect(itemXML:XML):void {
        var tag:XML;
        var str:String;
        if (itemXML.@id == "Shield of Ogmur") {
            tag = itemXML.ConditionEffect.(text() == "Armor Broken")[0];
            str = (("Armor Broken for " + tag.@duration) + " secs\n");
            str = ("Party Effect: " + colorize(str, PURPLE));
            tooltipText = (tooltipText + str);
            handledXml[tag.toXMLString()] = str;
        }
    }

}
}//package com.company.assembleegameclient.ui.tooltip.handlers

