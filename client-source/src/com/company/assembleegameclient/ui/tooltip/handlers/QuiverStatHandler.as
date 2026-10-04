// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.handlers.QuiverStatHandler

package com.company.assembleegameclient.ui.tooltip.handlers {
public class QuiverStatHandler extends SlotStatHandler {

    public function QuiverStatHandler() {
        this.weaponHandler = new WeaponStatHandler();
    }
    private var weaponHandler:WeaponStatHandler;
    private var condition:XMLList;
    private var curCondition:XMLList;

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var tagStr:String;
        var duration:Number;
        var conditionName:String;
        var compositeStr:String;
        var htmlStr:String;
        this.condition = itemXML.Projectile.ConditionEffect.(((((text() == "Slowed")) || ((text() == "Paralyzed")))) || ((text() == "Dazed")));
        this.curCondition = curItemXML.Projectile.ConditionEffect.(((((text() == "Slowed")) || ((text() == "Paralyzed")))) || ((text() == "Dazed")));
        this.weaponHandler._N_Q_(itemXML, curItemXML);
        tooltipText = this.weaponHandler.tooltipText;
        for (tagStr in this.weaponHandler.handledXml) {
            handledXml[tagStr] = true;
        }
        if ((((this.condition.length() == 1)) && ((this.curCondition.length() == 1)))) {
            duration = Number(this.condition[0].@duration);
            conditionName = this.condition.text();
            compositeStr = ((((" " + conditionName) + " for ") + duration) + " secs\n");
            htmlStr = ("Shot Effect:\n" + colorize(compositeStr, YELLOW));
            tooltipText = (tooltipText + htmlStr);
            handledXml[this.condition[0].toXMLString()] = htmlStr;
        }
    }

}
}//package com.company.assembleegameclient.ui.tooltip.handlers

