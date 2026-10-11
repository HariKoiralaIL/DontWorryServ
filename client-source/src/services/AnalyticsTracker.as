package services {

import flash.display.Stage;

import com.company.googleanalytics.GA;
import com.google.analytics.GATracker;

/**
 * Thin wrapper around the Google Analytics tracker.
 * init() has to be called before any of the track methods.
 */
public class AnalyticsTracker {

    private var tracker:GATracker;

    public function init(stage:Stage, trackingId:String):void {
        this.tracker = new GATracker(stage, trackingId);
        GA.setTracker(this.tracker);
    }

    public function trackEvent(category:String, action:String, label:String, value:Number):Boolean {
        return this.tracker.trackEvent(category, action, label, value);
    }

    public function trackPageView(page:String):void {
        this.tracker.trackPageview(page);
    }

}
}
