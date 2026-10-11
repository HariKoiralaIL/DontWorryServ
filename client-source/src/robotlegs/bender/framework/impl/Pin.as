package robotlegs.bender.framework.impl {
import flash.utils.Dictionary;

/**
 * Holds strong references to instances so they are not garbage collected.
 */
public class Pin {

    private const _instances:Dictionary = new Dictionary(false);

    public function detain(instance:Object):void {
        _instances[instance] = true;
    }

    public function release(instance:Object):void {
        delete _instances[instance];
    }

    public function flush():void {
        var instance:Object;
        for (instance in _instances) {
            delete _instances[instance];
        }
    }

}
}
