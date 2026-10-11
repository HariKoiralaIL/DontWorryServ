package stagesync {
import flash.display.DisplayObjectContainer;
import flash.events.Event;

import matchers.instanceOf;

import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.ILogger;
import robotlegs.bender.framework.impl.UID;

/**
 * Ties the context's lifecycle to its view: the context is initialized when the
 * context view is on stage and destroyed when the view leaves the stage.
 * Only the first DisplayObjectContainer added to the context is used.
 */
public class StageSyncExtension implements IExtension {

    private const uid_:String = UID.create(StageSyncExtension);

    private var context_:IContext;
    private var contextView_:DisplayObjectContainer;
    private var logger_:ILogger;

    public function extend(context:IContext):void {
        this.context_ = context;
        this.logger_ = context.getLogger(this);
        this.context_.addConfigHandler(instanceOf(DisplayObjectContainer), this.handleContextView);
    }

    public function toString():String {
        return (this.uid_);
    }

    private function handleContextView(view:DisplayObjectContainer):void {
        if (this.contextView_) {
            this.logger_.warn("A contextView has already been set, ignoring {0}", [view]);
            return;
        }
        this.contextView_ = view;
        if (this.contextView_.stage) {
            this.initializeContext();
        } else {
            this.logger_.debug("Context view is not yet on stage. Waiting...");
            this.contextView_.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        }
    }

    private function initializeContext():void {
        this.logger_.debug("Context view is now on stage. Initializing context...");
        this.context_.lifecycle.initialize();
        this.contextView_.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    private function onAddedToStage(event:Event):void {
        this.contextView_.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        this.initializeContext();
    }

    private function onRemovedFromStage(event:Event):void {
        this.logger_.debug("Context view has left the stage. Destroying context...");
        this.contextView_.removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        this.context_.lifecycle.destroy();
    }

}
}
