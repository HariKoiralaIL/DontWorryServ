// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.handlers.SlotStatHandler

package com.company.assembleegameclient.ui.tooltip.handlers {
import flash.utils.Dictionary;

public class SlotStatHandler {

    internal static const GREEN:String = "#00ff00";
    internal static const RED:String = "#ff0000";
    internal static const YELLOW:String = "#FFFF8F";
    internal static const GRAY:String = "#B3B3B3";
    internal static const PURPLE:String = "#8a2be2";

    public var handledXml:Dictionary;
    public var onEquipText:Dictionary;
    public var tooltipText:String;

    public function _N_Q_(xml2:XML, xml:XML):void {
        this.reset();
        this.compareSlots(xml2, xml);
    }

    public function compareWithData(xml2:XML, xml:XML, _arg3:Object, _arg4:Object):void {
        this.compareSlotsData(xml2, xml, _arg3, _arg4);
    }

    protected function compareSlots(xml2:XML, xml:XML):void {
    }

    protected function compareSlotsData(xml2:XML, xml:XML, _arg3:Object, _arg4:Object):void {
    }

    protected function compareColor(_arg1:Number):String {
        if (_arg1 < 0) {
            return (RED);
        }
        if (_arg1 > 0) {
            return (GREEN);
        }
        return (YELLOW);
    }

    protected function colorize(_arg1:String, _arg2:String = "#FFFF8F"):String {
        return ('<font color="' + _arg2 + '">' + _arg1 + "</font>");
    }

    protected function mpCostLine(_arg1:String):String {
        return (this.colorize("MP Cost: ", GRAY) + this.colorize(_arg1, YELLOW) + "\n");
    }

    private function reset():void {
        this.handledXml = new Dictionary();
        this.onEquipText = new Dictionary();
    }

}
}//package com.company.assembleegameclient.ui.tooltip.handlers

