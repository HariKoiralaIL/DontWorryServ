package client.ui.panels {
import game.guild.GuildContainerUI;

import com.company.assembleegameclient.game.GameSprite;

import flash.events.MouseEvent;

public class GuildChroniclePanel extends ButtonPanel {

    public function GuildChroniclePanel(gs:GameSprite) {
        super(gs, "Guild Chronicle", "View");
    }

    override protected function onButtonClick(event:MouseEvent):void {
        gs_.mui_.clearInput();
        gs_.addChild(new GuildContainerUI(gs_));
    }
}
}
