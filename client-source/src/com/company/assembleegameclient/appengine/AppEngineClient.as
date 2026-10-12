package com.company.assembleegameclient.appengine {
import com.company.assembleegameclient.parameters.Parameters;

import events.GenericDataEvent;
import events.TextErrorEvent;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.getTimer;

public class AppEngineClient extends EventDispatcher {

    private static const ERROR_PREFIX:String = "<Error>";
    private static const FATAL_ERROR_PREFIX:String = "<FatalError>";

    private var baseUrl:String;
    private var maxRetries:int;
    private var retriesLeft:int;
    private var dataFormat:String = URLLoaderDataFormat.TEXT;
    private var command:String;
    private var params:Object;
    private var loader:URLLoader = null;

    public function AppEngineClient(host:String, path:String, secure:Boolean, maxRetries:int = 0) {
        var protocol:String = (!secure || host.indexOf(Parameters.connection) == 0) ? "http://" : "https://";
        this.baseUrl = protocol + host + path + "/";
        this.maxRetries = maxRetries;
    }

    public function setDataFormat(format:String):void {
        this.dataFormat = format;
    }

    public function sendRequest(command:String, params:Object):void {
        this.command = command;
        this.params = params;
        this.params["ignore"] = getTimer(); // cache buster
        this.retriesLeft = this.maxRetries;
        this.load();
    }

    private function load():void {
        this.disposeLoader();
        this.loader = this.createLoader();
        this.loader.load(this.buildRequest(this.command, this.params));
    }

    private function buildRequest(command:String, params:Object):URLRequest {
        var request:URLRequest = new URLRequest(this.baseUrl + command);
        request.method = URLRequestMethod.POST;
        var variables:URLVariables = new URLVariables();
        for (var key:String in params) {
            variables[key] = params[key];
        }
        request.data = variables;
        return request;
    }

    private function createLoader():URLLoader {
        var newLoader:URLLoader = new URLLoader();
        newLoader.dataFormat = this.dataFormat;
        newLoader.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
        newLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
        newLoader.addEventListener(Event.COMPLETE, this.onComplete);
        return newLoader;
    }

    private function disposeLoader():void {
        if (this.loader == null) {
            return;
        }
        this.loader.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
        this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
        this.loader.removeEventListener(Event.COMPLETE, this.onComplete);
        try {
            this.loader.close();
        } catch (e:Error) {
            // loader already finished/closed
        }
        this.loader = null;
    }

    /** Retries while attempts remain, otherwise dispatches a TextErrorEvent. */
    private function fail(message:String):void {
        if (this.retriesLeft > 0) {
            this.retriesLeft--;
            this.load();
            return;
        }
        dispatchEvent(new TextErrorEvent(message));
    }

    private function onSecurityError(event:SecurityErrorEvent):void {
        this.fail("Security Error");
    }

    private function onIOError(event:IOErrorEvent):void {
        var text:String = this.loader.data;
        if (text == null || text.length == 0) {
            text = "Unable to contact server";
        }
        this.fail(text);
    }

    private function onComplete(event:Event):void {
        var response:String = this.loader.data;
        if (response.substring(0, ERROR_PREFIX.length) == ERROR_PREFIX) {
            this.fail(XML(response).toString());
            return;
        }
        if (response.substring(0, FATAL_ERROR_PREFIX.length) == FATAL_ERROR_PREFIX) {
            dispatchEvent(new TextErrorEvent(XML(response)));
            return;
        }
        dispatchEvent(new GenericDataEvent(this.loader.data));
    }

}
}
