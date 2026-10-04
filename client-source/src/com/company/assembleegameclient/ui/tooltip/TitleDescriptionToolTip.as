// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.TitleDescriptionToolTip

package com.company.assembleegameclient.ui.tooltip {
import com.company.ui.SimpleText;

import flash.filters.DropShadowFilter;

public class TitleDescriptionToolTip extends ToolTip {

    public function TitleDescriptionToolTip(_arg1:uint, _arg2:uint, _arg3:String, _arg4:String, _arg5:int) {
        super(_arg1, 1, _arg2, 1);
        if (_arg3 != null) {
            this._P_V_ = new SimpleText(20, 0xFFFFFF, false, _arg5, 0, "Myriad Pro");
            this._P_V_.setBold(true);
            this._P_V_.wordWrap = true;
            this._P_V_.text = _arg3;
            this._P_V_.updateMetrics();
            this._P_V_.filters = [new DropShadowFilter(0, 0, 0)];
            addChild(this._P_V_);
        }
        if (_arg4 != null) {
            this.descriptionText_ = new SimpleText(14, 0xB3B3B3, false, _arg5, 0, "Myriad Pro");
            this.descriptionText_.wordWrap = true;
            this.descriptionText_.y = (((this._P_V_) != null) ? (this._P_V_.height + 8) : 0);
            this.descriptionText_.text = _arg4;
            this.descriptionText_._08S_();
            this.descriptionText_.filters = [new DropShadowFilter(0, 0, 0)];
            addChild(this.descriptionText_);
        }
    }
    public var _P_V_:SimpleText;
    public var descriptionText_:SimpleText;

    public function setTitle(_arg1:String):void {
        this._P_V_.text = _arg1;
        this._P_V_.updateMetrics();
        draw();
    }

    public function _02C_(_arg1:String):void {
        this.descriptionText_.text = _arg1;
        this.descriptionText_._08S_();
        draw();
    }

}
}//package com.company.assembleegameclient.ui.tooltip

