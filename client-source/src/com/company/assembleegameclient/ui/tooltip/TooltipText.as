// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.TooltipText

package com.company.assembleegameclient.ui.tooltip {
public class TooltipText {

    public static const GREEN:String = "#00FF00";
    public static const RED:String = "#FF0000";
    public static const YELLOW:String = "#FFFF8F";

    public static function colorize(_arg1:String, _arg2:String):String {
        return ('<font color="' + _arg2 + '">' + _arg1 + "</font>");
    }

    public static function formatNumber(_arg1:Number):String {
        var _local2:Number = (_arg1 - int(_arg1));
        return (int(_local2 * 10) == 0 ? int(_arg1).toString() : _arg1.toFixed(1));
    }

    public static function compareColor(_arg1:Number):String {
        if (_arg1 < 0) {
            return (RED);
        }
        if (_arg1 > 0) {
            return (GREEN);
        }
        return (YELLOW);
    }

}
}//package com.company.assembleegameclient.ui.tooltip

