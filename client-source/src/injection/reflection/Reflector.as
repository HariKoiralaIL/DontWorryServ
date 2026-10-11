package injection.reflection {

import injectionpoints.TypeDescription;

/** Reads type information for the injector. */
public interface Reflector {

    /** The class of the given object (handles Proxy, Number, XML and XMLList specially). */
    function getClass(value:Object):Class;

    /**
     * Fully qualified class name of a value, class or name string.
     * By default uses "pkg::Name"; with replaceColons uses "pkg.Name".
     */
    function getFQCN(value:*, replaceColons:Boolean = false):String;

    /** True if type is superType, extends it, or implements it. */
    function typeImplements(type:Class, superType:Class):Boolean;

    /**
     * Builds the injection description of a type: its constructor,
     * [Inject] fields and methods, [PostConstruct] and [PreDestroy] methods.
     * (_Q_m is that description type.)
     */
    function describeInjections(type:Class):TypeDescription;

}
}//package injection.reflection
