package client.events {
import flash.events.Event;

/** Dispatched (bubbling) when the account changes. */
public class AccountChangedEvent extends Event {

    public static const ACCOUNT_CHANGED:String = "ACCOUNT_CHANGED";

    public function AccountChangedEvent() {
        super(ACCOUNT_CHANGED, true);
    }

}
}
