package robotlegs.bender.extensions.mediatorMap {
import robotlegs.bender.framework.impl.UID;

import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IContext;

import mediators.IMediatorFactory;
import mediators.IMediatorMap;

import mediators.impl.MediatorMap;
import mediators.impl.MediatorFactory;
import mediators.impl.MediatorManager;

import injection.Injector;

import views.IViewHandler;
import views.IViewManager;

// Formerly _0L_j. A context extension that installs mediator support:
//  - on install: maps _07A_ to _x9 and _v1 (the mediator map) to _Q_6, both as singletons;
//  - when the context initializes: resolves the mediator map and, if the context has a
//    view manager, registers the mediator map as a view handler;
//  - when the context is destroying: clears all mediators and unregisters the view handler;
//  - after it is destroyed: removes the two mappings again.
//
// NOTE: the types and members below come from other packages and keep obfuscated names:
//   _D_v extension interface, _L_y context, _078 unique-id helper, _08b injector,
//   _v1 mediator map (interface), _07A_ (mediator factory interface, _N_y = remove all),
//   _x9 / _Q_6 their implementations, _zu (resolved but unused here),
//   the context's _O_R_ (injector) and _iL_ (lifecycle: _8u / _zi / _kf register the three
//   callbacks), and the injector's _d6 (has mapping) and _1Y_ (unmap).
// The field names below are inferred from usage.
public class MediatorMapExtension implements IExtension {

    private const uid_:String = UID.create(MediatorMapExtension);   // formerly _ul

    private var injector_:Injector;               // formerly _vz
    private var mediatorMap_:IMediatorMap;             // formerly _R_j
    private var viewManager_:IViewManager;    // formerly _yv
    private var _60:MediatorManager;                      // resolved on init but never used; role unknown

    public function extend(context:IContext):void {
        this.injector_ = context.injector;
        this.injector_.map(IMediatorFactory).toSingleton(MediatorFactory);
        this.injector_.map(IMediatorMap).toSingleton(MediatorMap);
        context.lifecycle.beforeInitializing(this.onContextInitializing);
        context.lifecycle.beforeDestroying(this.onContextDestroying);
        context.lifecycle.whenDestroying(this.onContextDestroyed);
    }

    public function toString():String {
        return this.uid_;
    }

    // formerly _8u
    private function onContextInitializing():void {
        this.mediatorMap_ = this.injector_.getInstance(IMediatorMap);
        this._60 = this.injector_.getInstance(MediatorManager);
        if (this.injector_.satisfiesDirectly(IViewManager)) {
            this.viewManager_ = this.injector_.getInstance(IViewManager);
            this.viewManager_.addViewHandler(this.mediatorMap_ as IViewHandler);
        }
    }

    // formerly _zi
    private function onContextDestroying():void {
        var mediatorFactory:IMediatorFactory = this.injector_.getInstance(IMediatorFactory);
        mediatorFactory.removeAllMediators();
        if (this.injector_.satisfiesDirectly(IViewManager)) {
            this.viewManager_ = this.injector_.getInstance(IViewManager);
            this.viewManager_.removeViewHandler(this.mediatorMap_ as IViewHandler);
        }
    }

    // formerly _kf
    private function onContextDestroyed():void {
        if (this.injector_.satisfiesDirectly(IMediatorMap)) {
            this.injector_.unmap(IMediatorMap);
        }
        if (this.injector_.satisfiesDirectly(IMediatorFactory)) {
            this.injector_.unmap(IMediatorFactory);
        }
    }
}
}
