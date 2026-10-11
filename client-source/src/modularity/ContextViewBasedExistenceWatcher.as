package modularity {
import flash.display.DisplayObjectContainer;

import injection.Injector;

import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.ILogger;
import robotlegs.bender.framework.impl.UID;

/**
 * Listens on a context's view for child contexts announcing themselves
 * and links each child's injector to this context's injector.
 */
public class ContextViewBasedExistenceWatcher {

    private const uid:String = UID.create(ContextViewBasedExistenceWatcher);

    private var logger:ILogger;
    private var injector:Injector;
    private var contextView:DisplayObjectContainer;
    private var childContext:IContext;

    public function ContextViewBasedExistenceWatcher(context:IContext, contextView:DisplayObjectContainer) {
        this.logger = context.getLogger(this);
        this.injector = context.injector;
        this.contextView = contextView;
        context.lifecycle.whenDestroying(this.destroy);
        this.init();
    }

    public function toString():String {
        return this.uid;
    }

    private function init():void {
        this.logger.debug("Listening for context existence events on contextView {0}", [this.contextView]);
        this.contextView.addEventListener(ModularContextEvent.CONTEXT_ADD, this.onContextAdded);
    }

    private function destroy():void {
        this.logger.debug("Removing modular context existence event listener from contextView {0}", [this.contextView]);
        this.contextView.removeEventListener(ModularContextEvent.CONTEXT_ADD, this.onContextAdded);
        if (this.childContext) {
            this.logger.debug("Unlinking parent injector for child context {0}", [this.childContext]);
            this.childContext.injector.parent = null;
        }
    }

    private function onContextAdded(event:ModularContextEvent):void {
        event.stopImmediatePropagation();
        this.childContext = event.context;
        this.logger.debug("Context existence event caught. Configuring child context {0}", [this.childContext]);
        this.childContext.injector.parent = this.injector;
    }
}
}
