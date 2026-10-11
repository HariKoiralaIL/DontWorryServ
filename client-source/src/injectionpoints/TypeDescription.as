package injectionpoints {

import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import injection.InjectorError;

/**
 * Describes how a class is injected: its constructor, its property/method
 * injection points (a linked list starting at `injectionPoints`) and its
 * pre-destroy methods (a separate linked list).
 */
public class TypeDescription {

    public var ctor:ConstructorInjectionPoint;
    public var injectionPoints:InjectionPoint;
    public var preDestroyMethods:PreDestroyInjectionPoint;
    private var postConstructAdded:Boolean;

    public function TypeDescription(useDefaultConstructor:Boolean = true) {
        if (useDefaultConstructor) {
            this.ctor = new NoParamsConstructorInjectionPoint();
        }
    }

    public function addConstructorInjection(parameterTypes:Array, parameterNames:Array = null, requiredParameters:uint = int.MAX_VALUE, injectParameters:Dictionary = null):TypeDescription {
        this.ctor = new ConstructorInjectionPoint(
                this.createParameterMappingIds(parameterTypes, parameterNames || []),
                requiredParameters,
                injectParameters);
        return this;
    }

    public function addFieldInjection(propertyName:String, propertyType:Class, injectionName:String = "", isOptional:Boolean = false, injectParameters:Dictionary = null):TypeDescription {
        this.assertPostConstructNotAdded();
        this.addInjectionPoint(new PropertyInjectionPoint(
                getQualifiedClassName(propertyType) + "|" + injectionName,
                propertyName,
                isOptional,
                injectParameters));
        return this;
    }

    public function addMethodInjection(methodName:String, parameterTypes:Array, parameterNames:Array = null, requiredParameters:uint = int.MAX_VALUE, isOptional:Boolean = false, injectParameters:Dictionary = null):TypeDescription {
        this.assertPostConstructNotAdded();
        this.addInjectionPoint(new MethodInjectionPoint(
                methodName,
                this.createParameterMappingIds(parameterTypes, parameterNames || []),
                Math.min(requiredParameters, parameterTypes.length),
                isOptional,
                injectParameters));
        return this;
    }

    public function addPostConstructMethod(methodName:String, parameterTypes:Array, parameterNames:Array = null, requiredParameters:uint = int.MAX_VALUE):TypeDescription {
        this.postConstructAdded = true;
        this.addInjectionPoint(new PostConstructInjectionPoint(
                methodName,
                this.createParameterMappingIds(parameterTypes, parameterNames || []),
                Math.min(requiredParameters, parameterTypes.length),
                0));
        return this;
    }

    public function addPreDestroyMethod(methodName:String, parameterTypes:Array, parameterNames:Array = null, requiredParameters:uint = int.MAX_VALUE):TypeDescription {
        var point:PreDestroyInjectionPoint = new PreDestroyInjectionPoint(
                methodName,
                this.createParameterMappingIds(parameterTypes, parameterNames || []),
                Math.min(requiredParameters, parameterTypes.length),
                0);
        this.preDestroyMethods = this.appendToList(this.preDestroyMethods, point) as PreDestroyInjectionPoint;
        return this;
    }

    public function addInjectionPoint(point:InjectionPoint):void {
        this.injectionPoints = this.appendToList(this.injectionPoints, point);
    }

    private function assertPostConstructNotAdded():void {
        if (this.postConstructAdded) {
            throw new InjectorError("Can't add injection point after post construct method");
        }
    }

    /**
     * Appends `point` to the list starting at `head` and returns the
     * (possibly new) head. The head's `last` is kept pointing at the tail.
     */
    private function appendToList(head:InjectionPoint, point:InjectionPoint):InjectionPoint {
        if (head) {
            head.last.next = point;
        } else {
            head = point;
        }
        head.last = point;
        return head;
    }

    private function createParameterMappingIds(parameterTypes:Array, parameterNames:Array):Array {
        var ids:Array = new Array(parameterTypes.length);
        var i:int = ids.length;
        while (i--) {
            ids[i] = getQualifiedClassName(parameterTypes[i]) + "|" + (parameterNames[i] || "");
        }
        return ids;
    }

}
}
