package commands {

import services.AnalyticsEvent;
import services.AnalyticsTracker;

/**
 * Forwards an analytics event to the tracker.
 */
public class TrackEventCommand {

    [Inject]
    public var analytics:AnalyticsTracker;
    [Inject]
    public var event:AnalyticsEvent;

    public function execute():void {
        this.analytics.trackEvent(this.event.category, this.event.action, this.event.label, this.event.value);
    }

}
}
