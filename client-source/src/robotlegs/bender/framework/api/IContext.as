package robotlegs.bender.framework.api {
import injection.Injector;

import matchers.Matcher;

/** The central object of a module: owns the injector and lifecycle, installs extensions and configs. */
public interface IContext {

    function get injector():Injector;

    function get lifecycle():ILifecycle;

    function get logLevel():uint;

    function set logLevel(value:uint):void;

    function extend(...extensions):IContext;

    function configure(...configs):IContext;

    function addConfigHandler(matcher:Matcher, handler:Function):IContext;

    function getLogger(source:Object):ILogger;

    function addLogTarget(target:ILogTarget):IContext;

    function detain(...instances):IContext;

    function release(...instances):IContext;

}
}//package robotlegs.bender.framework.api
