package _Z_4 {

import injection.Injector;
import injection.InjectorError;

import providers.ClassProvider;
import providers.SingletonProvider;
import providers.ValueProvider;
import providers.DependencyProvider;
import providers.ForwardingProvider;
import providers.SoftProvider;
import providers.LocalOnlyProvider;
import providers.InjectorUsingProvider;

import injection.utils.SsInternal;

/**
 * One mapping in an injector: tells the injector how to satisfy requests for a
 * given class (and optional name). Mappings can be sealed to prevent changes.
 *
 * Unresolved external types (defined elsewhere in the project):
 *   _08b = the injector, _N_p = the injector's error type,
 *   _5d  = a dependency provider, _6_ = class provider (new instance each time),
 *   _uS_ = singleton provider, _rP_ = value provider,
 *   _d5  = a provider that wraps another one (exposes it as .provider),
 *   _yi  = "soft" provider wrapper, _Q_4 = "local-only" provider wrapper,
 *   _4c  = provider wrapper bound to a specific injector.
 */
public class InjectionMapping implements ProviderlessMapping, UnsealedMapping {

    private var _type:Class;
    private var _name:String;
    private var _mappingId:String;
    private var _creatingInjector:Injector;
    private var _defaultProviderSet:Boolean;
    private var _overridingInjector:Injector;
    private var _soft:Boolean;
    private var _local:Boolean;
    private var _sealed:Boolean;
    private var _sealKey:Object;

    public function InjectionMapping(creatingInjector:Injector, type:Class, name:String, mappingId:String) {
        this._creatingInjector = creatingInjector;
        this._type = type;
        this._name = name;
        this._mappingId = mappingId;
        this._defaultProviderSet = true;
        // By default a mapping creates a new instance of its own type.
        this.mapProvider(new ClassProvider(type));
    }

    public function get isSealed():Boolean {
        return this._sealed;
    }

    public function asSingleton():UnsealedMapping {
        this.toSingleton(this._type);
        return this;
    }

    public function toType(type:Class):UnsealedMapping {
        this.toProvider(new ClassProvider(type));
        return this;
    }

    public function toSingleton(type:Class):UnsealedMapping {
        this.toProvider(new SingletonProvider(type, this._creatingInjector));
        return this;
    }

    public function toValue(value:Object):UnsealedMapping {
        this.toProvider(new ValueProvider(value));
        return this;
    }

    public function toProvider(provider:DependencyProvider):UnsealedMapping {
        if (this._sealed) {
            this.throwSealedError();
        }
        if (this.hasProvider() && provider != null && !this._defaultProviderSet) {
            trace("Warning: Injector already has a mapping for " + this._mappingId + ".\n "
                + "If you have overridden this mapping intentionally you can use "
                + '"injector.unmap()" prior to your replacement mapping in order to '
                + "avoid seeing this message.");
            if (this._creatingInjector.hasEventListener(MappingEvent.MAPPING_OVERRIDE)) {
                this._creatingInjector.dispatchEvent(
                    new MappingEvent(MappingEvent.MAPPING_OVERRIDE, this._type, this._name, this));
            }
        }
        this.dispatchPreChangeEvent();
        this._defaultProviderSet = false;
        this.mapProvider(provider);
        this.dispatchPostChangeEvent();
        return this;
    }

    /** Make the mapping "soft": it yields to other mappings in parent injectors. */
    public function soft():ProviderlessMapping {
        if (this._sealed) {
            this.throwSealedError();
        }
        if (!this._soft) {
            var provider:DependencyProvider = this.getProvider();
            this.dispatchPreChangeEvent();
            this._soft = true;
            this.mapProvider(provider);
            this.dispatchPostChangeEvent();
        }
        return this;
    }

    /** Make the mapping "local": it is not exposed to child injectors. */
    public function local():ProviderlessMapping {
        if (this._sealed) {
            this.throwSealedError();
        }
        if (this._local) {
            return this;
        }
        var provider:DependencyProvider = this.getProvider();
        this.dispatchPreChangeEvent();
        this._local = true;
        this.mapProvider(provider);
        this.dispatchPostChangeEvent();
        return this;
    }

    public function seal():Object {
        if (this._sealed) {
            throw new InjectorError("Mapping is already sealed.");
        }
        this._sealed = true;
        this._sealKey = {};
        return this._sealKey;
    }

    public function unseal(key:Object):InjectionMapping {
        if (!this._sealed) {
            throw new InjectorError("Can't unseal a non-sealed mapping.");
        }
        if (key !== this._sealKey) {
            throw new InjectorError("Can't unseal mapping without the correct key.");
        }
        this._sealed = false;
        this._sealKey = null;
        return this;
    }

    public function hasProvider():Boolean {
        return Boolean(this._creatingInjector.SsInternal::providerMappings[this._mappingId]);
    }

    /** The underlying provider, with any wrapper providers (soft/local/injector) removed. */
    public function getProvider():DependencyProvider {
        var provider:DependencyProvider = this._creatingInjector.SsInternal::providerMappings[this._mappingId];
        while (provider is ForwardingProvider) {
            provider = ForwardingProvider(provider).provider;
        }
        return provider;
    }

    /** Resolve this mapping using a different injector than the one that created it. */
    public function setInjector(injector:Injector):InjectionMapping {
        if (this._sealed) {
            this.throwSealedError();
        }
        if (injector == this._overridingInjector) {
            return this;
        }
        var provider:DependencyProvider = this.getProvider();
        this._overridingInjector = injector;
        this.mapProvider(provider);
        return this;
    }

    /** Stores the provider in the injector, wrapped according to the soft/local/injector settings. */
    private function mapProvider(provider:DependencyProvider):void {
        if (this._soft) {
            provider = new SoftProvider(provider);
        }
        if (this._local) {
            provider = new LocalOnlyProvider(provider);
        }
        if (this._overridingInjector) {
            provider = new InjectorUsingProvider(this._overridingInjector, provider);
        }
        this._creatingInjector.SsInternal::providerMappings[this._mappingId] = provider;
    }

    private function throwSealedError():void {
        throw new InjectorError("Can't change a sealed mapping");
    }

    private function dispatchPreChangeEvent():void {
        if (this._creatingInjector.hasEventListener(MappingEvent.PRE_MAPPING_CHANGE)) {
            this._creatingInjector.dispatchEvent(
                new MappingEvent(MappingEvent.PRE_MAPPING_CHANGE, this._type, this._name, this));
        }
    }

    private function dispatchPostChangeEvent():void {
        if (this._creatingInjector.hasEventListener(MappingEvent.POST_MAPPING_CHANGE)) {
            this._creatingInjector.dispatchEvent(
                new MappingEvent(MappingEvent.POST_MAPPING_CHANGE, this._type, this._name, this));
        }
    }

}
}//package _Z_4
