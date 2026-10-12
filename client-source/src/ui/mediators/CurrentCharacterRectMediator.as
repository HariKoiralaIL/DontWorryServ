package ui.mediators {
import client.game.GameInitData;
import client.signals.typed.GameInitSignal;

import com.company.assembleegameclient.appengine.SavedCharacter;
import com.company.assembleegameclient.screens.charrects.CurrentCharacterRect;

import game.signals.AnalyticsEventSignal;
import game.signals.SavedCharacterSignal2;

import robotlegs.bender.bundles.mvcs.Mediator;

import services.AnalyticsEvent;

/** Mediator for a single character row on the character screen: select (start game) and delete. */
public class CurrentCharacterRectMediator extends Mediator {

    [Inject]
    public var view:CurrentCharacterRect;
    [Inject]
    public var analyticsEventSignal:AnalyticsEventSignal;
    [Inject]
    public var gameInitSignal:GameInitSignal;
    [Inject]
    public var requestDeleteSignal:SavedCharacterSignal2;

    override public function initialize():void {
        this.view.selected.add(this.onCharacterSelected);
        this.view.deleteCharacter.add(this.onDeleteRequested);
    }

    override public function destroy():void {
        this.view.selected.remove(this.onCharacterSelected);
        this.view.deleteCharacter.remove(this.onDeleteRequested);
    }

    private function onCharacterSelected(character:SavedCharacter):void {
        this.trackCharacterSelected(character);
        this.startGame(character);
    }

    private function trackCharacterSelected(character:SavedCharacter):void {
        var analyticsEvent:AnalyticsEvent = new AnalyticsEvent();
        analyticsEvent.category = "character";
        analyticsEvent.action = "select";
        analyticsEvent.label = character.displayId();
        analyticsEvent.value = character.level();
        this.analyticsEventSignal.dispatch(analyticsEvent);
    }

    private function startGame(character:SavedCharacter):void {
        var initData:GameInitData = new GameInitData();
        initData.createCharacter = false;
        initData.charId = character.charId();
        initData.isNewGame = true;
        this.gameInitSignal.dispatch(initData);
    }

    private function onDeleteRequested(character:SavedCharacter):void {
        this.requestDeleteSignal.dispatch(character);
    }

}
}
