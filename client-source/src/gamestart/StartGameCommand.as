package gamestart {

import flash.utils.ByteArray;

import com.company.assembleegameclient.appengine.Server_list;
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.net.Server;
import com.company.assembleegameclient.parameters.Parameters;

import env.ServerListState;

import services.LoadCharacterListTask;
import client.game.GameInitData;
import client.tasks.CallbackTask;
import client.tasks.TaskTracker;
import client.tasks.SequenceTask;
import _U_5._dd;

/**
 * Starts a game session: records the character's last-used time, then
 * creates the GameSprite and dispatches it. When a new character has to be
 * created, the preload task runs first and the GameSprite is shown once
 * it has completed.
 */
public class StartGameCommand {

    [Inject]
    public var showViewSignal:_dd;
    [Inject]
    public var initData:GameInitData;
    [Inject]
    public var serverListState:ServerListState;
    [Inject]
    public var preloadTask:LoadCharacterListTask;
    [Inject]
    public var taskMonitor:TaskTracker;

    public function execute():void {
        this.recordCharacterUse();
        this.startGame();
    }

    private function recordCharacterUse():void {
        Parameters.data_.charIdUseMap[this.initData.charId] = new Date().time;
        Parameters.save();
    }

    private function startGame():void {
        if (!this.initData.createCharacter) {
            this.showGameSprite();
            return;
        }
        var taskGroup:SequenceTask = new SequenceTask();
        taskGroup.add(new CallbackTask(this.showGameSprite));
        taskGroup.add(this.preloadTask);
        this.taskMonitor.add(taskGroup);
        taskGroup.start();
    }

    private function showGameSprite():void {
        var servers:Server_list = this.serverListState.servers;
        var server:Server = this.initData.server || servers._04D_();
        var gameId:int = this.initData.isNewGame ? this.getNewGameId() : this.initData.gameId;
        var createCharacter:Boolean = this.initData.createCharacter;
        var charId:int = this.initData.charId;
        var keyTime:int = this.initData.isNewGame ? -1 : this.initData.keyTime;
        var key:ByteArray = this.initData.key;
        this.serverListState.count = charId;
        this.showViewSignal.dispatch(new GameSprite(server, gameId, createCharacter, charId, keyTime, key, servers, null));
    }

    /**
     * Picks the map for a brand-new game, in priority order:
     * tutorial, random realm, nexus tutorial (one-shot), then the nexus.
     */
    private function getNewGameId():int {
        if (Parameters.data_.needsTutorial) {
            return Parameters.TUT_ID;
        }
        if (Parameters.data_.needsRandomRealm) {
            return Parameters.RAND_REALM;
        }
        if (Parameters.data_.needsNexusTutorial) {
            Parameters.data_.needsNexusTutorial = false;
            Parameters.save();
            return Parameters.NEXUS_LIMBO;
        }
        return Parameters.NEXUS_ID;
    }

}
}
