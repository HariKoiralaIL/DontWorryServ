package client.events {
import flash.events.Event;

/** Dispatched (bubbling) when the player's money changes. */
public class MoneyChangedEvent extends Event {

    public static const MONEY_CHANGED:String = "MONEY_CHANGED";

    public function MoneyChangedEvent() {
        super(MONEY_CHANGED, true);
    }

}
}
