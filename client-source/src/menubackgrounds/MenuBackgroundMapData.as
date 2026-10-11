package menubackgrounds {

import mx.core.ByteArrayAsset;

/**
 * Embedded map (JSON) that is rendered as the scrolling menu background.
 */
[Embed(source="MenuBackgroundMapData.dat", mimeType="application/octet-stream")]
public class MenuBackgroundMapData extends ByteArrayAsset {

    public function MenuBackgroundMapData() {
        super();
    }

}
}
