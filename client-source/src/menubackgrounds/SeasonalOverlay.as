package menubackgrounds {

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.net.URLRequest;

import gif.player.GIFPlayer;

/**
 * Seasonal full-screen image plus an animated GIF, shown above the
 * scrolling menu map. Currently set up for Halloween.
 */
public class SeasonalOverlay extends Sprite {

    private static const WIDTH:int = 800;
    private static const HEIGHT:int = 600;
    private static const PANDA_GIF_URL:String = "http://bledixon.com/images/Halloween-Panda-Gif.gif";

    /** Available full-screen images (library classes). */
    private static const BACKGROUNDS:Array = [background, background2, backgroundHalloween];
    /** Index into BACKGROUNDS; use int(BACKGROUNDS.length * Math.random()) for a random one. */
    private static const SELECTED_BACKGROUND:int = 2;

    public function SeasonalOverlay() {
        var imageClass:Class = BACKGROUNDS[SELECTED_BACKGROUND];
        var image:DisplayObject = new imageClass() as DisplayObject;
        image.alpha = 1;
        image.scaleX = WIDTH / image.width;
        image.scaleY = HEIGHT / image.height;

        var panda:GIFPlayer = new GIFPlayer();
        panda.load(new URLRequest(PANDA_GIF_URL));
        panda.alpha = 1;
        panda.x = 300;
        panda.y = 200;

        addChild(image);
        addChild(panda);
    }

}
}
