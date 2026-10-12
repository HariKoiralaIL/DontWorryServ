package client.ui.screens {
import flash.utils.ByteArray;

import mx.core.MovieClipLoaderAsset;

/**
 * Embedded loading-screen MovieClip. The SWF stub only declares the symbol;
 * the real content is the SWF bytes in MapLoadingScreenData.dat, supplied
 * through movieClipData.
 */
[Embed(source="MapLoadingScreenAsset.swf", symbol="client.ui.screens.MapLoadingScreenAsset")]
public class MapLoadingScreenAsset extends MovieClipLoaderAsset {

    private static var cachedData:ByteArray = null;

    public var dataClass:Class = MapLoadingScreenData;

    public function MapLoadingScreenAsset() {
        super();
        initialWidth = (16000 / 20);
        initialHeight = (12000 / 20);
    }

    public override function get movieClipData():ByteArray {
        if (cachedData == null) {
            cachedData = ByteArray(new this.dataClass());
        }
        return cachedData;
    }

}
}
