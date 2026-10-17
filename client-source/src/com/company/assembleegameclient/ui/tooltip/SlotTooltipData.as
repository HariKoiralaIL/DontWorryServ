package com.company.assembleegameclient.ui.tooltip {
import flash.utils.Dictionary;

public class SlotTooltipData {

    public var text:String;
    public var handledXml:Dictionary;
    public var onEquipText:Dictionary;

    public function SlotTooltipData() {
        text = "";
        handledXml = new Dictionary(true);
        onEquipText = new Dictionary(true);
    }

}
}
