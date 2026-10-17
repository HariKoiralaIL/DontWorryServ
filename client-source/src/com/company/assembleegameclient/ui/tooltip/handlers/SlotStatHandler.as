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

    /** Formerly _N_Q_ */
    public function compare(itemXML:XML, curItemXML:XML):void {
        reset();
        compareSlots(itemXML, curItemXML);
    }

    public function compareWithData(itemXML:XML, curItemXML:XML, itemData:Object, curItemData:Object):void {
        compareSlotsData(itemXML, curItemXML, itemData, curItemData);
    }

    protected function compareSlots(itemXML:XML, curItemXML:XML):void {
    }

    protected function compareSlotsData(itemXML:XML, curItemXML:XML, itemData:Object, curItemData:Object):void {
    }

    protected function compareColor(diff:Number):String {
        if (diff < 0) {
            return RED;
        }
        if (diff > 0) {
            return GREEN;
        }
        return YELLOW;
    }

    protected function colorize(text:String, color:String = "#FFFF8F"):String {
        return '<font color="' + color + '">' + text + "</font>";
    }

    protected function mpCostLine(cost:String):String {
        return colorize("MP Cost: ", GRAY) + colorize(cost, YELLOW) + "\n";
    }

    protected function selfEffectLine(effectName:String, duration:Object, color:String):String {
        return "Effect on Self:\n" + colorize(effectName + " for " + duration + " secs\n", color);
    }

    /** All <Activate> tags whose text matches activateName. */
    protected function activateTags(itemXML:XML, activateName:String):XMLList {
        return itemXML.Activate.(text() == activateName);
    }

    /** First <Activate> tag with the given name and @effect, or null. */
    protected function findActivateByEffect(itemXML:XML, activateName:String, effect:String):XML {
        for each (var tag:XML in activateTags(itemXML, activateName)) {
            if (tag.@effect == effect) {
                return tag;
            }
        }
        return null;
    }

    private function reset():void {
        handledXml = new Dictionary();
        onEquipText = new Dictionary();
    }

}
}
