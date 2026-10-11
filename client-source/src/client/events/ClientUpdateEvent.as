package client.events {
import flash.events.Event;

/** Dispatched when a client update is required. */
public class ClientUpdateEvent extends Event {

    public static const CLIENT_UPDATE:String = "CLIENT_UPDATE";

    public function ClientUpdateEvent() {
        super(CLIENT_UPDATE);
    }

}
}
