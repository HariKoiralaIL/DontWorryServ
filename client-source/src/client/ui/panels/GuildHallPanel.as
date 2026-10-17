package client.ui.panels {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.GuildHallPortal;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.RoundedButton;
import com.company.ui.SimpleText;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

/** Portal panel for the guild hall: only guild members get an Enter button. */
public class GuildHallPanel extends Panel {

    private var portal_:GuildHallPortal;

    public function GuildHallPanel(gs:GameSprite, portal:GuildHallPortal) {
        super(gs);
        this.portal_ = portal;
        if (gs_.map_ == null || gs_.map_.player_ == null) {
            return;
        }
        var player:Player = gs_.map_.player_;
        var nameText:SimpleText = PanelUtil.createLabel("Guild Hall");
        nameText.y = 6;
        addChild(nameText);
        if (player.guildName_ != null && player.guildName_.length > 0) {
            var enterButton:RoundedButton = new RoundedButton(16, "Enter");
            enterButton.addEventListener(MouseEvent.CLICK, this.onEnterClick);
            enterButton.x = (WIDTH / 2) - (enterButton.width / 2);
            enterButton.y = (HEIGHT - enterButton.height) - 4;
            addChild(enterButton);
            addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        } else {
            var notInGuildText:SimpleText = PanelUtil.createLabel("Not In Guild", 18, 0xFF0000, WIDTH, false);
            notInGuildText.y = (HEIGHT - notInGuildText.height) - 12;
            addChild(notInGuildText);
        }
    }

    private function enterPortal():void {
        gs_.gsc_.usePortal(this.portal_.objectId_);
    }

    private function onAddedToStage(event:Event):void {
        stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
    }

    private function onRemovedFromStage(event:Event):void {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
    }

    private function onEnterClick(event:MouseEvent):void {
        this.enterPortal();
    }

    private function onKeyDown(event:KeyboardEvent):void {
        if (PanelUtil.isInteractKey(event)) {
            this.enterPortal();
        }
    }
}
}
