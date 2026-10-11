package robotlegs.bender.framework.impl {

/**
 * Calls a callback with as many arguments as its signature accepts (0, 1 or 2).
 */
public function safelyCallBack(callback:Function, error:Object = null, message:Object = null):void {
    if (callback.length == 0) {
        callback();
    } else if (callback.length == 1) {
        callback(error);
    } else {
        callback(error, message);
    }
}
}
