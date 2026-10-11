// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.ui.tooltips.ToolTipView

package client.ui.tooltips {
import flash.display.Sprite;

import com.company.assembleegameclient.ui.tooltip.ToolTip;

public class ToolTipView extends Sprite {

    private var currentToolTip:ToolTip;

    public function show(_arg1:ToolTip):void {
        this.hide();
        this.currentToolTip = _arg1;
        if (_arg1) {
            addChild(_arg1);
        }
    }

    public function hide():void {
        if (((this.currentToolTip) && (this.currentToolTip.parent))) {
            this.currentToolTip.parent.removeChild(this.currentToolTip);
        }
        this.currentToolTip = null;
    }

}
}//package client.ui.tooltips

