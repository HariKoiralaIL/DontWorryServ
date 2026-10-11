package robotlegs.bender.framework.impl {
import matchers.Matcher;

import injection.Injector;

import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.ILifecycle;
import robotlegs.bender.framework.api.ILogTarget;
import robotlegs.bender.framework.api.ILogger;

/**
 * Core application context: owns the injector, lifecycle, config manager,
 * extension installer, log manager and the pin that keeps detained instances alive.
 */
public class Context implements IContext {

    private const _injector:Injector = new Injector();
    private const _uid:String = UID.create(Context);
    private const _logManager:LogManager = new LogManager();
    private const _pin:Pin = new Pin();

    private var _lifecycle:Lifecycle;
    private var _configManager:ConfigManager;
    private var _extensionInstaller:ExtensionInstaller;
    private var _logger:ILogger;

    public function Context() {
        setup();
    }

    public function get injector():Injector {
        return _injector;
    }

    public function get logLevel():uint {
        return _logManager.logLevel;
    }

    public function set logLevel(value:uint):void {
        _logManager.logLevel = value;
    }

    public function get lifecycle():ILifecycle {
        return _lifecycle;
    }

    public function initialize():void {
        _lifecycle.initialize();
    }

    public function destroy():void {
        _lifecycle.destroy();
    }

    public function extend(...extensions):IContext {
        var extension:Object;
        for each (extension in extensions) {
            _extensionInstaller.install(extension);
        }
        return this;
    }

    public function configure(...configs):IContext {
        var config:Object;
        for each (config in configs) {
            _configManager.addConfig(config);
        }
        return this;
    }

    public function addConfigHandler(matcher:Matcher, handler:Function):IContext {
        _configManager.addConfigHandler(matcher, handler);
        return this;
    }

    public function getLogger(source:Object):ILogger {
        return _logManager.getLogger(source);
    }

    public function addLogTarget(target:ILogTarget):IContext {
        _logManager.addLogTarget(target);
        return this;
    }

    public function detain(...instances):IContext {
        var instance:Object;
        for each (instance in instances) {
            _pin.detain(instance);
        }
        return this;
    }

    public function release(...instances):IContext {
        var instance:Object;
        for each (instance in instances) {
            _pin.release(instance);
        }
        return this;
    }

    public function toString():String {
        return _uid;
    }

    private function setup():void {
        _injector.map(Injector).toValue(_injector);
        _injector.map(IContext).toValue(this);
        _logger = _logManager.getLogger(this);
        _lifecycle = new Lifecycle(this);
        _configManager = new ConfigManager(this);
        _extensionInstaller = new ExtensionInstaller(this);
        _lifecycle.beforeInitializing(beforeInitializing);
        _lifecycle.afterInitializing(afterInitializing);
        _lifecycle.beforeDestroying(beforeDestroying);
        _lifecycle.afterDestroying(afterDestroying);
    }

    private function beforeInitializing():void {
        _logger.info("Initializing...");
    }

    private function afterInitializing():void {
        _logger.info("Initialize complete");
    }

    private function beforeDestroying():void {
        _logger.info("Destroying...");
    }

    private function afterDestroying():void {
        _pin.flush();
        _injector.teardown();
        _logger.info("Destroy complete");
    }

}
}
