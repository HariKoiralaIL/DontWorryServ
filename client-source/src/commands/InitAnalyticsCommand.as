package commands {

import flash.display.DisplayObjectContainer;

import com.company.assembleegameclient.parameters.Parameters;

import services._6E_;

/**
 * Initialises analytics with the root stage.
 */
public class InitAnalyticsCommand {

    [Inject]
    public var root:DisplayObjectContainer;
    [Inject]
    public var analytics:_6E_;

    public function execute():void {
        this.analytics.init(this.root.stage, Parameters._05w());
    }

}
}
