/**
 * Created by Mike on 17.05.2016.
 */
package com.company.backgrounds {
import flash.display.Sprite;

// Formerly _02t._lxb_
public class CharacterScreenBackground extends Sprite {

    public function CharacterScreenBackground() {
        var bg:charscreenbg = new charscreenbg();
        bg.scaleX = 800 / bg.width;
        bg.scaleY = 600 / bg.height;
        addChild(bg);
    }
}
}
