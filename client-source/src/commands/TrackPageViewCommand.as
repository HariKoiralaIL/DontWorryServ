package commands {

import services.AnalyticsTracker;

/**
 * Reports a page/screen view to analytics.
 */
public class TrackPageViewCommand {

    [Inject]
    public var analytics:AnalyticsTracker;
    [Inject]
    public var page:String;

    public function execute():void {
        this.analytics.trackPageView(this.page);
    }

}
}
