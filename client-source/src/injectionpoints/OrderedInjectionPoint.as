package injectionpoints {

/**
 * A method injection point that carries an execution order.
 * Base class of the post-construct and pre-destroy points.
 */
public class OrderedInjectionPoint extends MethodInjectionPoint {

    public var order:int;

    public function OrderedInjectionPoint(methodName:String, parameterInjectionIds:Array, requiredParameters:uint, order:int) {
        super(methodName, parameterInjectionIds, requiredParameters, false, null);
        this.order = order;
    }

}
}
