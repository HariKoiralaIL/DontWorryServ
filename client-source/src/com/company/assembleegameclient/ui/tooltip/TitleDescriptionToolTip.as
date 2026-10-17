package com.company.assembleegameclient.ui.tooltip {
import com.company.ui.SimpleText;

import flash.filters.DropShadowFilter;

public class TitleDescriptionToolTip extends ToolTip {

    public var titleText_:SimpleText;      // formerly _P_V_
    public var descriptionText_:SimpleText;

    public function TitleDescriptionToolTip(backgroundColor:uint, outlineColor:uint, title:String, description:String, wrapWidth:int) {
        super(backgroundColor, 1, outlineColor, 1);
        if (title != null) {
            titleText_ = new SimpleText(20, 0xFFFFFF, false, wrapWidth, 0, "Myriad Pro");
            titleText_.setBold(true);
            titleText_.wordWrap = true;
            titleText_.text = title;
            titleText_.updateMetrics();
            titleText_.filters = [new DropShadowFilter(0, 0, 0)];
            addChild(titleText_);
        }
        if (description != null) {
            descriptionText_ = new SimpleText(14, 0xB3B3B3, false, wrapWidth, 0, "Myriad Pro");
            descriptionText_.wordWrap = true;
            descriptionText_.y = titleText_ != null ? titleText_.height + 8 : 0;
            descriptionText_.text = description;
            descriptionText_._08S_();
            descriptionText_.filters = [new DropShadowFilter(0, 0, 0)];
            addChild(descriptionText_);
        }
    }

    public function setTitle(title:String):void {
        titleText_.text = title;
        titleText_.updateMetrics();
        draw();
    }

    /** Formerly _02C_ */
    public function setDescription(description:String):void {
        descriptionText_.text = description;
        descriptionText_._08S_();
        draw();
    }

}
}
