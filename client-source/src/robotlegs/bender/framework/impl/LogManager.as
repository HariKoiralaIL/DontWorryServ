package robotlegs.bender.framework.impl {
import robotlegs.bender.framework.api.ILogTarget;
import robotlegs.bender.framework.api.ILogger;

/**
 * Creates loggers and fans log messages out to registered targets,
 * dropping anything less severe than the configured log level.
 */
public class LogManager implements ILogTarget {

    private static const DEFAULT_LOG_LEVEL:uint = 16; // INFO

    private const _targets:Vector.<ILogTarget> = new Vector.<ILogTarget>();

    private var _logLevel:uint = DEFAULT_LOG_LEVEL;

    public function get logLevel():uint {
        return _logLevel;
    }

    public function set logLevel(value:uint):void {
        _logLevel = value;
    }

    public function getLogger(source:Object):ILogger {
        return new Logger(source, this);
    }

    public function addLogTarget(target:ILogTarget):void {
        _targets.push(target);
    }

    public function log(source:Object, level:uint, timestamp:int, message:String, params:Array = null):void {
        var target:ILogTarget;
        if (level > _logLevel) {
            return;
        }
        for each (target in _targets) {
            target.log(source, level, timestamp, message, params);
        }
    }

}
}
