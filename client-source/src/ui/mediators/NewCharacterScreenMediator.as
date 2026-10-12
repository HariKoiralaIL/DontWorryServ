package ui.mediators {
import client.ui.screens.CurrentCharacterScreen;
import client.ui.screens.NewCharacterScreen;

import client.game.GameInitData;
import client.signals.typed.GameInitSignal;

import com.company.assembleegameclient.parameters.Parameters;

import env.ServerListState;

import game.signals.SpriteSignal2;

import robotlegs.bender.bundles.mvcs.Mediator;

/** Mediator for the new-character (class selection) screen (_F_1._0H_2). */
public class NewCharacterScreenMediator extends Mediator {

    [Inject]
    public var view:NewCharacterScreen;
    [Inject]
    public var serverList:ServerListState;
    [Inject]
    public var changeScreenSignal:SpriteSignal2;
    [Inject]
    public var gameInitSignal:GameInitSignal;

    override public function initialize():void {
        this.view.play.add(this.onPlay);
        this.view.close.add(this.onClose);
        this.view.initialize(this.serverList.servers);
    }

    override public function destroy():void {
        this.view.play.remove(this.onPlay);
        this.view.close.remove(this.onClose);
    }

    private function onClose():void {
        this.changeScreenSignal.dispatch(new CurrentCharacterScreen());
    }

    private function onPlay(playerObjectType:int):void {
        Parameters.data_.playerObjectType = playerObjectType;
        Parameters.save();
        var initData:GameInitData = new GameInitData();
        initData.createCharacter = true;
        initData.charId = this.serverList.servers.nextCharId_;
        initData.keyTime = -1;
        this.gameInitSignal.dispatch(initData);
    }

}
}
