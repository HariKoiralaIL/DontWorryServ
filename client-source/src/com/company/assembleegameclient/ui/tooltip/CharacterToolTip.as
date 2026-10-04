// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.CharacterToolTip

package com.company.assembleegameclient.ui.tooltip {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.ui_playerslist;
import com.company.assembleegameclient.ui._0M_Y_;
import com.company.assembleegameclient.ui.Inventory;
import com.company.assembleegameclient.ui._return;
import com.company.ui.SimpleText;
import com.company.assembleegameclient.objects.ObjectLibrary;

import flash.filters.DropShadowFilter;

import com.company.assembleegameclient.util._Z_B_;
import com.company.assembleegameclient.appengine._0A_H_;

public class CharacterToolTip extends ToolTip {

    public function CharacterToolTip(_arg1:String, xml:XML, _0a_h_:_0A_H_) {
        super(0x2A2A2A, 1, 0xFFFFFF, 1);
        var _local4:int = int(xml.ObjectType);
        var xml2:XML = ObjectLibrary._Q_F_[_local4];
        this.player_ = Player._D_U_(_arg1, xml);
        this.playerEntry_ = new ui_playerslist(0xB3B3B3, true, this.player_);
        addChild(this.playerEntry_);
        this.hpBar_ = new _0M_Y_(176, 16, 14693428, 0x2D2D2D, "HP");
        this.hpBar_.x = 6;
        this.hpBar_.y = 40;
        addChild(this.hpBar_);
        this.mpBar_ = new _0M_Y_(176, 16, 6325472, 0x2D2D2D, "MP");
        this.mpBar_.x = 6;
        this.mpBar_.y = 64;
        addChild(this.mpBar_);
        this.inventory_ = new Inventory(null, this.player_, "Player Inventory", this.player_._9A_, 12, false);
        this.inventory_.x = 8;
        this.inventory_.y = 88;
        addChild(this.inventory_);
        this.divider_ = new _return(90, 0x2D2D2D);
        this.divider_.x = 6;
        this.divider_.y = 228;
        addChild(this.divider_);
        var _local6:int = (((_0a_h_ == null)) ? 0 : _0a_h_._lr());
        this.statsText_ = new SimpleText(12, 6206769, false, 0, 0, "CHIP SB");
        this.statsText_.text = ((((((_local6 + " of " + _Z_B_._yJ_.length + " C-Quests Completed\n") + "Best Level Achieved: ") + (((_0a_h_) != null) ? _0a_h_.bestLevel() : 0)) + "\n") + "Best Fame Achieved: ") + (((_0a_h_) != null) ? _0a_h_._0D_E_() : 0));
        this.statsText_.updateMetrics();
        this.statsText_.filters = [new DropShadowFilter(0, 0, 0)];
        this.statsText_.x = 8;
        this.statsText_.y = (height - 2);
        addChild(this.statsText_);
        var _local7:int = _Z_B_._F_U_((((_0a_h_ == null)) ? 0 : _0a_h_._0D_E_()), 0);
        if (_local7 > 0) {
            this.nextGoalText_ = new SimpleText(10, 16549442, false, 174, 0, "CHIP SB");
            this.nextGoalText_.text = (((("Next Goal: Earn " + _local7) + " Fame\n") + "  with a ") + xml2.@id);
            this.nextGoalText_.updateMetrics();
            this.nextGoalText_.filters = [new DropShadowFilter(0, 0, 0)];
            this.nextGoalText_.x = 8;
            this.nextGoalText_.y = (height - 2);
            addChild(this.nextGoalText_);
        }
    }
    public var player_:Player;
    private var playerEntry_:ui_playerslist;
    private var hpBar_:_0M_Y_;
    private var mpBar_:_0M_Y_;
    private var inventory_:Inventory;
    private var divider_:_return;
    private var statsText_:SimpleText;
    private var nextGoalText_:SimpleText;

    override public function draw():void {
        this.hpBar_.draw(this.player_.HP_, this.player_.maxHP_, this.player_._P_7, this.player_._uR_);
        this.mpBar_.draw(this.player_.MP_, this.player_.maxMP_, this.player_._0D_G_, this.player_._dt);
        this.inventory_.draw(this.player_.equipment_);
        this.divider_._rs((width - 10), 0x2D2D2D);
        super.draw();
    }

}
}//package com.company.assembleegameclient.ui.tooltip

