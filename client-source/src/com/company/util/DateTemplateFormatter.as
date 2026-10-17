package com.company.util {
public class DateTemplateFormatter {

    private static const MONTH_NAMES:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

    /** Template tokens: D (day of month), YYYY (year), MMMM (month name). */
    public var formatString:String;

    public function format(date:Date):String {
        var result:String = this.formatString;
        result = result.replace("D", date.date);
        result = result.replace("YYYY", date.fullYear);
        return result.replace("MMMM", MONTH_NAMES[date.month]);
    }

}
}
