package com.company.assembleegameclient.ui.tooltip {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.Inventory;
import com.company.assembleegameclient.ui._0G_h;
import com.company.assembleegameclient.ui._0M_Y_;
import com.company.assembleegameclient.ui._L_N_;
import com.company.assembleegameclient.ui.ui_playerslist;
import com.company.ui.SimpleText;

import flash.filters.DropShadowFilter;

public class PlayerToolTip extends ToolTip {

    private static const HP_COLOR:uint = 0xE03434;
    private static const MP_COLOR:uint = 0x6084E0;
    private static const BAR_BACKGROUND:uint = 0x2D2D2D;

    public var player_:Player;
    private var playerEntry_:ui_playerslist;
    private var starDisplay_:_0G_h;
    private var guildDisplay_:_L_N_;
    private var hpBar_:_0M_Y_;
    private var mpBar_:_0M_Y_;
    private var inventory_:Inventory;
    private var clickHint_:SimpleText;

    public function PlayerToolTip(player:Player) {
        super(0x2A2A2A, 0.5, 0xFFFFFF, 1);
        player_ = player;

        playerEntry_ = new ui_playerslist(0xB3B3B3, true, player_);
        addChild(playerEntry_);

        var nextY:int = 34;
        starDisplay_ = new _0G_h(player_.numStars_, false, true);
        starDisplay_.x = 6;
        starDisplay_.y = nextY;
        addChild(starDisplay_);
        nextY += 30;

        if (player.guildName_ != null && player.guildName_ != "") {
            guildDisplay_ = new _L_N_(player_.guildName_, player_.guildRank_, 136);
            guildDisplay_.x = 6;
            guildDisplay_.y = nextY - 2;
            addChild(guildDisplay_);
            nextY += 30;
        }

        hpBar_ = addBar(HP_COLOR, "HP", nextY);
        nextY += 24;
        mpBar_ = addBar(MP_COLOR, "MP", nextY);
        nextY += 24;

        inventory_ = new Inventory(null, player_, "Other Player Inventory", player_.slotTypes_, 4, false);
        inventory_.x = 8;
        inventory_.y = nextY;
        addChild(inventory_);
        nextY += 52;

        clickHint_ = new SimpleText(12, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        clickHint_.text = "(Click to open menu)";
        clickHint_.updateMetrics();
        clickHint_.filters = [new DropShadowFilter(0, 0, 0)];
        clickHint_.x = width / 2 - clickHint_.width / 2;
        clickHint_.y = nextY;
        addChild(clickHint_);
    }

    override public function draw():void {
        hpBar_.draw(player_.HP_, player_.maxHP_, player_._P_7, player_.maxHPMax_);
        mpBar_.draw(player_.MP_, player_.maxMP_, player_._0D_G_, player_.maxMPMax_);
        inventory_.draw(player_.equipment_);
        starDisplay_.draw(player_.numStars_);
        super.draw();
    }

    private function addBar(color:uint, label:String, barY:int):_0M_Y_ {
        var bar:_0M_Y_ = new _0M_Y_(176, 16, color, BAR_BACKGROUND, label);
        bar.x = 6;
        bar.y = barY;
        addChild(bar);
        return bar;
    }

}
}
