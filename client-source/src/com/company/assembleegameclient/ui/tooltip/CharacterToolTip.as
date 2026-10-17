package com.company.assembleegameclient.ui.tooltip {
import com.company.assembleegameclient.appengine.ClassStats;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.Inventory;
import com.company.assembleegameclient.ui._0M_Y_;
import com.company.assembleegameclient.ui._return;
import com.company.assembleegameclient.ui.ui_playerslist;
import com.company.ui.SimpleText;

import flash.filters.DropShadowFilter;

public class CharacterToolTip extends ToolTip {

    private static const HP_COLOR:uint = 0xE03434;
    private static const MP_COLOR:uint = 0x6084E0;
    private static const BAR_BACKGROUND:uint = 0x2D2D2D;
    private static const DIVIDER_COLOR:uint = 0x2D2D2D;

    public var player_:Player;
    private var playerEntry_:ui_playerslist;
    private var hpBar_:_0M_Y_;
    private var mpBar_:_0M_Y_;
    private var inventory_:Inventory;
    private var divider_:_return;
    private var statsText_:SimpleText;
    private var nextGoalText_:SimpleText;

    public function CharacterToolTip(charName:String, charXML:XML, classStats:ClassStats) {
        super(0x2A2A2A, 1, 0xFFFFFF, 1);
        var classXML:XML = ObjectLibrary.typeToXML_[int(charXML.ObjectType)];
        player_ = Player.fromCharXML(charName, charXML);

        playerEntry_ = new ui_playerslist(0xB3B3B3, true, player_);
        addChild(playerEntry_);

        hpBar_ = addBar(HP_COLOR, "HP", 40);
        mpBar_ = addBar(MP_COLOR, "MP", 64);

        inventory_ = new Inventory(null, player_, "Player Inventory", player_.slotTypes_, 12, false);
        inventory_.x = 8;
        inventory_.y = 88;
        addChild(inventory_);

        divider_ = new _return(90, DIVIDER_COLOR);
        divider_.x = 6;
        divider_.y = 228;
        addChild(divider_);

        statsText_ = new SimpleText(12, 0x5EB531, false, 0, 0, "CHIP SB");
        statsText_.text = ClassStatsText.summary(classStats);
        statsText_.updateMetrics();
        statsText_.filters = [new DropShadowFilter(0, 0, 0)];
        statsText_.x = 8;
        statsText_.y = height - 2;
        addChild(statsText_);

        var goal:String = ClassStatsText.nextGoal(classStats, String(classXML.@id));
        if (goal != null) {
            nextGoalText_ = new SimpleText(10, 0xFC8642, false, 174, 0, "CHIP SB");
            nextGoalText_.text = goal;
            nextGoalText_.updateMetrics();
            nextGoalText_.filters = [new DropShadowFilter(0, 0, 0)];
            nextGoalText_.x = 8;
            nextGoalText_.y = height - 2;
            addChild(nextGoalText_);
        }
    }

    override public function draw():void {
        hpBar_.draw(player_.HP_, player_.maxHP_, player_._P_7, player_.maxHPMax_);
        mpBar_.draw(player_.MP_, player_.maxMP_, player_._0D_G_, player_.maxMPMax_);
        inventory_.draw(player_.equipment_);
        divider_._rs(width - 10, DIVIDER_COLOR);
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
