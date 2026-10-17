package com.company.assembleegameclient.ui.tooltip {
import com.company.assembleegameclient.objects.GameObject;
import com.company.util.BitmapUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;

public class PortraitToolTip extends ToolTip {

    private static const BACKGROUND_COLOR:uint = 0x5C1D1D;
    private static const OUTLINE_COLOR:uint = 0xFC8642;
    private static const CROP:int = 10;

    private var portrait_:Bitmap;

    public function PortraitToolTip(gameObject:GameObject) {
        super(BACKGROUND_COLOR, 1, OUTLINE_COLOR, 1, false);
        var portrait:BitmapData = gameObject.getPortrait();
        portrait = BitmapUtil.crop(portrait, CROP, CROP, portrait.width - 2 * CROP, portrait.height - 2 * CROP);
        portrait_ = new Bitmap();
        portrait_.x = 0;
        portrait_.y = 0;
        portrait_.bitmapData = portrait;
        addChild(portrait_);
        filters = [];
    }

}
}
