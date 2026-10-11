package injectionpoints {

/**
 * A method that is called once all other injections on the instance are done.
 */
public class PostConstructInjectionPoint extends OrderedInjectionPoint {

    public function PostConstructInjectionPoint(methodName:String, parameterInjectionIds:Array, requiredParameters:uint, order:int) {
        super(methodName, parameterInjectionIds, requiredParameters, order);
    }

}
}
