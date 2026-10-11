package contextview {
import flash.display.DisplayObjectContainer;

import views.IViewManager;

/** Registers the context view as a container with the view manager once injected. */
public class ContextViewConfig {

    [Inject]
    public var contextView:DisplayObjectContainer;
    [Inject]
    public var viewManager:IViewManager;

    [PostConstruct]
    public function init():void {
        this.viewManager.addContainer(this.contextView);
    }

}
}
