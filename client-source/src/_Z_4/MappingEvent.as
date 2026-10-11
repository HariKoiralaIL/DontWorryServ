package _Z_4 {

import flash.events.Event;

/** Dispatched by the injector when a mapping is created, changed, overridden or removed. */
public class MappingEvent extends Event {

    public static const PRE_MAPPING_CREATE:String = "preMappingCreate";
    public static const POST_MAPPING_CREATE:String = "postMappingCreate";
    public static const PRE_MAPPING_CHANGE:String = "preMappingChange";
    public static const POST_MAPPING_CHANGE:String = "postMappingChange";
    public static const POST_MAPPING_REMOVE:String = "postMappingRemove";
    public static const MAPPING_OVERRIDE:String = "mappingOverride";

    /** The class the mapping is for. */
    public var mappedType:Class;

    /** The optional name the mapping is registered under. */
    public var mappedName:String;

    public var mapping:InjectionMapping;

    public function MappingEvent(type:String, mappedType:Class, mappedName:String, mapping:InjectionMapping) {
        super(type);
        this.mappedType = mappedType;
        this.mappedName = mappedName;
        this.mapping = mapping;
    }

    override public function clone():Event {
        return new MappingEvent(type, this.mappedType, this.mappedName, this.mapping);
    }

}
}//package _Z_4
