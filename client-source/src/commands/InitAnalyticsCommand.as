package commands {

import flash.display.DisplayObjectContainer;

import com.company.assembleegameclient.parameters.Parameters;

import services.AnalyticsTracker;

/**
 * Initialises analytics with the root stage.
 */
public class InitAnalyticsCommand {

    [Inject]
    public var root:DisplayObjectContainer;
    [Inject]
    public var analytics:AnalyticsTracker;

    public function execute():void {
        this.analytics.init(this.root.stage, Parameters._05w());
    }

}
}
