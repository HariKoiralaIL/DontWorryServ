package ui.mediators {
import client.enums.PositionSlot;

import flash.display.Sprite;

import mx.core.BitmapAsset;

/**
 * Panel with four key slots. The background shows empty slots; showKey()/hideKey()
 * add or remove the coloured key icon for a PositionSlot.
 * Icon order matches PositionSlot.position: 0 purple, 1 green, 2 red, 3 yellow.
 */
public class KeyPanel extends Sprite {

    private static const SLOT_COUNT:int = 4;
    private static const ICON_START_X:int = 12;
    private static const ICON_Y:int = 12;
    private static const ICON_SPACING:int = 40;

    private var background:BitmapAsset;
    private var icons:Vector.<BitmapAsset>;

    public function KeyPanel() {
        super();
        this.background = new KeySlotsBackground();
        addChild(this.background);
        this.icons = new <BitmapAsset>[new KeyIconPurple(), new KeyIconGreen(), new KeyIconRed(), new KeyIconYellow()];
        this.icons.fixed = true;
        for (var i:int = 0; i < SLOT_COUNT; i++) {
            this.icons[i].x = ICON_START_X + ICON_SPACING * i;
            this.icons[i].y = ICON_Y;
        }
    }

    public function showKey(slot:PositionSlot):void {
        var icon:BitmapAsset = this.icons[slot.position];
        if (!contains(icon)) {
            addChild(icon);
        }
    }

    public function hideKey(slot:PositionSlot):void {
        var icon:BitmapAsset = this.icons[slot.position];
        if (contains(icon)) {
            removeChild(icon);
        }
    }

}
}
