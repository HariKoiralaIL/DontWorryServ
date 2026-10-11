package gamemediator {
import client.game.GameInitData;

import client.signals.typed.GameInitSignal;
import client.signals.typed.BooleanSignal;

import client.events.ClientUpdateEvent;
import client.events.ReconnectEvent;

import robotlegs.bender.bundles.mvcs.Mediator;

import _F_1.CurrentCharacterScreen;

import _U_5._01W_;
import _U_5._M_d;
import _U_5._dd;

import env.ServerListState;
import env.DeathRecord;

import com.company.assembleegameclient.game.GameSprite;

import flash.events.Event;

// Formerly _L_Z_. Mediator for GameSprite: reacts to the game view's events by
//  - forwarding Boolean "input" changes to the view's user-input handler,
//  - going back to the character screen when the game ends or the client is out of date,
//  - starting a new game session when the server asks the client to reconnect.
//
// NOTE: the injected signal types (_D_m, _M_d, _01W_, _dd, _08i, _0I_H_, _G_J_) and the view
// member mui_._vB_ come from other packages and keep their obfuscated names. The names given to the injected fields below are inferred from how
// they are used and may need adjusting once those packages are refactored.
public class GameSpriteMediator extends Mediator {

    [Inject]
    public var view:GameSprite;
    [Inject]
    public var inputEnabledSignal:BooleanSignal;      // formerly _0H_j; carries a Boolean, forwarded to view.mui_
    [Inject]
    public var exitGameSignal:_M_d;          // formerly _0D_p; dispatched before showing the character screen
    [Inject]
    public var setScreenSignal:_01W_;        // formerly _0_b; shows a screen
    [Inject]
    public var _T__:_dd;                     // unused in this class, name unknown
    [Inject]
    public var playGameSignal:GameInitSignal;          // formerly _D_u; starts a game from GameInitData
    [Inject]
    public var _0I_s:ServerListState;                 // unused in this class, name unknown
    [Inject]
    public var _8X_:DeathRecord;                   // unused in this class, name unknown

    override public function initialize():void {
        this.inputEnabledSignal.add(this.onInputEnabledChanged);
        addViewListener(Event.COMPLETE, this.onComplete);
        addViewListener(ReconnectEvent.RECONNECT, this.onReconnect);
        addViewListener(ClientUpdateEvent.CLIENT_UPDATE, this.onClientUpdate);
    }

    override public function destroy():void {
        this.inputEnabledSignal.remove(this.onInputEnabledChanged);
        removeViewListener(Event.COMPLETE, this.onComplete);
        removeViewListener(ClientUpdateEvent.CLIENT_UPDATE, this.onClientUpdate);
        removeViewListener(ReconnectEvent.RECONNECT, this.onReconnect);
        this.view.dispose();
    }

    // formerly _n4
    public function onInputEnabledChanged(enabled:Boolean):void {
        this.view.mui_._vB_(enabled);
    }

    private function onComplete(e:Event):void {
        this.showCharacterScreen();
    }

    // formerly _Y_z
    private function onClientUpdate(e:ClientUpdateEvent):void {
        this.showCharacterScreen();
    }

    // formerly _X_3
    private function onReconnect(e:ReconnectEvent):void {
        if (this.view.isEditor) {
            return;
        }
        var initData:GameInitData = new GameInitData();
        initData.server = e.server_;
        initData.gameId = e.gameId_;
        initData.createCharacter = e.createCharacter_;
        initData.charId = e.charId_;
        initData.keyTime = e.keyTime_;
        initData.key = e.key_;
        this.playGameSignal.dispatch(initData);
    }

    // Shared by onComplete and onClientUpdate, which had identical bodies.
    private function showCharacterScreen():void {
        this.exitGameSignal.dispatch();
        this.setScreenSignal.dispatch(new CurrentCharacterScreen());
    }
}
}
