package injectionpoints {

import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import injection.Injector;
import providers.DependencyProvider;

import injection.utils.SsInternal;
import injection.InjectorMissingMappingError;

/**
 * Sets a property on the target to a value resolved from the injector.
 * When the point is optional, a missing mapping is silently skipped.
 */
public class PropertyInjectionPoint extends InjectionPoint {

    private var propertyName:String;
    private var mappingId:String;
    private var isOptional:Boolean;

    public function PropertyInjectionPoint(mappingId:String, propertyName:String, isOptional:Boolean, injectParameters:Dictionary) {
        this.propertyName = propertyName;
        this.mappingId = mappingId;
        this.isOptional = isOptional;
        this.injectParameters = injectParameters;
    }

    override public function applyInjection(target:Object, targetType:Class, injector:Injector):void {
        var provider:DependencyProvider = injector.SsInternal::getProvider(this.mappingId);
        if (!provider) {
            if (this.isOptional) {
                return;
            }
            throw new InjectorMissingMappingError('Injector is missing a mapping to handle injection into property "' + this.propertyName
                    + '" of object "' + target
                    + '" with type "' + getQualifiedClassName(targetType)
                    + '". Target dependency: "' + this.mappingId + '"');
        }
        target[this.propertyName] = provider.apply(targetType, injector, this.injectParameters);
    }

}
}
