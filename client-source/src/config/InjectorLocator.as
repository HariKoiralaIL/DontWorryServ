package config {

import injection.Injector;

import robotlegs.bender.framework.impl.Context;

/**
 * Keeps a global reference to the application's injector so code that is not
 * created by the injector (e.g. PacketManager) can still reach it:
 *
 *     InjectorLocator.getInjector().getInstance(SomeSignal)
 *
 * The reference is captured the first time an instance of this class is created.
 *
 * Formerly _8P_ (getInjector() was _V_O_, injector_ was the static _O_R_).
 *
 * NOTE: the base class _03 comes from package _03T_. The instance member
 * `injector` read in the constructor is inherited from it.
 */
public class InjectorLocator extends Context {

    public static var injector_:Injector;

    public function InjectorLocator() {
        if (!InjectorLocator.injector_) {
            InjectorLocator.injector_ = this.injector;
        }
    }

    public static function getInjector():Injector {
        return injector_;
    }

}
}
