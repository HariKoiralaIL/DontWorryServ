package injectionpoints {

import flash.utils.Dictionary;

import injection.Injector;

/**
 * Creates an instance of a class, passing in constructor parameters
 * resolved from the injector. Supports up to 10 parameters.
 */
public class ConstructorInjectionPoint extends MethodInjectionPoint {

    public function ConstructorInjectionPoint(parameterInjectionIds:Array, requiredParameters:uint, injectParameters:Dictionary) {
        super("ctor", parameterInjectionIds, requiredParameters, false, injectParameters);
    }

    public function createInstance(targetType:Class, injector:Injector):Object {
        var instance:Object;
        var p:Array = this.gatherParameterValues(targetType, targetType, injector);
        switch (p.length) {
            case 1:
                instance = new targetType(p[0]);
                break;
            case 2:
                instance = new targetType(p[0], p[1]);
                break;
            case 3:
                instance = new targetType(p[0], p[1], p[2]);
                break;
            case 4:
                instance = new targetType(p[0], p[1], p[2], p[3]);
                break;
            case 5:
                instance = new targetType(p[0], p[1], p[2], p[3], p[4]);
                break;
            case 6:
                instance = new targetType(p[0], p[1], p[2], p[3], p[4], p[5]);
                break;
            case 7:
                instance = new targetType(p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
                break;
            case 8:
                instance = new targetType(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
                break;
            case 9:
                instance = new targetType(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]);
                break;
            case 10:
                instance = new targetType(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]);
                break;
        }
        p.length = 0;
        return instance;
    }

}
}
