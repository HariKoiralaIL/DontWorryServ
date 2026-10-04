// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.SlotTooltipData

package com.company.assembleegameclient.ui.tooltip {
import flash.utils.Dictionary;

public class SlotTooltipData {

    public function SlotTooltipData() {
        this.text = "";
        this.handledXml = new Dictionary(true);
        this.onEquipText = new Dictionary(true);
    }
    public var text:String;
    public var handledXml:Dictionary;
    public var onEquipText:Dictionary;
}
}//package com.company.assembleegameclient.ui.tooltip

