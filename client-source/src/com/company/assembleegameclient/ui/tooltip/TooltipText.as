package com.company.assembleegameclient.ui.tooltip {
public class TooltipText {

    public static const GREEN:String = "#00FF00";
    public static const RED:String = "#FF0000";
    public static const YELLOW:String = "#FFFF8F";

    public static function colorize(text:String, color:String):String {
        return '<font color="' + color + '">' + text + "</font>";
    }

    /** Whole numbers print without decimals, otherwise one decimal place. */
    public static function formatNumber(value:Number):String {
        var fraction:Number = value - int(value);
        return int(fraction * 10) == 0 ? int(value).toString() : value.toFixed(1);
    }

    public static function compareColor(diff:Number):String {
        if (diff < 0) {
            return RED;
        }
        if (diff > 0) {
            return GREEN;
        }
        return YELLOW;
    }

}
}
