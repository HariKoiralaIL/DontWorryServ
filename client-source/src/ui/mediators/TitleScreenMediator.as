package ui.mediators {
import _F_1.CurrentCharacterScreen;
import _F_1._01_;
import _F_1._0H_h;
import _F_1._3V_;
import _F_1._C_Q_;

import client.game.GameInitData;
import client.signals.typed.GameInitSignal;

import com.company.assembleegameclient.parameters.Parameters;

import constants.Buttons;

import env.ServerListState;

import flash.display.Sprite;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import game.dialogs.Dialog;
import game.signals.SpriteSignal2;

import mapeditor.MapEditorScreen;

import robotlegs.bender.bundles.mvcs.Mediator;

import spriteeditor.SpriteEditorScreen;

/**
 * Mediator for the title screen (_F_1._C_Q_): routes each menu button to its screen.
 * Screen views still named _F_1._xxx: _0H_h = credits, _01_ = servers, _3V_ = legends.
 */
public class TitleScreenMediator extends Mediator {

    private static const FORUMS_URL:String = "http://bledixon.com/forums";
    private static const TUTORIAL_PLAYER_TYPE:int = 770;
    private static const NO_TESTING_SERVERS_MESSAGE:String =
            "Your account doesn't exist anymore, please make a new.  Please play on " +
            '<font color="#7777EE"><a href="bledixon.com/webclient">bledixon.com/webclient</a></font>.';

    private static const OFFLINE_MESSAGE:String =
            "Project B is currently offline.\n\nGo here for more information:\n" +
            '<font color="#7777EE"><a href="http://bledixon.com/forums">http://bledixon.com/forums</a></font>.';

    [Inject]
    public var view:_C_Q_;
    [Inject]
    public var serverList:ServerListState;
    [Inject]
    public var changeScreenSignal:SpriteSignal2;
    [Inject]
    public var gameInitSignal:GameInitSignal;

    override public function initialize():void {
        this.view._ft.add(this.onButtonClicked);
        this.view.initialize(this.serverList.servers);
    }

    override public function destroy():void {
        this.view._ft.remove(this.onButtonClicked);
    }

    public function onButtonClicked(button:String):void {
        switch (button) {
            case Buttons.PLAY:
                this.onPlay();
                break;
            case Buttons.SERVERS:
                this.showScreen(new _01_());
                break;
            case Buttons.CREDITS:
                this.showScreen(new _0H_h());
                break;
            case Buttons.ACCOUNT:
                this.view._0j();
                break;
            case Buttons.LEGENDS:
                this.showScreen(new _3V_());
                break;
            case Buttons.EDITOR:
                this.showScreen(new MapEditorScreen());
                break;
            case Buttons.SPRITE:
                this.showScreen(new SpriteEditorScreen());
                break;
            case Buttons.FORUMS:
                navigateToURL(new URLRequest(FORUMS_URL), "_blank");
                break;
        }
    }

    private function showScreen(screen:Sprite):void {
        this.changeScreenSignal.dispatch(screen);
    }

    private function onPlay():void {
        if (Parameters.isTesting && this.serverList.servers.servers_.length == 0) {
            this.showOfflineDialog();
            return;
        }
        if (Parameters.data_.needsTutorial && this.serverList.servers.nextCharId_ == 1) {
            this.startTutorial();
        } else {
            this.showScreen(new CurrentCharacterScreen());
        }
    }

    private function showOfflineDialog():void {
        var dialog:Dialog;
        if (Parameters._I_O_()) {
            dialog = new Dialog(NO_TESTING_SERVERS_MESSAGE, "No Testing Servers", null, null, "/noTestingServers");
        } else {
            dialog = new Dialog(OFFLINE_MESSAGE, "The Angelics are Sleeping", null, null, "/offLine");
        }
        this.view.stage.addChild(dialog);
    }

    private function startTutorial():void {
        Parameters.data_.playerObjectType = TUTORIAL_PLAYER_TYPE;
        Parameters.save();
        var initData:GameInitData = new GameInitData();
        initData.createCharacter = true;
        initData.charId = this.serverList.servers.nextCharId_;
        initData.keyTime = -1;
        initData.isNewGame = true;
        this.gameInitSignal.dispatch(initData);
    }

}
}
