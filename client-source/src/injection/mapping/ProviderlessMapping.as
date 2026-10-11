package injection.mapping {

import providers.DependencyProvider;

/** A mapping that has not been given a dependency provider yet. */
public interface ProviderlessMapping {

    /** Resolve the mapping by creating a new instance of the given class each time. */
    function toType(type:Class):UnsealedMapping;

    /** Resolve the mapping with the given, pre-existing instance. */
    function toValue(value:Object):UnsealedMapping;

    /** Resolve the mapping with a single shared instance of the given class. */
    function toSingleton(type:Class):UnsealedMapping;

    /** Resolve the mapping with a single shared instance of the mapped class itself. */
    function asSingleton():UnsealedMapping;

    /** Resolve the mapping with a custom provider. */
    function toProvider(provider:DependencyProvider):UnsealedMapping;

    function seal():Object;

}
}//package injection.mapping
