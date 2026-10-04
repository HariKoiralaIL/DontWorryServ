// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.PlayerListToolTip

package com.company.assembleegameclient.ui.tooltip {

import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.ui_playerslist;
import com.company.ui.SimpleText;

import flash.filters.DropShadowFilter;


public class PlayerListToolTip extends ToolTip {

    public function PlayerListToolTip(_arg1:Vector.<Player>, _arg2:Boolean = true) {
        this.entries_ = new Vector.<ui_playerslist>();
        super(0x2A2A2A, 0.5, 0xFFFFFF, 1, _arg2);
        this.clickHint_ = new SimpleText(12, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        this.clickHint_.text = "(Click to open menu)";
        this.clickHint_.updateMetrics();
        this.clickHint_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.clickHint_);
        this.setPlayers(_arg1);
        if (!_arg2) {
            filters = [];
        }
    }
    public var _nC_:Vector.<Player> = null;
    private var entries_:Vector.<ui_playerslist>;
    private var clickHint_:SimpleText;

    public function setPlayers(_arg1:Vector.<Player>):void {
        var player:Player;
        var ui_playerslist2:ui_playerslist;
        this.clear();
        this._nC_ = _arg1.slice();
        if ((((this._nC_ == null)) || ((this._nC_.length == 0)))) {
            return;
        }
        var _local2:int;
        for each (player in _arg1) {
            ui_playerslist2 = new ui_playerslist(0xB3B3B3, true, player);
            ui_playerslist2.x = 0;
            ui_playerslist2.y = _local2;
            addChild(ui_playerslist2);
            this.entries_.push(ui_playerslist2);
            _local2 = (_local2 + 32);
        }
        this.clickHint_.x = ((width / 2) - (this.clickHint_.width / 2));
        this.clickHint_.y = _local2;
        draw();
    }

    private function clear():void {
        var ui_playerslist2:ui_playerslist;
        graphics.clear();
        for each (ui_playerslist2 in this.entries_) {
            removeChild(ui_playerslist2);
        }
        this.entries_.length = 0;
    }

}
}//package com.company.assembleegameclient.ui.tooltip

