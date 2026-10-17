package com.company.assembleegameclient.appengine {
import account.Account;

import com.company.assembleegameclient.parameters.Parameters;
import com.company.util.SystemInfo;

import flash.events.ErrorEvent;

public class ClientErrorReporter {

    /** When true, errors without a stack trace are dropped. */
    public static const REQUIRE_STACK_TRACE:Boolean = true;

    public static function report(error:*):void {
        var message:String = null;
        var stackTrace:String = null;
        if (error is Error) {
            message = (error as Error).message;
            stackTrace = (error as Error).getStackTrace();
        } else if (error is ErrorEvent) {
            message = (error as ErrorEvent).text;
        } else if (error != null) {
            message = error.toString();
        }
        if (REQUIRE_STACK_TRACE && stackTrace == null) {
            return;
        }
        if (Parameters.sendErrors) {
            var text:String = "Build: " + Parameters.buildLabel() + "\n"
                    + "message: " + message + "\n"
                    + "stackTrace: " + stackTrace + "\n"
                    + SystemInfo.getCapabilitiesReport();
            var client:AppEngineClient = new AppEngineClient(Parameters.serverAddress(), "/clientError", false);
            client.sendRequest("add", {
                "text": text,
                "guid": Account.getInstance().guid()
            });
        } else {
            trace(message);
            trace(stackTrace);
        }
    }

}
}
