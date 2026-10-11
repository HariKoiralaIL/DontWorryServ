package injectionpoints {

import avmplus.getQualifiedClassName;

import flash.utils.Dictionary;

import injection.Injector;
import providers.DependencyProvider;

import injection.utils.SsInternal;
import injection.InjectorMissingMappingError;

/**
 * Calls a method on the target with parameters resolved from the injector.
 * The call is skipped when fewer than `requiredParameters` could be resolved.
 */
public class MethodInjectionPoint extends InjectionPoint {

    // Reused between calls to avoid allocating an array per injection.
    // Every user has to reset its length to 0 when done.
    private static const parameterPool:Array = [];

    protected var parameterInjectionIds:Array;
    protected var requiredParameters:int;
    private var isOptional:Boolean;
    private var methodName:String;

    public function MethodInjectionPoint(methodName:String, parameterInjectionIds:Array, requiredParameters:uint, isOptional:Boolean, injectParameters:Dictionary) {
        this.methodName = methodName;
        this.parameterInjectionIds = parameterInjectionIds;
        this.requiredParameters = requiredParameters;
        this.isOptional = isOptional;
        this.injectParameters = injectParameters;
    }

    override public function applyInjection(target:Object, targetType:Class, injector:Injector):void {
        var parameters:Array = this.gatherParameterValues(target, targetType, injector);
        if (parameters.length >= this.requiredParameters) {
            (target[this.methodName] as Function).apply(target, parameters);
        }
        parameters.length = 0;
    }

    protected function gatherParameterValues(target:Object, targetType:Class, injector:Injector):Array {
        var id:String;
        var provider:DependencyProvider;
        var count:int = this.parameterInjectionIds.length;
        var parameters:Array = parameterPool;
        parameters.length = count;
        for (var i:int = 0; i < count; i++) {
            id = this.parameterInjectionIds[i];
            provider = injector.SsInternal::getProvider(id);
            if (!provider) {
                if (i >= this.requiredParameters || this.isOptional) {
                    break;
                }
                throw new InjectorMissingMappingError('Injector is missing a mapping to handle injection into target "' + target
                        + '" of type "' + getQualifiedClassName(targetType)
                        + '". \t\t\t\t\t\tTarget dependency: ' + id
                        + ", method: " + this.methodName
                        + ", parameter: " + (i + 1));
            }
            parameters[i] = provider.apply(targetType, injector, this.injectParameters);
        }
        return parameters;
    }

}
}
