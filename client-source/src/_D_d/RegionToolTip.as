// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_D_d.RegionToolTip

package _D_d {
import com.company.assembleegameclient.ui.tooltip.ToolTip;

import com.company.ui.SimpleText;

import flash.filters.DropShadowFilter;

public class RegionToolTip extends ToolTip {

    private static const TOOLTIP_WIDTH:int = 180;

    public function RegionToolTip(regionXml:XML) {
        super(0x363636, 1, 0x9B9B9B, 1, true);
        this.nameText_ = new SimpleText(16, 0xFFFFFF, false, (TOOLTIP_WIDTH - 4), 0, "Myriad Pro");
        this.nameText_.setBold(true);
        this.nameText_.wordWrap = true;
        this.nameText_.text = String(regionXml.@id);
        this.nameText_._08S_();
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        this.nameText_.x = 0;
        this.nameText_.y = 0;
        addChild(this.nameText_);
    }
    private var nameText_:SimpleText;
}
}//package _D_d

