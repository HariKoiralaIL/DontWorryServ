package commands {

import services._6E_;
import services._fn;

/**
 * Forwards an analytics event to the tracker.
 */
public class TrackEventCommand {

    [Inject]
    public var analytics:_6E_;
    [Inject]
    public var event:_fn;

    public function execute():void {
        this.analytics.trackEvent(this.event.category, this.event._lC_, this.event._9g, this.event.value);
    }

}
}
