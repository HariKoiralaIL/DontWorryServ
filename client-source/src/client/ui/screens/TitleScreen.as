package client.ui.screens {
import account.Account;

import com.company.assembleegameclient.appengine.CharListEvent;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.backgrounds.TitleBackground;
import com.company.ui.SimpleText;

import constants.Buttons;

import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import signals.Signal;

/** Main title screen: play/servers/credits/account/legends/editor/forums buttons. */
public class TitleScreen extends BaseScreen {

    private static const MENU_X:int = 10;

    /** Dispatches the clicked button's name (see constants.Buttons). */
    public var buttonClicked:Signal;

    private var playButton:MenuButton;
    private var serversButton:MenuButton;
    private var creditsButton:MenuButton;
    private var accountButton:MenuButton;
    private var legendsButton:MenuButton;
    private var editorButton:MenuButton;
    private var spriteButton:MenuButton;
    private var forumsButton:MenuButton;
    private var versionText:SimpleText;
    private var copyrightText:SimpleText;
    private var model:CharListEvent;

    public function TitleScreen() {
        addChild(new TitleBackground());
        super(TitleScreen);
        this.buttonClicked = new Signal(String);
    }

    override public function initialize(model:CharListEvent):void {
        super.initialize(model);
        this.model = model;
        this.buildButtons();
        this.buildFooter();
        this.layout();
    }

    private function buildButtons():void {
        this.playButton = new MenuButton(Buttons.PLAY, 36, true);
        if (this.model.servers_.length > 0 || Account.getInstance().isRegistered()) {
            this.playButton.addEventListener(MouseEvent.CLICK, this.onButtonClick);
        } else {
            this.playButton.addEventListener(MouseEvent.CLICK, this.onPlayWhenUnregistered);
        }
        addChild(this.playButton);
        this.serversButton = this.addMenuButton(Buttons.SERVERS);
        this.creditsButton = this.addMenuButton(Buttons.CREDITS);
        this.accountButton = this.addMenuButton(Buttons.ACCOUNT);
        this.legendsButton = this.addMenuButton(Buttons.LEGENDS);
        this.editorButton = this.addMenuButton(Buttons.EDITOR);
        this.editorButton.visible = Player._e_D;
        // Created but intentionally not added to the display list (as before).
        this.spriteButton = new MenuButton(Buttons.SPRITE, 22, false);
        this.spriteButton.addEventListener(MouseEvent.CLICK, this.onButtonClick);
        this.spriteButton.visible = Player._e_D;
        this.forumsButton = this.addMenuButton(Buttons.FORUMS);
    }

    private function addMenuButton(label:String):MenuButton {
        var button:MenuButton = new MenuButton(label, 22, false);
        button.addEventListener(MouseEvent.CLICK, this.onButtonClick);
        addChild(button);
        return button;
    }

    private function buildFooter():void {
        var prefix:String;
        if (Parameters.isTesting) {
            prefix = (Parameters.isTestingDomain() ? "Project B " : "");
        } else {
            prefix = '<font color="#FF1493">DEVELOPMENT</font> ';
        }
        this.versionText = new SimpleText(12, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.versionText.htmlText = prefix + "v." + Parameters.clientVersion;
        this.versionText.updateMetrics();
        this.versionText.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.versionText);
        this.copyrightText = new SimpleText(12, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.copyrightText.text = "\u00A9 2015 by Bledixon.";
        this.copyrightText.updateMetrics();
        this.copyrightText.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.copyrightText);
    }

    private function layout():void {
        this.playButton.x = MENU_X;
        this.playButton.y = ((600 / 2) - (this.playButton.width / 2));
        this.serversButton.x = MENU_X;
        this.serversButton.y = (360 - (this.serversButton.width / 2));
        this.creditsButton.x = MENU_X;
        this.creditsButton.y = 360;
        this.accountButton.x = MENU_X;
        this.accountButton.y = (270 - (this.accountButton.width / 2));
        this.legendsButton.x = MENU_X;
        this.legendsButton.y = 395;
        this.editorButton.x = MENU_X;
        this.editorButton.y = 195;
        this.spriteButton.x = MENU_X;
        this.spriteButton.y = 100;
        this.forumsButton.x = MENU_X;
        this.forumsButton.y = 430;
        this.versionText.y = (600 - this.versionText.height);
        this.copyrightText.x = (800 - this.copyrightText.width);
        this.copyrightText.y = (600 - this.copyrightText.height);
    }

    private function onButtonClick(event:MouseEvent):void {
        var button:MenuButton = (event.target as MenuButton);
        this.buttonClicked.dispatch(button.name);
    }

    private function onPlayWhenUnregistered(event:MouseEvent):void {
        var button:MenuButton = (event.target as MenuButton);
        if (button.name == "PLAY") {
            button.name = "ACCOUNT";
        }
        this.buttonClicked.dispatch(button.name);
    }

}
}
