package gamestart {
import robotlegs.bender.framework.api.IConfig;

import injection.Injector;

import mediators.IMediatorMap;

import commandmap.ISignalCommandMap;

import client.signals.typed.BooleanSignal;
import client.signals.typed.GameInitSignal;

import gamemediator.GameSpriteMediator;

import com.company.assembleegameclient.game.GameSprite;

/**
 * Robotlegs config for the game screen: registers a singleton, the
 * GameSprite mediator and one signal-to-command mapping.
 */
public class GameConfig implements IConfig {

    [Inject]
    public var injector:Injector;
    [Inject]
    public var mediatorMap:IMediatorMap;
    [Inject]
    public var signalCommandMap:ISignalCommandMap;

    public function configure():void {
        injector.map(BooleanSignal).asSingleton();
        mediatorMap.map(GameSprite).toMediator(GameSpriteMediator);
        signalCommandMap.map(GameInitSignal).toCommand(StartGameCommand);
    }

}
}
