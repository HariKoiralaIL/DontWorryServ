package robotlegs.bender.framework.impl {
import flash.utils.getTimer;

import robotlegs.bender.framework.api.ILogTarget;
import robotlegs.bender.framework.api.ILogger;

/**
 * Logger bound to a single source object, forwarding every message to a log target.
 */
public class Logger implements ILogger {

    private static const FATAL:uint = 2;
    private static const ERROR:uint = 4;
    private static const WARN:uint = 8;
    private static const INFO:uint = 16;
    private static const DEBUG:uint = 32;

    private var _source:Object;
    private var _target:ILogTarget;

    public function Logger(source:Object, target:ILogTarget) {
        _source = source;
        _target = target;
    }

    public function debug(message:*, params:Array = null):void {
        _target.log(_source, DEBUG, getTimer(), message, params);
    }

    public function info(message:*, params:Array = null):void {
        _target.log(_source, INFO, getTimer(), message, params);
    }

    public function warn(message:*, params:Array = null):void {
        _target.log(_source, WARN, getTimer(), message, params);
    }

    public function error(message:*, params:Array = null):void {
        _target.log(_source, ERROR, getTimer(), message, params);
    }

    public function fatal(message:*, params:Array = null):void {
        _target.log(_source, FATAL, getTimer(), message, params);
    }

}
}
