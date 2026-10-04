// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.handlers.PrismStatHandler

package com.company.assembleegameclient.ui.tooltip.handlers {
public class PrismStatHandler extends SlotStatHandler {

    private var _S_y:XMLList;
    private var curDecoy:XMLList;

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var duration:Number;
        var otherDuration:Number;
        this._S_y = itemXML.Activate.(text() == "Decoy");
        this.curDecoy = curItemXML.Activate.(text() == "Decoy");
        tooltipText = "";
        if ((((this._S_y.length() == 1)) && ((this.curDecoy.length() == 1)))) {
            duration = Number(this._S_y[0].@duration);
            otherDuration = Number(this.curDecoy[0].@duration);
            tooltipText = (tooltipText + ("Decoy: " + colorize((duration.toString() + " secs\n"), compareColor((duration - otherDuration)))));
            handledXml[this._S_y[0].toXMLString()] = true;
        }
    }

}
}//package com.company.assembleegameclient.ui.tooltip.handlers

