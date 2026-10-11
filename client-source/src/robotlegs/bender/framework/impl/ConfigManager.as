package robotlegs.bender.framework.impl {
import org.hamcrest.core.allOf;
import org.hamcrest.core.not;

import matchers.instanceOf;

import matchers.Matcher;

import flash.display.DisplayObject;
import flash.utils.Dictionary;

import injection.Injector;

import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.ILogger;
import robotlegs.bender.framework.api.LifecycleEvent;

/**
 * Collects configs (classes or objects) and applies them once the context initializes.
 * Configs added after initialization are applied immediately.
 */
public class ConfigManager {

    private static const _objectMatcher:Matcher = allOf(instanceOf(Object), not(instanceOf(Class)), not(instanceOf(DisplayObject)));

    private const _uid:String = UID.create(ConfigManager);
    private const _objectProcessor:ObjectProcessor = new ObjectProcessor();
    private const _configs:Dictionary = new Dictionary();
    private const _queue:Array = [];

    private var _injector:Injector;
    private var _logger:ILogger;
    private var _initialized:Boolean;

    public function ConfigManager(context:IContext) {
        _injector = context.injector;
        _logger = context.getLogger(this);
        addConfigHandler(instanceOf(Class), handleClass);
        addConfigHandler(_objectMatcher, handleObject);
        context.lifecycle.addEventListener(LifecycleEvent.INITIALIZE, initialize, false, -100);
    }

    public function addConfig(config:Object):void {
        if (!_configs[config]) {
            _configs[config] = true;
            _objectProcessor.processObject(config);
        }
    }

    public function addConfigHandler(matcher:Matcher, handler:Function):void {
        _objectProcessor.addObjectHandler(matcher, handler);
    }

    public function toString():String {
        return _uid;
    }

    private function handleClass(type:Class):void {
        if (_initialized) {
            _logger.debug("Already initialized. Instantiating config class {0}", [type]);
            instantiateConfig(type);
        } else {
            _logger.debug("Not yet initialized. Queuing config class {0}", [type]);
            _queue.push(type);
        }
    }

    private function handleObject(object:Object):void {
        if (_initialized) {
            _logger.debug("Already initialized. Injecting into config object {0}", [object]);
            injectAndConfigure(object);
        } else {
            _logger.debug("Not yet initialized. Queuing config object {0}", [object]);
            _queue.push(object);
        }
    }

    private function processQueue():void {
        var config:Object;
        for each (config in _queue) {
            if (config is Class) {
                _logger.debug("Now initializing. Instantiating config class {0}", [config]);
                instantiateConfig(config as Class);
            } else {
                _logger.debug("Now initializing. Injecting into config object {0}", [config]);
                injectAndConfigure(config);
            }
        }
        _queue.length = 0;
    }

    private function instantiateConfig(type:Class):void {
        var config:IConfig = _injector.getInstance(type) as IConfig;
        if (config) {
            config.configure();
        }
    }

    private function injectAndConfigure(object:Object):void {
        _injector.injectInto(object);
        var config:IConfig = object as IConfig;
        if (config) {
            config.configure();
        }
    }

    private function initialize(event:LifecycleEvent):void {
        if (!_initialized) {
            _initialized = true;
            processQueue();
        }
    }

}
}
