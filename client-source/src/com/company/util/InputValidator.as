package com.company.util {
public class InputValidator {

    public static const NAME_REGEX:RegExp = /^[A-Z]{3,12}$/i;
    public static const EMAIL_REGEX:RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i;

    /** 3-12 letters, A-Z only. */
    public static function isValidName(value:String):Boolean {
        return Boolean(value.match(NAME_REGEX));
    }

    public static function isEmail(value:String):Boolean {
        return Boolean(value.match(EMAIL_REGEX));
    }

}
}//package com.company.util
