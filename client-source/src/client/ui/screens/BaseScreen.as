package client.ui.screens {
import account.Account;
import account.AccountTextEvent;
import account.AccountTextView;

import client.events.AccountChangedEvent;
import client.events.MoneyChangedEvent;

import com.company.assembleegameclient.appengine.CharListEvent;
import com.company.assembleegameclient.ui._0G_h;
import com.company.assembleegameclient.ui._L_N_;
import com.company.assembleegameclient.ui.tooltip.RankToolTip;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import signals.Signal;

/**
 * Base class for the full-screen menu views. Owns the shared header widgets:
 * guild name/rank, star rank (with tooltip) and the account text. Re-dispatches
 * "reloadScreen" with the concrete screen class whenever the account or money
 * changes so the screen can be rebuilt.
 */
public class BaseScreen extends Sprite {

    private static const STAGE_WIDTH:int = 800;
    private static const ACCOUNT_TEXT_MARGIN:int = 10;

    public var tooltip:Signal;
    public var reloadScreen:Signal;
    public var accountText:AccountTextView;

    private var starsLayer:Sprite;
    private var guildLayer:Sprite;
    private var accountLayer:Sprite;
    private var guildName:String;
    private var guildRank:int;
    private var stars:int;
    private var screenClass:Class;
    private var starsView:_0G_h;
    private var guildView:_L_N_;
    private var initialized:Boolean;

    public function BaseScreen(screenClass:Class) {
        this.tooltip = new Signal();
        this.reloadScreen = new Signal(Class);
        this.screenClass = screenClass;
        this.buildLayers();
        this.buildAccountText();
    }

    public function setGuild(name:String, rank:int):void {
        this.guildName = name;
        this.guildRank = rank;
        this.drawGuild();
    }

    public function setStars(count:int):void {
        this.stars = count;
        this.drawStars();
    }

    public function destroy():void {
        stage.removeEventListener(MoneyChangedEvent.MONEY_CHANGED, this.onMoneyChanged);
        stage.removeEventListener(AccountChangedEvent.ACCOUNT_CHANGED, this.onAccountChanged);
    }

    public function openAccountManagement():void {
        var management:Sprite = Account.getInstance().newAccountManagement();
        if (management == null) {
            return;
        }
        management.addEventListener(Event.COMPLETE, this.onAccountComplete);
        addChild(management);
    }

    public function initialize(model:CharListEvent):void {
        if (this.initialized) {
            return;
        }
        this.initialized = true;
        this.setGuild(model.guildName_, model.guildRank_);
        this.setStars(model.numStars_);
        this.positionAccountText();
        this.accountText.y = 2;
        stage.addEventListener(MoneyChangedEvent.MONEY_CHANGED, this.onMoneyChanged);
        stage.addEventListener(AccountChangedEvent.ACCOUNT_CHANGED, this.onAccountChanged);
    }

    private function buildLayers():void {
        addChild((this.starsLayer = new Sprite()));
        addChild((this.guildLayer = new Sprite()));
        addChild((this.accountLayer = new Sprite()));
    }

    private function buildAccountText():void {
        this.accountText = Account.getInstance().newAccountText();
        this.accountText.addEventListener(AccountTextEvent.ACCOUNT_TEXT_EVENT, this.onAccountTextEvent);
        this.accountLayer.addChild(this.accountText);
    }

    private function drawGuild():void {
        this.guildView = new _L_N_(this.guildName, this.guildRank);
        this.guildView.x = 92;
        this.guildView.y = 6;
        this.guildLayer.addChild(this.guildView);
    }

    private function drawStars():void {
        this.starsView = new _0G_h(this.stars, true, false);
        this.starsView.x = 36;
        this.starsView.y = 4;
        this.starsView.mouseEnabled = true;
        this.starsView.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        this.starsView.addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
        this.starsLayer.addChild(this.starsView);
    }

    private function positionAccountText():void {
        this.accountText.x = (STAGE_WIDTH - this.accountText.width) - ACCOUNT_TEXT_MARGIN;
    }

    protected function onMouseOver(event:MouseEvent):void {
        this.tooltip.dispatch(new RankToolTip(this.stars));
    }

    protected function onRollOut(event:MouseEvent):void {
        this.tooltip.dispatch(null);
    }

    protected function onAccountComplete(event:Event):void {
        var management:Sprite = (event.currentTarget as Sprite);
        management.removeEventListener(Event.COMPLETE, this.onAccountComplete);
        removeChild(management);
        this.accountText.refresh();
        this.positionAccountText();
        if (this.screenClass != null) {
            this.reloadScreen.dispatch(this.screenClass);
        }
    }

    protected function onAccountTextEvent(event:AccountTextEvent):void {
        if (event.textView == null) {
            this.accountText.refresh();
            this.positionAccountText();
            this.reloadScreen.dispatch(this.screenClass);
        } else {
            event.textView.addEventListener(Event.COMPLETE, this.onAccountComplete);
            addChild(event.textView);
        }
    }

    private function onMoneyChanged(event:Event):void {
        if (this.screenClass) {
            this.reloadScreen.dispatch(this.screenClass);
        }
    }

    private function onAccountChanged(event:Event):void {
        if (this.screenClass != null) {
            this.reloadScreen.dispatch(this.screenClass);
        }
    }

}
}
