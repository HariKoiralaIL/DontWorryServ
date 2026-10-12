package client.ui.screens {
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.MovieClip;
import flash.events.Event;

import mx.core.MovieClipAsset;

import signals.Signal;

/**
 * Instantiates an embedded MovieClipLoaderAsset class and waits for its inner
 * SWF to finish loading. `ready` dispatches this loader once `content` is set.
 */
public class MovieClipAssetLoader {

    private var asset_:MovieClipAsset;
    private var readySignal:Signal;
    private var loadedContent:MovieClip;

    public function MovieClipAssetLoader(assetClass:Class) {
        this.asset_ = new (assetClass)();
        this.readySignal = new Signal(MovieClipAssetLoader);
        var loader:Loader = Loader(this.asset_.getChildAt(0));
        var loaderInfo:LoaderInfo = loader.contentLoaderInfo;
        loaderInfo.addEventListener(Event.COMPLETE, this.onLoadComplete);
    }

    public function get ready():Signal {
        return this.readySignal;
    }

    public function get content():MovieClip {
        return this.loadedContent;
    }

    public function get asset():MovieClipAsset {
        return this.asset_;
    }

    private function onLoadComplete(event:Event):void {
        var loaderInfo:LoaderInfo = LoaderInfo(event.target);
        loaderInfo.removeEventListener(Event.COMPLETE, this.onLoadComplete);
        this.loadedContent = MovieClip(loaderInfo.loader.content);
        this.readySignal.dispatch(this);
    }

}
}
