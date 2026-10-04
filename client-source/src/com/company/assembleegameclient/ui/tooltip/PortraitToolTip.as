// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.PortraitToolTip

package com.company.assembleegameclient.ui.tooltip {
import flash.display.Bitmap;
import flash.display.BitmapData;

import com.company.util.BitmapUtil;
import com.company.assembleegameclient.objects.GameObject;

public class PortraitToolTip extends ToolTip {

    public function PortraitToolTip(_arg1:GameObject) {
        super(6036765, 1, 16549442, 1, false);
        this.portrait_ = new Bitmap();
        this.portrait_.x = 0;
        this.portrait_.y = 0;
        var bitmapData2:BitmapData = _arg1.getPortrait();
        bitmapData2 = BitmapUtil._Y_d(bitmapData2, 10, 10, (bitmapData2.width - 20), (bitmapData2.height - 20));
        this.portrait_.bitmapData = bitmapData2;
        addChild(this.portrait_);
        filters = [];
    }
    private var portrait_:Bitmap;
}
}//package com.company.assembleegameclient.ui.tooltip

