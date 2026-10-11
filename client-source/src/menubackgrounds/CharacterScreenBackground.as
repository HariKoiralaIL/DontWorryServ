package menubackgrounds {

import flash.display.Sprite;

/**
 * Full-screen background image of the character screen.
 * (Created by Mike on 17.05.2016.)
 */
public class CharacterScreenBackground extends Sprite {

    private static const WIDTH:int = 800;
    private static const HEIGHT:int = 600;

    public function CharacterScreenBackground() {
        var image:charscreenbg = new charscreenbg();
        image.alpha = 1;
        image.scaleX = WIDTH / image.width;
        image.scaleY = HEIGHT / image.height;
        addChild(image);
    }

}
}
