package commands {

import services._6E_;

/**
 * Reports a page/screen view to analytics.
 * (Name inferred from usage: analytics._M_x(String).)
 */
public class TrackPageViewCommand {

    [Inject]
    public var analytics:_6E_;
    [Inject]
    public var page:String;

    public function execute():void {
        this.analytics._M_x(this.page);
    }

}
}
