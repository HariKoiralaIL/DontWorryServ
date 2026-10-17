package com.company.backgrounds {
import flash.display.Sprite;
import com.company.assembleegameclient.ui.SoundToggleButton;

// Formerly _02t._R_f. Title screen stack: scrolling map, seasonal image, then _zX_ on top.
public class TitleBackground extends Sprite {

    public function TitleBackground() {
        addChild(new ScrollingMapBackground());
        addChild(new HalloweenBackground());
        addChild(new SoundToggleButton());
    }
}
}
