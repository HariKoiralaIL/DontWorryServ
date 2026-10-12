package client.events {
import com.company.assembleegameclient.net.messages.incoming.NameResult;

import flash.events.Event;

/** Dispatched with the result of a name request. */
public class NameResultEvent extends Event {

    public static const NAMERESULTEVENT:String = "NAMERESULTEVENT";

    public var nameResult:NameResult;

    public function NameResultEvent(nameResult:NameResult) {
        super(NAMERESULTEVENT);
        this.nameResult = nameResult;
    }

}
}
