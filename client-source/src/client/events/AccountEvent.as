// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.events.AccountEvent

package client.events {
import flash.events.Event;

internal class AccountEvent extends Event {

    public static const DONE:String = "ACCOUNT_DONE";

    public function AccountEvent(type:String) {
        super(type);
    }
}
}//package client.events

