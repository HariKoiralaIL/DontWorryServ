package com.company.assembleegameclient.ui.tooltip {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.ui_playerslist;
import com.company.ui.SimpleText;

import flash.filters.DropShadowFilter;

public class PlayerListToolTip extends ToolTip {

    private static const ENTRY_HEIGHT:int = 32;

    public var players_:Vector.<Player> = null;   // formerly _nC_
    private var entries_:Vector.<ui_playerslist>;
    private var clickHint_:SimpleText;

    public function PlayerListToolTip(players:Vector.<Player>, followMouse:Boolean = true) {
        entries_ = new Vector.<ui_playerslist>();
        super(0x2A2A2A, 0.5, 0xFFFFFF, 1, followMouse);
        clickHint_ = new SimpleText(12, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        clickHint_.text = "(Click to open menu)";
        clickHint_.updateMetrics();
        clickHint_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(clickHint_);
        setPlayers(players);
        if (!followMouse) {
            filters = [];
        }
    }

    public function setPlayers(players:Vector.<Player>):void {
        clear();
        players_ = players == null ? new Vector.<Player>() : players.slice();
        if (players_.length == 0) {
            return;
        }
        var entryY:int = 0;
        for each (var player:Player in players) {
            var entry:ui_playerslist = new ui_playerslist(0xB3B3B3, true, player);
            entry.x = 0;
            entry.y = entryY;
            addChild(entry);
            entries_.push(entry);
            entryY += ENTRY_HEIGHT;
        }
        clickHint_.x = width / 2 - clickHint_.width / 2;
        clickHint_.y = entryY;
        draw();
    }

    private function clear():void {
        graphics.clear();
        for each (var entry:ui_playerslist in entries_) {
            removeChild(entry);
        }
        entries_.length = 0;
    }

}
}
