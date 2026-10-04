// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.RankToolTip

package com.company.assembleegameclient.ui.tooltip {
import com.company.ui.SimpleText;
import com.company.rotmg.graphics.StarGraphic;
import com.company.assembleegameclient.ui._return;

import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

import com.company.assembleegameclient.util._Z_B_;
import com.company.assembleegameclient.objects.ObjectLibrary;

public class RankToolTip extends ToolTip {

    public function RankToolTip(_arg1:int) {
        var legendLine:LegendLine;
        super(0x2A2A2A, 1, 0xFFFFFF, 1);
        this.titleText_ = new SimpleText(13, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        this.titleText_.setBold(true);
        this.titleText_.text = ("You have earned " + _arg1);
        this.titleText_.updateMetrics();
        this.titleText_.filters = [new DropShadowFilter(0, 0, 0)];
        this.titleText_.x = 6;
        this.titleText_.y = 2;
        addChild(this.titleText_);
        this.star_ = new StarGraphic();
        this.star_.transform.colorTransform = new ColorTransform((179 / 0xFF), (179 / 0xFF), (179 / 0xFF));
        this.star_.x = (this.titleText_.width + 7);
        this.star_.y = (this.titleText_.y + 3);
        addChild(this.star_);
        this.descriptionText_ = new SimpleText(13, 0xB3B3B3, false, 174, 0, "Myriad Pro");
        this.descriptionText_.wordWrap = true;
        this.descriptionText_.multiline = true;
        this.descriptionText_.text = "You can earn more by completing Class Quests.";
        this.descriptionText_.updateMetrics();
        this.descriptionText_.filters = [new DropShadowFilter(0, 0, 0)];
        this.descriptionText_.x = 6;
        this.descriptionText_.y = 30;
        addChild(this.descriptionText_);
        this.divider_ = new _return(100, 0x2D2D2D);
        this.divider_.x = 6;
        this.divider_.y = (height + 10);
        addChild(this.divider_);
        var _local3:int = (this.divider_.y + 3);
        var _local4:int;
        while (_local4 < _Z_B_._n0.length) {
            legendLine = new LegendLine((_local4 * ObjectLibrary._tj.length), (((_local4 + 1) * ObjectLibrary._tj.length) - 1), _Z_B_._n0[_local4]);
            legendLine.x = 6;
            legendLine.y = _local3;
            addChild(legendLine);
            _local3 = (_local3 + legendLine.height);
            _local4++;
        }
        legendLine = new LegendLine(_Z_B_._5e(), _Z_B_._5e(), new ColorTransform((0xFF / 0xFF), (0 / 0xFF), (0xFF / 0xFF)));
        legendLine.x = 6;
        legendLine.y = _local3;
        addChild(legendLine);
        height = (height + 6);
    }
    private var titleText_:SimpleText;
    private var star_:StarGraphic;
    private var descriptionText_:SimpleText;
    private var divider_:_return;
    private var legendLines_:Vector.<LegendLine>;

    override public function draw():void {
        this.divider_._rs((width - 10), 0x2D2D2D);
        super.draw();
    }

}
}//package com.company.assembleegameclient.ui.tooltip

import flash.display.Sprite;

import com.company.rotmg.graphics.StarGraphic;
import com.company.ui.SimpleText;

import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

class LegendLine extends Sprite {

    /*private*/
    internal var coloredStar_:StarGraphic;
    /*private*/
    internal var rangeText_:SimpleText;
    /*private*/
    internal var star_:StarGraphic;

    public function LegendLine(_arg1:int, _arg2:int, colorTransform2:ColorTransform) {
        this.coloredStar_ = new StarGraphic();
        this.coloredStar_.transform.colorTransform = colorTransform2;
        this.coloredStar_.y = 4;
        addChild(this.coloredStar_);
        this.rangeText_ = new SimpleText(13, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        this.rangeText_.setBold(true);
        this.rangeText_.text = (": " + (((_arg1 == _arg2)) ? _arg1.toString() : ((_arg1 + " - ") + _arg2)));
        this.rangeText_.updateMetrics();
        this.rangeText_.filters = [new DropShadowFilter(0, 0, 0)];
        this.rangeText_.x = this.coloredStar_.width;
        addChild(this.rangeText_);
        this.star_ = new StarGraphic();
        this.star_.transform.colorTransform = new ColorTransform((179 / 0xFF), (179 / 0xFF), (179 / 0xFF));
        this.star_.x = ((this.rangeText_.x + this.rangeText_.width) + 2);
        this.star_.y = 4;
        addChild(this.star_);
    }
}

