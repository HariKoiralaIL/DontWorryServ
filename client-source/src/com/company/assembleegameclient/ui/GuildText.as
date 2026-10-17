package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.util.GuildUtil;
import com.company.ui.SimpleText;
import com.company.util.DisplayUtil;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;

/**
 * Guild rank icon followed by the guild name.
 *
 * Formerly: _L_N_
 */
public class GuildText extends Sprite {

    private static const RANK_ICON_SIZE:int = 10;

    private var name_:String;
    private var rank_:int;
    private var rankIcon_:Bitmap;
    private var guildName_:SimpleText;

    public function GuildText(guildName:String, rank:int, width:int = 0) {
        super();
        this.rankIcon_ = new Bitmap(null);
        this.rankIcon_.y = -8;
        this.rankIcon_.x = -8;
        var nameWidth:int = (width == 0) ? 0 : (width - (this.rankIcon_.width - 16));
        this.guildName_ = new SimpleText(16, 0xFFFFFF, false, nameWidth, 0, "Myriad Pro");
        this.guildName_.filters = [new DropShadowFilter(0, 0, 0)];
        this.guildName_.x = 24;
        this.draw(guildName, rank);
    }

    public function draw(guildName:String, rank:int):void {
        // The original compared the rank argument with itself (always true);
        // comparing against the stored rank is what was intended.
        if (this.name_ == guildName && this.rank_ == rank) {
            return;
        }
        this.name_ = guildName;
        this.rank_ = rank;
        if (this.name_ == null || this.name_ == "") {
            DisplayUtil.safeRemoveChild(this, this.rankIcon_);
            DisplayUtil.safeRemoveChild(this, this.guildName_);
        } else {
            this.rankIcon_.bitmapData = GuildUtil.getRankIcon(this.rank_, RANK_ICON_SIZE);
            DisplayUtil.safeAddChild(this, this.rankIcon_);
            this.guildName_.text = this.name_;
            this.guildName_._08S_();
            DisplayUtil.safeAddChild(this, this.guildName_);
        }
    }
}
}
