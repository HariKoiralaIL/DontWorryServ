package com.company.backgrounds {
import flash.display.Sprite;
import flash.net.URLRequest;

import gif.player.GIFPlayer;

// Formerly _02t._lM_. Halloween image with an animated panda gif on top.
// (The old code also built background and background2 but only ever added the Halloween one.)
public class HalloweenBackground extends Sprite {

    public function HalloweenBackground() {
        var bg:backgroundHalloween = new backgroundHalloween();
        bg.scaleX = 800 / bg.width;
        bg.scaleY = 600 / bg.height;

        var panda:GIFPlayer = new GIFPlayer();
        panda.load(new URLRequest("http://bledixon.com/images/Halloween-Panda-Gif.gif"));
        panda.x = 300;
        panda.y = 200;

        addChild(bg);
        addChild(panda);
    }
}
}
