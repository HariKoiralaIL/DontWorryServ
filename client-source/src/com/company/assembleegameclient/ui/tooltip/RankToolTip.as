package com.company.assembleegameclient.ui.tooltip {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.ui._return;
import com.company.assembleegameclient.util.FameUtil;
import com.company.rotmg.graphics.StarGraphic;
import com.company.ui.SimpleText;

import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

public class RankToolTip extends ToolTip {

    private static const DIVIDER_COLOR:uint = 0x2D2D2D;

    private var titleText_:SimpleText;
    private var star_:StarGraphic;
    private var descriptionText_:SimpleText;
    private var divider_:_return;

    public function RankToolTip(rank:int) {
        super(0x2A2A2A, 1, 0xFFFFFF, 1);
        titleText_ = new SimpleText(13, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        titleText_.setBold(true);
        titleText_.text = "You have earned " + rank;
        titleText_.updateMetrics();
        titleText_.filters = [new DropShadowFilter(0, 0, 0)];
        titleText_.x = 6;
        titleText_.y = 2;
        addChild(titleText_);

        star_ = new StarGraphic();
        star_.transform.colorTransform = new ColorTransform(179 / 0xFF, 179 / 0xFF, 179 / 0xFF);
        star_.x = titleText_.width + 7;
        star_.y = titleText_.y + 3;
        addChild(star_);

        descriptionText_ = new SimpleText(13, 0xB3B3B3, false, 174, 0, "Myriad Pro");
        descriptionText_.wordWrap = true;
        descriptionText_.multiline = true;
        descriptionText_.text = "You can earn more by completing Class Quests.";
        descriptionText_.updateMetrics();
        descriptionText_.filters = [new DropShadowFilter(0, 0, 0)];
        descriptionText_.x = 6;
        descriptionText_.y = 30;
        addChild(descriptionText_);

        divider_ = new _return(100, DIVIDER_COLOR);
        divider_.x = 6;
        divider_.y = height + 10;
        addChild(divider_);

        var lineY:int = divider_.y + 3;
        var charCount:int = ObjectLibrary.playerChars_.length;
        for (var i:int = 0; i < FameUtil.STAR_COLORS.length; i++) {
            lineY += addLegendLine(i * charCount, (i + 1) * charCount - 1, FameUtil.STAR_COLORS[i], lineY);
        }
        addLegendLine(FameUtil.maxStars(), FameUtil.maxStars(), new ColorTransform(1, 0, 1), lineY);
        height = height + 6;
    }

    override public function draw():void {
        divider_._rs(width - 10, DIVIDER_COLOR);
        super.draw();
    }

    /** Adds a legend line at lineY and returns its height. */
    private function addLegendLine(minStars:int, maxStars:int, color:ColorTransform, lineY:int):int {
        var line:LegendLine = new LegendLine(minStars, maxStars, color);
        line.x = 6;
        line.y = lineY;
        addChild(line);
        return line.height;
    }

}
}

import com.company.rotmg.graphics.StarGraphic;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

class LegendLine extends Sprite {

    internal var coloredStar_:StarGraphic;
    internal var rangeText_:SimpleText;
    internal var star_:StarGraphic;

    public function LegendLine(minStars:int, maxStars:int, color:ColorTransform) {
        coloredStar_ = new StarGraphic();
        coloredStar_.transform.colorTransform = color;
        coloredStar_.y = 4;
        addChild(coloredStar_);

        rangeText_ = new SimpleText(13, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        rangeText_.setBold(true);
        rangeText_.text = ": " + (minStars == maxStars ? minStars.toString() : minStars + " - " + maxStars);
        rangeText_.updateMetrics();
        rangeText_.filters = [new DropShadowFilter(0, 0, 0)];
        rangeText_.x = coloredStar_.width;
        addChild(rangeText_);

        star_ = new StarGraphic();
        star_.transform.colorTransform = new ColorTransform(179 / 0xFF, 179 / 0xFF, 179 / 0xFF);
        star_.x = rangeText_.x + rangeText_.width + 2;
        star_.y = 4;
        addChild(star_);
    }

}
