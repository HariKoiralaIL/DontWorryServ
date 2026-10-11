package _T_Y_ {

// Formerly _08n. Fills "{0}", "{1}", ... placeholders in a message with the given params.
public class LogMessageFormatter {

    // formerly _nx
    public function format(message:String, params:Array):String {
        if (params) {
            for (var i:int = 0; i < params.length; i++) {
                message = message.split("{" + i + "}").join(params[i]);
            }
        }
        return message;
    }
}
}
