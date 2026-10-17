package menubackgrounds {

import flash.display.Sprite;

import com.company.assembleegameclient.ui.SoundToggleButton;

/**
 * The menu's background stack: scrolling map at the bottom, then the seasonal
 * overlay, then the _zX_ element on top.
 */
public class MenuBackground extends Sprite {

    public function MenuBackground() {
        addChild(new ScrollingMapBackground());
        addChild(new SeasonalOverlay());
        addChild(new SoundToggleButton());
    }

}
}
