package injectionpoints {

/**
 * A method that is called before the instance is destroyed.
 */
public class PreDestroyInjectionPoint extends OrderedInjectionPoint {

    public function PreDestroyInjectionPoint(methodName:String, parameterInjectionIds:Array, requiredParameters:uint, order:int) {
        super(methodName, parameterInjectionIds, requiredParameters, order);
    }

}
}
