package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;

/**
 * Shows the number of keys the player owns next to a key icon.
 *
 * Formerly: _1B_v
 */
public class KeyCountDisplay extends Sprite {

    private static const FONT_SIZE:int = 18;
    private static const KEY_ICON_INDEX:int = 182;

    private var countText_:SimpleText;
    private var keyIcon_:Bitmap;
    private var keys_:int = -1;

    public function KeyCountDisplay() {
        super();
        this.countText_ = new SimpleText(FONT_SIZE, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.countText_.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        addChild(this.countText_);
        var icon:BitmapData = AssetLibrary.getImageFromSet("lofiObj3", KEY_ICON_INDEX);
        icon = TextureRedrawer.redraw(icon, 40, true, 0, 0);
        this.keyIcon_ = new Bitmap(icon);
        addChild(this.keyIcon_);
        this.draw(0);
        mouseEnabled = false;
        doubleClickEnabled = false;
    }

    public function draw(keys:int):void {
        if (keys === this.keys_) {
            return;
        }
        this.keys_ = keys;
        this.keyIcon_.x = -this.keyIcon_.width;
        this.countText_.text = this.keys_.toString();
        this.countText_.updateMetrics();
        this.countText_.x = (this.keyIcon_.x - this.countText_.width) + 8;
        this.countText_.y = (this.keyIcon_.height / 2) - (this.countText_.height / 2);
    }
}
}
