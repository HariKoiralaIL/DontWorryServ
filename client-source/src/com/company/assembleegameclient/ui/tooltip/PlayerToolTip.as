// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.PlayerToolTip

package com.company.assembleegameclient.ui.tooltip {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.ui_playerslist;
import com.company.assembleegameclient.ui._0G_h;
import com.company.assembleegameclient.ui._L_N_;
import com.company.assembleegameclient.ui._0M_Y_;
import com.company.assembleegameclient.ui.Inventory;
import com.company.ui.SimpleText;

import flash.filters.DropShadowFilter;

public class PlayerToolTip extends ToolTip {

    public function PlayerToolTip(_arg1:Player) {
        var _local2:int;
        super(0x2A2A2A, 0.5, 0xFFFFFF, 1);
        this.player_ = _arg1;
        this.playerEntry_ = new ui_playerslist(0xB3B3B3, true, this.player_);
        addChild(this.playerEntry_);
        _local2 = 34;
        this.starDisplay_ = new _0G_h(this.player_.numStars_, false, true);
        this.starDisplay_.x = 6;
        this.starDisplay_.y = _local2;
        addChild(this.starDisplay_);
        _local2 = (_local2 + 30);
        if (((!((_arg1.guildName_ == null))) && (!((_arg1.guildName_ == ""))))) {
            this.guildDisplay_ = new _L_N_(this.player_.guildName_, this.player_.guildRank_, 136);
            this.guildDisplay_.x = 6;
            this.guildDisplay_.y = (_local2 - 2);
            addChild(this.guildDisplay_);
            _local2 = (_local2 + 30);
        }
        this.hpBar_ = new _0M_Y_(176, 16, 14693428, 0x2D2D2D, "HP");
        this.hpBar_.x = 6;
        this.hpBar_.y = _local2;
        addChild(this.hpBar_);
        _local2 = (_local2 + 24);
        this.mpBar_ = new _0M_Y_(176, 16, 6325472, 0x2D2D2D, "MP");
        this.mpBar_.x = 6;
        this.mpBar_.y = _local2;
        addChild(this.mpBar_);
        _local2 = (_local2 + 24);
        this.inventory_ = new Inventory(null, this.player_, "Other Player Inventory", this.player_._9A_, 4, false);
        this.inventory_.x = 8;
        this.inventory_.y = _local2;
        addChild(this.inventory_);
        _local2 = (_local2 + 52);
        this.clickHint_ = new SimpleText(12, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        this.clickHint_.text = "(Click to open menu)";
        this.clickHint_.updateMetrics();
        this.clickHint_.filters = [new DropShadowFilter(0, 0, 0)];
        this.clickHint_.x = ((width / 2) - (this.clickHint_.width / 2));
        this.clickHint_.y = _local2;
        addChild(this.clickHint_);
    }
    public var player_:Player;
    private var playerEntry_:ui_playerslist;
    private var starDisplay_:_0G_h;
    private var guildDisplay_:_L_N_;
    private var hpBar_:_0M_Y_;
    private var mpBar_:_0M_Y_;
    private var inventory_:Inventory;
    private var clickHint_:SimpleText;

    override public function draw():void {
        this.hpBar_.draw(this.player_.HP_, this.player_.maxHP_, this.player_._P_7, this.player_._uR_);
        this.mpBar_.draw(this.player_.MP_, this.player_.maxMP_, this.player_._0D_G_, this.player_._dt);
        this.inventory_.draw(this.player_.equipment_);
        this.starDisplay_.draw(this.player_.numStars_);
        super.draw();
    }

}
}//package com.company.assembleegameclient.ui.tooltip

