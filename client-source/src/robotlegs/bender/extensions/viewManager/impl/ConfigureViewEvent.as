package robotlegs.bender.extensions.viewManager.impl {
import flash.display.DisplayObject;
import flash.events.Event;

/** Bubbling, cancelable event a view dispatches to ask for itself to be handled. */
public class ConfigureViewEvent extends Event {

    public static const CONFIGURE_VIEW:String = "configureView";

    private var _view:DisplayObject;

    public function ConfigureViewEvent(type:String, view:DisplayObject = null) {
        super(type, true, true);
        _view = view;
    }

    public function get view():DisplayObject {
        return _view;
    }

    override public function clone():Event {
        return new ConfigureViewEvent(type, _view);
    }

}
}
