// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.QuestToolTip

package com.company.assembleegameclient.ui.tooltip {
import com.company.ui.SimpleText;
import com.company.assembleegameclient.ui.ui_playerslist;

import flash.filters.DropShadowFilter;

import com.company.assembleegameclient.objects.GameObject;

public class QuestToolTip extends ToolTip {

    public function QuestToolTip(_arg1:GameObject) {
        super(6036765, 1, 16549442, 1, false);
        this.text_ = new SimpleText(22, 16549442, false, 0, 0, "Myriad Pro");
        this.text_.setBold(true);
        this.text_.text = "Quest!";
        this.text_.updateMetrics();
        this.text_.filters = [new DropShadowFilter(0, 0, 0)];
        this.text_.x = 0;
        this.text_.y = 0;
        addChild(this.text_);
        this.playerEntry_ = new ui_playerslist(0xB3B3B3, true, _arg1);
        this.playerEntry_.x = 0;
        this.playerEntry_.y = 32;
        addChild(this.playerEntry_);
        filters = [];
    }
    public var playerEntry_:ui_playerslist;
    private var text_:SimpleText;
}
}//package com.company.assembleegameclient.ui.tooltip

