package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.util.FameUtil;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.filters.DropShadowFilter;

/**
 * Optional "Rank: " label followed by the star count and star icon.
 *
 * Formerly: _0G_h
 */
public class RankDisplay extends Sprite {

    public var starsHolder_:Sprite = null;
    public var big_:Boolean;

    private var numStars_:int = -1;
    private var label_:SimpleText = null;

    public function RankDisplay(numStars:int, big:Boolean, showLabel:Boolean) {
        super();
        this.big_ = big;
        if (showLabel) {
            this.label_ = new SimpleText(this.big_ ? 18 : 16, 0xB3B3B3, false, 0, 0, "Myriad Pro");
            this.label_.setBold(this.big_);
            this.label_.text = "Rank: ";
            this.label_.updateMetrics();
            this.label_.filters = [new DropShadowFilter(0, 0, 0)];
            addChild(this.label_);
        }
        mouseEnabled = false;
        mouseChildren = false;
        this.draw(numStars);
    }

    public function draw(numStars:int):void {
        if (numStars == this.numStars_) {
            return;
        }
        this.numStars_ = numStars;
        if (this.starsHolder_ != null && contains(this.starsHolder_)) {
            removeChild(this.starsHolder_);
        }
        if (this.numStars_ < 0) {
            return;
        }
        this.starsHolder_ = new Sprite();
        var countText:SimpleText = new SimpleText(this.big_ ? 18 : 16, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        countText.setBold(this.big_);
        countText.text = this.numStars_.toString();
        countText.updateMetrics();
        countText.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        this.starsHolder_.addChild(countText);
        var starIcon:Sprite = this.big_ ? FameUtil.numStarsToBigImage(this.numStars_) : FameUtil.numStarsToImage(this.numStars_);
        starIcon.x = countText.width + 2;
        this.starsHolder_.addChild(starIcon);
        starIcon.y = int((countText.height / 2) - (starIcon.height / 2)) + 1;
        var right:int = starIcon.x + starIcon.width;
        this.starsHolder_.graphics.clear();
        this.starsHolder_.graphics.beginFill(0, 0.4);
        this.starsHolder_.graphics.drawRoundRect(-2, starIcon.y - 3, right + 6, starIcon.height + 8, 12, 12);
        this.starsHolder_.graphics.endFill();
        addChild(this.starsHolder_);
        if (this.label_ != null) {
            addChild(this.label_);
            this.starsHolder_.x = this.label_.width;
        }
    }
}
}
