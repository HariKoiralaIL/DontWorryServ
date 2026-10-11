package rootview {
import robotlegs.bender.bundles.mvcs.Mediator;

import flash.display.DisplayObjectContainer;
import flash.display.LoaderInfo;
import flash.events.IEventDispatcher;

import com.company.assembleegameclient.appengine._vG_;

import flash.events.ErrorEvent;

/** Catches uncaught errors on the root loader and hands them to the error handler (_vG_). */
public class UncaughtErrorMediator extends Mediator {

    // Looked up by name because LoaderInfo.uncaughtErrorEvents only exists in newer Flash Player versions.
    private static const UNCAUGHT_ERROR_EVENTS:String = "uncaughtErrorEvents";
    private static const UNCAUGHT_ERROR:String = "uncaughtError";

    [Inject]
    public var contextView:DisplayObjectContainer;
    private var loaderInfo:LoaderInfo;

    override public function initialize():void {
        this.loaderInfo = this.contextView.loaderInfo;
        if (this.hasUncaughtErrorEvents()) {
            this.addErrorListener();
        }
    }

    override public function destroy():void {
        if (this.hasUncaughtErrorEvents()) {
            this.removeErrorListener();
        }
    }

    private function hasUncaughtErrorEvents():Boolean {
        return (this.loaderInfo.hasOwnProperty(UNCAUGHT_ERROR_EVENTS));
    }

    private function addErrorListener():void {
        var dispatcher:IEventDispatcher = IEventDispatcher(this.loaderInfo[UNCAUGHT_ERROR_EVENTS]);
        dispatcher.addEventListener(UNCAUGHT_ERROR, this.onUncaughtError);
    }

    private function removeErrorListener():void {
        var dispatcher:IEventDispatcher = IEventDispatcher(this.loaderInfo[UNCAUGHT_ERROR_EVENTS]);
        dispatcher.removeEventListener(UNCAUGHT_ERROR, this.onUncaughtError);
    }

    private function onUncaughtError(event:ErrorEvent):void {
        event.preventDefault();
        _vG_._A_U_(event["error"]);
    }

}
}//package rootview
