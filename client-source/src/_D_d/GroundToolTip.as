// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_D_d.GroundToolTip

package _D_d {
import com.company.assembleegameclient.ui.tooltip.ToolTip;

import com.company.ui.SimpleText;

import flash.filters.DropShadowFilter;

public class GroundToolTip extends ToolTip {

    private static const TOOLTIP_WIDTH:int = 180;

    public function GroundToolTip(groundXml:XML) {
        super(0x2A2A2A, 1, 0x9B9B9B, 1, true);
        this.nameText_ = new SimpleText(16, 0xFFFFFF, false, (TOOLTIP_WIDTH - 4), 0, "Myriad Pro");
        this.nameText_.setBold(true);
        this.nameText_.wordWrap = true;
        this.nameText_.text = String(groundXml.@id);
        this.nameText_._08S_();
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        this.nameText_.x = 0;
        this.nameText_.y = 0;
        addChild(this.nameText_);
        var description = "";
        if (groundXml.hasOwnProperty("Speed")) {
            description = (description + (("Speed: " + Number(groundXml.Speed).toFixed(2)) + "\n"));
        } else {
            description = (description + "Speed: 1.00\n");
        }
        if (groundXml.hasOwnProperty("NoWalk")) {
            description = (description + "Unwalkable\n");
        }
        if (groundXml.hasOwnProperty("Push")) {
            description = (description + "Push\n");
        }
        if (groundXml.hasOwnProperty("Sink")) {
            description = (description + "Sink\n");
        }
        if (groundXml.hasOwnProperty("Sinking")) {
            description = (description + "Sinking\n");
        }
        if (groundXml.hasOwnProperty("Animate")) {
            description = (description + "Animated\n");
        }
        if (groundXml.hasOwnProperty("RandomOffset")) {
            description = (description + "Randomized\n");
        }
        this.descriptionText_ = new SimpleText(14, 0xB3B3B3, false, TOOLTIP_WIDTH, 0, "Myriad Pro");
        this.descriptionText_.wordWrap = true;
        this.descriptionText_.text = String(description);
        this.descriptionText_._08S_();
        this.descriptionText_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        this.descriptionText_.x = 0;
        this.descriptionText_.y = (this.nameText_.height + 2);
        addChild(this.descriptionText_);
    }
    private var nameText_:SimpleText;
    private var descriptionText_:SimpleText;
}
}//package _D_d

