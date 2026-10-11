package client.ui.panels {
import client.ui.guild.GuildBoardOverlay;

import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.util._07E_;

import flash.events.MouseEvent;

public class GuildBoardPanel extends ButtonPanel {

    public function GuildBoardPanel(gs:GameSprite) {
        super(gs, "Guild Board", "View");
    }

    override protected function onButtonClick(event:MouseEvent):void {
        var player:Player = gs_.map_.player_;
        if (player == null) {
            return;
        }
        gs_.addChild(new GuildBoardOverlay(player.guildRank_ >= _07E_._f3));
    }
}
}
