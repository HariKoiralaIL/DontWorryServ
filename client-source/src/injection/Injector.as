package injection
{
    import injection.reflection.DescribeTypeJSONReflector;
    import injection.reflection.DescribeTypeReflector;
    import injection.reflection.Reflector;

    import injectionpoints.InjectionPoint;
    import injectionpoints.ConstructorInjectionPoint;
    import injectionpoints.TypeDescription;
    import injectionpoints.PreDestroyInjectionPoint;

    import injection.utils.SsInternal;
    import injection.utils.TypeDescriptor;

    import injection.InjectorMissingMappingError;
    import injection.InjectorInterfaceConstructionError;

    import injection.mapping.InjectionMapping;
    import injection.mapping.MappingEvent;

    import avmplus.DescribeTypeJSON;

    import flash.events.EventDispatcher;
    import flash.system.ApplicationDomain;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    import providers.ClassProvider;
    import providers.DependencyProvider;
    import providers.LocalOnlyProvider;
    import providers.SoftProvider;

    use namespace SsInternal;

    public class Injector extends EventDispatcher
    {
        private static var injectionPointsCache_:Dictionary = new Dictionary(true);

        SsInternal const providerMappings:Dictionary = new Dictionary();

        private var parent_:Injector;
        private var applicationDomain_:ApplicationDomain;
        private var typeDescriptor_:TypeDescriptor;
        private var mappings_:Dictionary;
        private var mappingsInProgress_:Dictionary;
        private var defaultProviders_:Dictionary;
        private var managedObjects_:Dictionary;
        private var reflector_:Reflector;

        public function Injector()
        {
            super();
            this.mappings_ = new Dictionary();
            this.mappingsInProgress_ = new Dictionary();
            this.defaultProviders_ = new Dictionary();
            this.managedObjects_ = new Dictionary();
            try
            {
                this.reflector_ = DescribeTypeJSON.available ? new DescribeTypeJSONReflector() : new DescribeTypeReflector();
            }
            catch (e:Error)
            {
                this.reflector_ = new DescribeTypeReflector();
            }
            this.typeDescriptor_ = new TypeDescriptor(this.reflector_, injectionPointsCache_);
            this.applicationDomain_ = ApplicationDomain.currentDomain;
        }

        SsInternal static function purgeInjectionPointsCache():void
        {
            injectionPointsCache_ = new Dictionary(true);
        }

        private static function getMappingId(type:Class, name:String):String
        {
            return getQualifiedClassName(type) + "|" + name;
        }

        public function get parent():Injector
        {
            return this.parent_;
        }

        public function set parent(value:Injector):void
        {
            this.parent_ = value;
        }

        public function get applicationDomain():ApplicationDomain
        {
            return this.applicationDomain_;
        }

        public function set applicationDomain(value:ApplicationDomain):void
        {
            this.applicationDomain_ = value || ApplicationDomain.currentDomain;
        }

        public function map(type:Class, name:String = ""):InjectionMapping
        {
            var mappingId:String = getMappingId(type, name);
            return this.mappings_[mappingId] || this.createMapping(type, name, mappingId);
        }

        public function unmap(type:Class, name:String = ""):void
        {
            var mappingId:String = getMappingId(type, name);
            var mapping:InjectionMapping = this.mappings_[mappingId];
            if (mapping && mapping.isSealed)
            {
                throw new InjectorError("Can't unmap a sealed mapping");
            }
            if (!mapping)
            {
                throw new InjectorError("Error while removing an injector mapping: " + "No mapping defined for dependency " + mappingId);
            }
            mapping.getProvider().destroy();
            delete this.mappings_[mappingId];
            delete this.providerMappings[mappingId];
            if (hasEventListener(MappingEvent.POST_MAPPING_REMOVE))
            {
                dispatchEvent(new MappingEvent(MappingEvent.POST_MAPPING_REMOVE, type, name, null));
            }
        }

        public function satisfies(type:Class, name:String = ""):Boolean
        {
            return this.getProvider(getMappingId(type, name)) != null;
        }

        public function satisfiesDirectly(type:Class, name:String = ""):Boolean
        {
            return this.providerMappings[getMappingId(type, name)] != null;
        }

        public function getMapping(type:Class, name:String = ""):InjectionMapping
        {
            var mappingId:String = getMappingId(type, name);
            var mapping:InjectionMapping = this.mappings_[mappingId];
            if (!mapping)
            {
                throw new InjectorMissingMappingError("Error while retrieving an injector mapping: " + "No mapping defined for dependency " + mappingId);
            }
            return mapping;
        }

        public function injectInto(target:Object):void
        {
            var targetType:Class = this.reflector_.getClass(target);
            this.applyInjectionPoints(target, targetType, this.typeDescriptor_.getDescription(targetType));
        }

        public function getInstance(type:Class, name:String = "", targetType:Class = null)
        {
            var mappingId:String = getMappingId(type, name);
            var provider:DependencyProvider = this.getProvider(mappingId, false);
            if (provider)
            {
                var ctorInjectionPoint:ConstructorInjectionPoint = this.typeDescriptor_.getDescription(type).ctor;
                return provider.apply(targetType, this, ctorInjectionPoint ? ctorInjectionPoint.injectParameters : null);
            }
            if (name)
            {
                throw new InjectorMissingMappingError("No mapping found for request " + mappingId + ". getInstance only creates an unmapped instance if no name is given.");
            }
            return this.instantiateUnmapped(type);
        }

        public function destroyInstance(instance:Object):void
        {
            if (!instance)
            {
                return;
            }
            var instanceType:Class = this.reflector_.getClass(instance);
            var description:TypeDescription = this.getTypeDescription(instanceType);
            var injectionPoint:PreDestroyInjectionPoint = description.preDestroyMethods;
            while (injectionPoint)
            {
                injectionPoint.applyInjection(instance, instanceType, this);
                injectionPoint = PreDestroyInjectionPoint(injectionPoint.next);
            }
        }

        public function teardown():void
        {
            var mapping:InjectionMapping;
            var managedObject:Object;
            for each (mapping in this.mappings_)
            {
                mapping.getProvider().destroy();
            }
            for each (managedObject in this.managedObjects_)
            {
                this.destroyInstance(managedObject);
            }
            this.mappings_ = new Dictionary();
            this.mappingsInProgress_ = new Dictionary();
            this.defaultProviders_ = new Dictionary();
            this.managedObjects_ = new Dictionary();
        }

        public function createChildInjector(applicationDomain:ApplicationDomain = null):Injector
        {
            var child:Injector = new Injector();
            child.applicationDomain = applicationDomain || this.applicationDomain;
            child.parent = this;
            return child;
        }

        public function addTypeDescription(type:Class, description:TypeDescription):void
        {
            this.typeDescriptor_.addDescription(type, description);
        }

        public function getTypeDescription(type:Class):TypeDescription
        {
            return this.reflector_.describeInjections(type);
        }

        SsInternal function instantiateUnmapped(type:Class):Object
        {
            var description:TypeDescription = this.typeDescriptor_.getDescription(type);
            if (!description.ctor)
            {
                throw new InjectorInterfaceConstructionError("Can't instantiate interface " + getQualifiedClassName(type));
            }
            var instance:* = description.ctor.createInstance(type, this);
            if (hasEventListener(InjectionEvent.POST_INSTANTIATE))
            {
                dispatchEvent(new InjectionEvent(InjectionEvent.POST_INSTANTIATE, instance, type));
            }
            this.applyInjectionPoints(instance, type, description);
            return instance;
        }

        SsInternal function getProvider(mappingId:String, fallbackToDefault:Boolean = true):DependencyProvider
        {
            var softProvider:DependencyProvider;
            var provider:DependencyProvider;
            var injector:Injector = this;
            while (injector)
            {
                provider = injector.providerMappings[mappingId];
                if (provider)
                {
                    if (provider is SoftProvider)
                    {
                        softProvider = provider;
                        injector = injector.parent;
                        continue;
                    }
                    if (provider is LocalOnlyProvider && injector !== this)
                    {
                        injector = injector.parent;
                        continue;
                    }
                    return provider;
                }
                injector = injector.parent;
            }
            if (softProvider)
            {
                return softProvider;
            }
            return fallbackToDefault ? this.getDefaultProvider(mappingId) : null;
        }

        SsInternal function getDefaultProvider(mappingId:String):DependencyProvider
        {
            var parts:Array;
            var definition:Object;
            if (mappingId === "String|")
            {
                return null;
            }
            parts = mappingId.split("|");
            var mappingName:String = parts.pop();
            if (mappingName.length !== 0)
            {
                return null;
            }
            var typeName:String = parts.pop();
            try
            {
                definition = this.applicationDomain_.hasDefinition(typeName) ? this.applicationDomain_.getDefinition(typeName) : getDefinitionByName(typeName);
            }
            catch (e:Error)
            {
                return null;
            }
            if (!definition || !(definition is Class))
            {
                return null;
            }
            var typeClass:Class = Class(definition);
            var description:TypeDescription = this.typeDescriptor_.getDescription(typeClass);
            if (!description.ctor)
            {
                return null;
            }
            if (!this.defaultProviders_[typeClass])
            {
                this.defaultProviders_[typeClass] = new ClassProvider(typeClass);
            }
            return this.defaultProviders_[typeClass];
        }

        private function createMapping(type:Class, name:String, mappingId:String):InjectionMapping
        {
            if (this.mappingsInProgress_[mappingId])
            {
                throw new InjectorError("Can't change a mapping from inside a listener to it's creation event");
            }
            this.mappingsInProgress_[mappingId] = true;
            if (hasEventListener(MappingEvent.PRE_MAPPING_CREATE))
            {
                dispatchEvent(new MappingEvent(MappingEvent.PRE_MAPPING_CREATE, type, name, null));
            }
            var mapping:InjectionMapping = new InjectionMapping(this, type, name, mappingId);
            this.mappings_[mappingId] = mapping;
            var sealKey:Object = mapping.seal();
            if (hasEventListener(MappingEvent.POST_MAPPING_CREATE))
            {
                dispatchEvent(new MappingEvent(MappingEvent.POST_MAPPING_CREATE, type, name, mapping));
            }
            delete this.mappingsInProgress_[mappingId];
            mapping.unseal(sealKey);
            return mapping;
        }

        private function applyInjectionPoints(target:Object, targetType:Class, description:TypeDescription):void
        {
            var injectionPoint:InjectionPoint = description.injectionPoints;
            if (hasEventListener(InjectionEvent.PRE_CONSTRUCT))
            {
                dispatchEvent(new InjectionEvent(InjectionEvent.PRE_CONSTRUCT, target, targetType));
            }
            while (injectionPoint)
            {
                injectionPoint.applyInjection(target, targetType, this);
                injectionPoint = injectionPoint.next;
            }
            if (description.preDestroyMethods)
            {
                this.managedObjects_[target] = target;
            }
            if (hasEventListener(InjectionEvent.POST_CONSTRUCT))
            {
                dispatchEvent(new InjectionEvent(InjectionEvent.POST_CONSTRUCT, target, targetType));
            }
        }
    }
}
