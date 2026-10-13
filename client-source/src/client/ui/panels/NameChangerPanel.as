package client.ui.panels {
import game.dialogs.NotRegisteredDialog;

import account.Account;

import client.ui.frames.ChangeNameFrame;

import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.FrameHolder;
import com.company.assembleegameclient.ui._7f;
import com.company.assembleegameclient.ui._u5;
import com.company.assembleegameclient.util.Currency;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.MouseEvent;

/** Lets the player choose (or change) their account name. */
public class NameChangerPanel extends Panel {

    private var hasChosenName:Boolean;

    public function NameChangerPanel(gs:GameSprite, requiredStars:int) {
        super(gs);
        if (gs_.map_ == null || gs_.map_.player_ == null) {
            return;
        }
        var player:Player = gs_.map_.player_;
        this.hasChosenName = player.nameChosen_;
        var title:SimpleText;
        if (this.hasChosenName) {
            title = PanelUtil.createLabel("Your name is: \n" + gs_.charList_.name_);
            title.y = 0;
            addChild(title);
            var changeButton:_u5 = new _u5("Change ", 16, Parameters._0u, Currency._class);
            changeButton.addEventListener(MouseEvent.CLICK, this.onButtonClick);
            changeButton.x = (WIDTH / 2) - (changeButton.w_ / 2);
            changeButton.y = (HEIGHT - (changeButton.height / 2)) - 10;
            addChild(changeButton);
        } else if (player.numStars_ < requiredStars) {
            title = PanelUtil.createLabel("Choose Account Name");
            addChild(title);
            var rankLabel:Sprite = PanelUtil.createRankRequiredLabel(requiredStars);
            rankLabel.x = (WIDTH / 2) - (rankLabel.width / 2);
            rankLabel.y = (HEIGHT - (rankLabel.height / 2)) - 20;
            addChild(rankLabel);
        } else {
            title = PanelUtil.createLabel("Choose Account Name");
            title.y = 6;
            addChild(title);
            var chooseButton:_7f = new _7f(16, "Choose");
            chooseButton.addEventListener(MouseEvent.CLICK, this.onButtonClick);
            chooseButton.x = (WIDTH / 2) - (chooseButton.width / 2);
            chooseButton.y = (HEIGHT - chooseButton.height) - 4;
            addChild(chooseButton);
        }
    }

    private function onButtonClick(event:MouseEvent):void {
        var dialog:Sprite;
        if (Account.getInstance().isRegistered()) {
            dialog = new FrameHolder(new ChangeNameFrame(gs_, this.hasChosenName));
            visible = false;
        } else {
            dialog = new NotRegisteredDialog("In order to choose an account name, you must be registered");
        }
        stage.addChild(dialog);
    }
}
}
