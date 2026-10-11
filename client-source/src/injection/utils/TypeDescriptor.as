package injection.utils {
import flash.utils.Dictionary;

import injection.reflection.Reflector;

import injectionpoints.TypeDescription;

/** Describes the injection points of classes, caching each description after its first lookup. */
public class TypeDescriptor {

    public var descriptionsCache:Dictionary;
    private var reflector:Reflector;

    public function TypeDescriptor(reflector:Reflector, descriptionsCache:Dictionary) {
        this.descriptionsCache = descriptionsCache;
        this.reflector = reflector;
    }

    /** Returns the cached description of a class, reflecting on the class on first use. */
    public function getDescription(type:Class):TypeDescription {
        var description:TypeDescription = descriptionsCache[type];
        if (!description) {
            description = reflector.describeInjections(type);
            descriptionsCache[type] = description;
        }
        return description;
    }

    /** Stores a description for a class, replacing any cached one. */
    public function addDescription(type:Class, description:TypeDescription):void {
        descriptionsCache[type] = description;
    }

}
}
