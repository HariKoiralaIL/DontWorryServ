package com.company.util {
import mx.formatters.DateFormatter;

public class DateUtil {

    /** Current time shifted to UTC-7, run through DateFormatter with an empty format string. */
    public static function formatPacificTime():String {
        var now:Date = new Date();
        var time:Number = now.time;
        time = time + (((now.timezoneOffset - 420) * 60) * 1000);
        now.setTime(time);
        var formatter:DateFormatter = new DateFormatter();
        formatter.formatString = "";
        return formatter.format(now);
    }

}
}//package com.company.util
