package com.company.assembleegameclient.engine3d {

/** Result of comparing the depth order of two overlapping lines/faces. */
public class Order {

    public static const INDETERMINATE:int = 0;
    public static const ABOVE:int = 1;
    public static const BELOW:int = 2;

    public function Order(enforcer:StaticEnforcer) {
    }
}
}

class StaticEnforcer {

}
