package com.company.assembleegameclient.appengine {
import client.util.PNGDecoder;

import com.company.assembleegameclient.parameters.Parameters;

import events.GenericDataEvent;
import events.TextErrorEvent;

import flash.display.BitmapData;
import flash.net.URLLoaderDataFormat;
import flash.utils.ByteArray;

public class RemoteTexture {

    private static const TESTING_HOST:String = "rotmgtesting.appspot.com";
    private static const PRODUCTION_HOST:String = "realmofthemadgod.appspot.com";
    private static const CACHE_BUSTER:Number = Number(new Date().time);

    public var id_:String;
    public var instance_:String;
    public var callback_:Function;

    public function RemoteTexture(id:String, instance:String, callback:Function) {
        this.id_ = id;
        this.instance_ = instance;
        this.callback_ = callback;
    }

    public function run():void {
        var client:AppEngineClient = new AppEngineClient(this.getHost(), "/picture", false);
        client.setDataFormat(URLLoaderDataFormat.BINARY);
        client.addEventListener(GenericDataEvent.GENERIC_DATA, this.onComplete);
        client.addEventListener(TextErrorEvent.TEXT_ERROR, this.onError);
        client.sendRequest("get", {
            "id": this.id_,
            "instance": this.instance_,
            "time": CACHE_BUSTER
        });
    }

    private function getHost():String {
        if (this.instance_ == "testing") {
            return TESTING_HOST;
        }
        if (this.instance_ == "production") {
            return PRODUCTION_HOST;
        }
        return Parameters.serverAddress();
    }

    private function onComplete(event:GenericDataEvent):void {
        this.callback_(PNGDecoder.decodeImage(event.data as ByteArray));
    }

    private function onError(event:TextErrorEvent):void {
        // intentionally ignored: texture simply isn't delivered
    }

}
}
