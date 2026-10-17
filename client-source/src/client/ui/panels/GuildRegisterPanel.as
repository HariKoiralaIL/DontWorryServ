package client.ui.panels {
import game.dialogs.Dialog;

import client.ui.frames.CreateGuildFrame;

import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.FrameHolder;
import com.company.assembleegameclient.ui._7f;
import com.company.assembleegameclient.ui._u5;
import com.company.assembleegameclient.util.Currency;
import com.company.assembleegameclient.util.GuildUtil;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

/** Shows the player's guild rank with a Renounce button, or a Create button when not in a guild. */
public class GuildRegisterPanel extends Panel {

    public function GuildRegisterPanel(gs:GameSprite) {
        super(gs);
        if (gs_.map_ == null || gs_.map_.player_ == null) {
            return;
        }
        var player:Player = gs_.map_.player_;
        var inGuild:Boolean = player.guildName_ != null && player.guildName_.length > 0;
        var title:SimpleText;
        if (inGuild) {
            title = PanelUtil.createLabel(GuildUtil.getRankName(player.guildRank_) + " of \n" + player.guildName_);
        } else {
            title = PanelUtil.createLabel("Create a Guild");
        }
        title.y = 0;
        addChild(title);
        if (inGuild) {
            var renounceButton:_7f = new _7f(16, "Renounce");
            renounceButton.addEventListener(MouseEvent.CLICK, this.onRenounceClick);
            renounceButton.x = (WIDTH / 2) - (renounceButton.width / 2);
            renounceButton.y = (HEIGHT - renounceButton.height) - 4;
            addChild(renounceButton);
        } else {
            var createButton:_u5 = new _u5("Create ", 16, Parameters._0H_m, Currency.FAME);
            createButton.addEventListener(MouseEvent.CLICK, this.onCreateClick);
            createButton.x = (WIDTH / 2) - (createButton.w_ / 2);
            createButton.y = (HEIGHT - (createButton.height / 2)) - 10;
            addChild(createButton);
        }
    }

    private function onRenounceClick(event:MouseEvent):void {
        if (gs_.map_ == null || gs_.map_.player_ == null) {
            return;
        }
        var player:Player = gs_.map_.player_;
        var dialog:Dialog = new Dialog("Are you sure you want to quit:\n" + player.guildName_,
                "Renounce Guild", "No, I'll stay", "Yes, I'll quit", "/renounceGuild");
        dialog.addEventListener(Dialog.BUTTON1_EVENT, this.onRenounceCancelled);
        dialog.addEventListener(Dialog.BUTTON2_EVENT, this.onRenounceConfirmed);
        stage.addChild(dialog);
    }

    private function onCreateClick(event:MouseEvent):void {
        var holder:Sprite = new FrameHolder(new CreateGuildFrame(gs_));
        stage.addChild(holder);
        visible = false;
    }

    private function onRenounceCancelled(event:Event):void {
        stage.removeChild(event.currentTarget as Dialog);
    }

    private function onRenounceConfirmed(event:Event):void {
        if (gs_.map_ == null || gs_.map_.player_ == null) {
            return;
        }
        var player:Player = gs_.map_.player_;
        gs_.gsc_.guildRemove(player.name_);
        stage.removeChild(event.currentTarget as Dialog);
        visible = false;
    }
}
}
