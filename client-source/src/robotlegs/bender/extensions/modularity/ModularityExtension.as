package robotlegs.bender.extensions.modularity {
import robotlegs.bender.framework.impl.UID;

import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.ILogger;

import modularity.ModularContextEvent;
import modularity.ViewManagerBasedExistenceWatcher;
import modularity.ContextViewBasedExistenceWatcher;

import injection.Injector;

import views.IViewManager;

import flash.display.DisplayObjectContainer;

// Formerly _0Z_. Lets a context take part in a hierarchy of contexts. When the context
// initializes it can:
//  - inherit: announce itself on its context view so a parent context can adopt it
//    (broadcasts a ModularContextEvent), and/or
//  - expose: start a watcher that lets child contexts find this context, using the view
//    manager if there is one, else the context view.
//
// NOTE: _D_v (extension interface), _L_y (context), _Q_5 (logger), _08b (injector),
// _J_6 / _we (the two existence watchers, view-manager-based and view-based), and these
// members come from other packages and keep their obfuscated names: the context's _O_R_
// (injector), _iL_._8u (lifecycle callback), _0H_4 (get logger), the logger's _0E_Q_
// (looks like warn) and the injector's _d6 (has mapping), plus ModularContextEvent._qb.
public class ModularityExtension implements IExtension {

    private const uid_:String = UID.create(ModularityExtension);   // formerly _ul

    private var context_:IContext;      // formerly _rA_
    private var injector_:Injector;     // formerly _vz
    private var logger_:ILogger;       // formerly _eo
    private var inherit_:Boolean;   // formerly _eW_
    private var expose_:Boolean;    // formerly _extends

    public function ModularityExtension(inherit:Boolean = true, expose:Boolean = true) {
        this.inherit_ = inherit;
        this.expose_ = expose;
    }

    public function extend(context:IContext):void {
        this.context_ = context;
        this.injector_ = context.injector;
        this.logger_ = context.getLogger(this);
        this.context_.lifecycle.beforeInitializing(this.onContextInitializing);
    }

    public function toString():String {
        return this.uid_;
    }

    // formerly _8u
    private function onContextInitializing():void {
        if (this.inherit_) {
            this.broadcastContextExistence();
        }
        if (this.expose_) {
            this.configureExistenceWatcher();
        }
    }

    // formerly _R_L_
    private function broadcastContextExistence():void {
        var contextView:DisplayObjectContainer;
        if (this.injector_.satisfiesDirectly(DisplayObjectContainer)) {
            this.logger_.debug("Context configured to inherit. Broadcasting existence event...");
            contextView = this.injector_.getInstance(DisplayObjectContainer);
            contextView.dispatchEvent(new ModularContextEvent(ModularContextEvent.CONTEXT_ADD, this.context_));
        } else {
            this.logger_.warn("Context has been configured to inherit dependencies but has no way to do so");
        }
    }

    // formerly _03p
    private function configureExistenceWatcher():void {
        var viewManager:IViewManager;
        var contextView:DisplayObjectContainer;
        if (this.injector_.satisfiesDirectly(IViewManager)) {
            this.logger_.debug("Context has a ViewManager. Configuring view manager based context existence watcher...");
            viewManager = this.injector_.getInstance(IViewManager);
            new ViewManagerBasedExistenceWatcher(this.context_, viewManager);
        } else {
            if (this.injector_.satisfiesDirectly(DisplayObjectContainer)) {
                this.logger_.debug("Context has a ContextView. Configuring context view based context existence watcher...");
                contextView = this.injector_.getInstance(DisplayObjectContainer);
                new ContextViewBasedExistenceWatcher(this.context_, contextView);
            } else {
                this.logger_.warn("Context has been configured to expose its dependencies but has no way to do so");
            }
        }
    }
}
}
