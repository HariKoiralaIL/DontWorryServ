package com.company.assembleegameclient.game {
import account.Account;

import audio.MusicManager;

import beginnersoffer.MenuLinkButton;

import client.events.MoneyChangedEvent;

import com.company.assembleegameclient.appengine.AppEngineClient;
import com.company.assembleegameclient.appengine.CharListEvent;
import com.company.assembleegameclient.map.GameMap;
import com.company.assembleegameclient.net.GameServerClient;
import com.company.assembleegameclient.net.Server;
import com.company.assembleegameclient.net.messages.incoming.MapInfo;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.objects.Projectile;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.tutorial.Tutorial;
import com.company.assembleegameclient.ui.Protip;
import com.company.assembleegameclient.ui._0B_X_;
import com.company.assembleegameclient.ui._0G_h;
import com.company.assembleegameclient.ui._1B_v;
import com.company.assembleegameclient.ui._L_N_;
import com.company.assembleegameclient.ui.ui_chat;
import com.company.assembleegameclient.ui.ui_goldcoin;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.MoreColorUtil;
import com.company.util._G_;
import com.company.util._H_U_;

import flash.display.DisplayObject;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.external.ExternalInterface;
import flash.filters.ColorMatrixFilter;
import flash.utils.ByteArray;
import flash.utils.getTimer;

import game.signals.MapInfoSignal;
import game.signals.SingletonSignal;

public class GameSprite extends BaseGameSprite {

    public static const CLIENT_START_TIME:Number = new Date().time;
    protected static const PAUSED_FILTER:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil._0M_l);

    private static const STAGE_WIDTH:int = 800;
    private static const STAGE_HEIGHT:int = 600;
    private static const HUD_WIDTH:int = 200;

    public var textBox_:ui_chat;
    public var hudView_:_0B_X_;
    public var charList_:CharListEvent;
    public var isNexus_:Boolean = false;
    public var protip_:Protip = null;
    public var idleWatcher_:IdleWatcher;
    public var updateButton_:MenuLinkButton;
    public var donateButton_:MenuLinkButton;
    public var discordButton_:MenuLinkButton;
    public var RaidButton_:MenuLinkButton;
    public var starsDisplay_:_0G_h;
    public var guildText_:_L_N_;
    public var goldDisplay_:ui_goldcoin;
    public var keysDisplay_:_1B_v;
    private var gameMap_:GameMap;
    private var loadingScreen:MapLoadingScreen;
    private var isOnStage:Boolean;

    public function GameSprite(server:Server, gameId:int, createCharacter:Boolean, charId:int, keyTime:int, keyBytes:ByteArray, charList:CharListEvent, mapJSON:String) {
        super();
        this.charList_ = charList;
        this.map_ = new GameMap(this);
        addChild(this.map_);
        this.gsc_ = new GameServerClient(this, server, gameId, createCharacter, charId, keyTime, keyBytes, mapJSON);
        this.mui_ = new GameInputHandler(this);
        this.textBox_ = new ui_chat(this, 600, 600);
        addChild(this.textBox_);
        this.hudView_ = new _0B_X_(this, HUD_WIDTH, 600);
        addChild(this.hudView_);
        this.idleWatcher_ = new IdleWatcher();
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    public function get map_():GameMap {
        return this.gameMap_;
    }

    public function set map_(value:GameMap):void {
        this.gameMap_ = value;
    }

    override public function applyMapInfo(mapInfo:MapInfo):void {
        this.gameMap_.setProps(mapInfo.width_, mapInfo.height_, mapInfo.name_, mapInfo.background_, mapInfo.allowPlayerTeleport_, mapInfo.showDisplays_, mapInfo.music_, mapInfo.weather_);
        this.showMapLoadingScreen(mapInfo);
    }

    public function showMapLoadingScreen(mapInfo:MapInfo):void {
        if (!this.loadingScreen) {
            this.loadingScreen = new MapLoadingScreen();
        }
        this.loadingScreen.width = stage.stageWidth;
        this.loadingScreen.height = stage.stageHeight;
        this.loadingScreen.x = 400 - stage.stageWidth / 2;
        this.loadingScreen.y = 300 - stage.stageHeight / 2;
        addChild(this.loadingScreen);
        addChild(this.textBox_);
        MapInfoSignal.getInstance().dispatch(mapInfo);
    }

    override public function initialize():void {
        this.map_.initialize();
        this.hudView_.initialize();
        this.goldDisplay_ = new ui_goldcoin(this);
        this.goldDisplay_.x = 594;
        this.goldDisplay_.y = 0;
        addChild(this.goldDisplay_);
        this.keysDisplay_ = new _1B_v();
        this.keysDisplay_.x = 594;
        this.keysDisplay_.y = 24;
        addChild(this.keysDisplay_);
        if (this.evalIsNotInCombatMapArea()) {
            this.initExtras();
        }
        if (this.map_.showDisplays_) {
            this.starsDisplay_ = new _0G_h(-1, true, false);
            this.starsDisplay_.x = 8;
            this.starsDisplay_.y = 4;
            addChild(this.starsDisplay_);
            this.guildText_ = new _L_N_("", -1);
            this.guildText_.x = 64;
            this.guildText_.y = 6;
            addChild(this.guildText_);
        }
        this.isNexus_ = (this.map_.name_ == "Nexus" || this.map_.name_ == "Shop" || this.map_.name_ == "Editor");
        var logClient:AppEngineClient = new AppEngineClient(Parameters._fK_(), "/log", true, 0);
        var acct:Account = Account.getInstance();
        var logParams:Object = {
            "game_net_user_id": acct.gameNetworkUserId(),
            "game_net": acct.gameNetwork(),
            "play_platform": acct.playPlatform()
        };
        _H_U_._t2(logParams, acct.credentials());
        // NOTE: `!name == "Kitchen"` compares a Boolean with a String and is always false,
        // so the tutorial-exit logging and protip branches below never run. Behavior kept as-is.
        if (!this.map_.name_ == "Kitchen" && !this.map_.name_ == "Tutorial" && Parameters.data_.watchForTutorialExit == true) {
            Parameters.data_.watchForTutorialExit = false;
            this.callExternal('rotmg.Marketing.track("tutorialComplete")');
            logParams["fteStepCompleted"] = 9900;
            logClient.sendRequest("logFteStep", logParams);
        }
        if (this.map_.name_ == "Kitchen") {
            logParams["fteStepCompleted"] = 200;
            logClient.sendRequest("logFteStep", logParams);
        }
        if (this.map_.name_ == "Tutorial") {
            if (Parameters.data_.needsTutorial == true) {
                Parameters.data_.watchForTutorialExit = true;
                this.callExternal('rotmg.Marketing.track("install")');
                logParams["fteStepCompleted"] = 100;
                logClient.sendRequest("logFteStep", logParams);
            }
            this.startTutorial();
        } else if (!this.map_.name_ == "Kitchen" && !this.map_.showDisplays_ && Parameters.data_.showProtips) {
            this.showProtip();
        }
        Parameters.save();
        this.hideMapLoadingScreen();
    }

    public function showProtip():void {
        this.hideProtip();
        this.protip_ = new Protip();
        addChild(this.protip_);
    }

    public function hideProtip():void {
        if (this.protip_ && contains(this.protip_)) {
            removeChild(this.protip_);
        }
        this.protip_ = null;
    }

    public function dispose():void {
        if (contains(this.map_)) {
            removeChild(this.map_);
        }
        this.map_.dispose();
        removeChild(this.hudView_);
        this.hudView_.dispose();
        _G_.clear();
        TextureRedrawer.clearCache();
        Projectile.dispose();
    }

    public function isSafeMap():Boolean {
        return this.map_.name_ == "Nexus" || this.map_.name_ == "Vault" || this.map_.name_ == "Guild Hall";
    }

    override public function evalIsNotInCombatMapArea():Boolean {
        var name:String = this.gameMap_.name_;
        return name == "Nexus" || name == "Vault" || name == "Guild Hall" || name == "The Shop" || name == "Nexus Tutorial";
    }

    public function onAddedToStage(event:Event):void {
        if (this.isOnStage) {
            return;
        }
        this.isOnStage = true;
        this.hudView_.x = 600;
        this.hudView_.y = 0;
        this.gsc_.connect();
        this.idleWatcher_.start(this);
        this.lastUpdate_ = getTimer();
        stage.addEventListener(MoneyChangedEvent.MONEY_CHANGED, this.onMoneyChanged);
        stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        this.setSettingDefault("mscale", "1.0");
        this.setSettingDefault("stageScale", StageScaleMode.NO_SCALE);
        this.setSettingDefault("uiscale", true);
        stage.scaleMode = Parameters.data_["stageScale"];
        stage.addEventListener(Event.RESIZE, this.onScreenResize);
        stage.dispatchEvent(new Event(Event.RESIZE));
    }

    public function onRemovedFromStage(event:Event):void {
        if (!this.isOnStage) {
            return;
        }
        this.isOnStage = false;
        this.idleWatcher_.stop();
        this.gsc_.connection_.disconnect();
        SingletonSignal.instance.dispatch();
        stage.removeEventListener(MoneyChangedEvent.MONEY_CHANGED, this.onMoneyChanged);
        stage.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    /**
     * Rescales the map and HUD pieces to the current stage size.
     * With "uiscale" on, HUD pieces keep their aspect ratio (scaleX = rx/ry, scaleY = 1);
     * otherwise they stretch with the stage.
     */
    public function onScreenResize(event:Event):void {
        var useUiScale:Boolean = Parameters.data_["uiscale"];
        var ratioX:Number = STAGE_WIDTH / stage.stageWidth;
        var ratioY:Number = STAGE_HEIGHT / stage.stageHeight;
        if (this.map_ != null) {
            var mapScale:Number = (stage.scaleMode != StageScaleMode.EXACT_FIT) ? Parameters.data_["mscale"] : 1;
            this.map_.scaleX = ratioX * mapScale;
            this.map_.scaleY = ratioY * mapScale;
        }
        if (this.hudView_ != null) {
            if (useUiScale) {
                this.hudView_.scaleX = ratioX / ratioY;
                this.hudView_.scaleY = 1;
                this.hudView_.y = 0;
            } else {
                this.hudView_.scaleX = ratioX;
                this.hudView_.scaleY = ratioY;
                this.hudView_.y = 300 * (1 - ratioY);
            }
            this.hudView_.x = STAGE_WIDTH - HUD_WIDTH * this.hudView_.scaleX;
            if (this.keysDisplay_ != null) {
                this.keysDisplay_.x = this.hudView_.x - 6 * this.keysDisplay_.scaleX;
            }
            if (this.goldDisplay_ != null) {
                this.goldDisplay_.x = this.hudView_.x - 6 * this.goldDisplay_.scaleX;
            }
        }
        if (this.textBox_ != null) {
            this.applyScale(this.textBox_, ratioX, ratioY, useUiScale);
        }
        if (this.starsDisplay_ != null) {
            this.applyScale(this.starsDisplay_, ratioX, ratioY, useUiScale);
            this.starsDisplay_.x = 8 * this.starsDisplay_.scaleX;
            this.starsDisplay_.y = 4 * this.starsDisplay_.scaleY;
        }
        if (this.updateButton_ != null) {
            this.applyScale(this.updateButton_, ratioX, ratioY, useUiScale);
            this.updateButton_.x = 8 * this.updateButton_.scaleX;
            this.updateButton_.y = 32 * this.updateButton_.scaleY;
        }
        if (this.donateButton_ != null) {
            this.applyScale(this.donateButton_, ratioX, ratioY, useUiScale);
            this.donateButton_.x = 8 * this.donateButton_.scaleX;
            this.donateButton_.y = 64 * this.donateButton_.scaleY;
        }
        if (this.discordButton_ != null) {
            this.applyScale(this.discordButton_, ratioX, ratioY, useUiScale);
            this.discordButton_.x = 8 * this.discordButton_.scaleX;
            this.discordButton_.y = (34 + 28 + 28 + 6) * this.discordButton_.scaleY;
        }
        if (this.guildText_ != null) {
            this.applyScale(this.guildText_, ratioX, ratioY, useUiScale);
            this.guildText_.x = this.starsDisplay_.width + 16 * this.guildText_.scaleX;
            this.guildText_.y = 6 * this.guildText_.scaleY;
        }
        if (this.goldDisplay_ != null) {
            this.applyScale(this.goldDisplay_, ratioX, ratioY, useUiScale);
        }
        if (this.keysDisplay_ != null) {
            this.applyScale(this.keysDisplay_, ratioX, ratioY, useUiScale);
        }
    }

    private function applyScale(target:DisplayObject, ratioX:Number, ratioY:Number, useUiScale:Boolean):void {
        if (useUiScale) {
            target.scaleX = ratioX / ratioY;
            target.scaleY = 1;
        } else {
            target.scaleX = ratioX;
            target.scaleY = ratioY;
        }
    }

    private function setSettingDefault(key:String, value:*):void {
        if (Parameters.data_[key] == undefined) {
            Parameters.data_[key] = value;
            Parameters.save();
        }
    }

    private function initExtras():void {
        this.initDonate();
        this.initDiscord();
        this.initRaid();
    }

    private function initDonate():void {
        this.donateButton_ = this.placeButton(this.donateButton_, new MenuLinkButton(true, 14, "Donate", "DONATE"), 6, 34);
    }

    private function initUpdate():void {
        this.updateButton_ = this.placeButton(this.updateButton_, new MenuLinkButton(), 6, 34 + 28);
    }

    private function initDiscord():void {
        this.discordButton_ = this.placeButton(this.discordButton_, new MenuLinkButton(true, 13, "Discord", "DISCORD"), 6, 34 + 28 + 28);
    }

    private function initRaid():void {
        this.RaidButton_ = this.placeButton(this.RaidButton_, new MenuLinkButton(true, 12, "New Raid!", "RAID", 0xFF0000, 100), 6, 34);
    }

    /** Positions `button`, replaces `current` (if any) on the display list and returns `button`. */
    private function placeButton(current:MenuLinkButton, button:MenuLinkButton, buttonX:Number, buttonY:Number):MenuLinkButton {
        button.x = buttonX;
        button.y = buttonY;
        if (current != null) {
            removeChild(current);
        }
        addChild(button);
        return button;
    }

    private function hideMapLoadingScreen():void {
        if (this.loadingScreen) {
            this.loadingScreen._pW_();
            this.loadingScreen = null;
        }
    }

    private function callExternal(script:String):void {
        if (ExternalInterface.available == false) {
            return;
        }
        try {
            ExternalInterface.call(script);
        } catch (err:Error) {
            // page may not allow script access
        }
    }

    private function startTutorial():void {
        this.tutorial_ = new Tutorial(this);
        addChild(this.tutorial_);
    }

    private function onMoneyChanged(event:Event):void {
        this.gsc_.checkCredits();
    }

    private function onEnterFrame(event:Event):void {
        var now:int = getTimer();
        var dt:int = now - this.lastUpdate_;
        if (this.idleWatcher_.update(dt)) {
            dispatchEvent(new Event(Event.COMPLETE));
            return;
        }
        MusicManager.updateFade();
        this.map_.update(now, dt);
        this.camera_.update(dt);
        this.onScreenResize(event);
        var player:Player = this.map_.player_;
        if (player != null) {
            this.camera_.configureForPlayer(player);
            this.map_.draw(this.camera_, now);
            this.goldDisplay_.draw(player.credits_, player.fame_);
            this.keysDisplay_.draw(player.keys_);
            this.hudView_.draw();
            if (this.map_.showDisplays_) {
                this.starsDisplay_.draw(player.numStars_);
                this.guildText_.draw(player.guildName_, player.guildRank_);
            }
            if (player.isPaused()) {
                this.map_.filters = [PAUSED_FILTER];
                this.hudView_.filters = [PAUSED_FILTER];
                this.setHudMouseEnabled(false);
            } else if (this.map_.filters.length > 0) {
                this.map_.filters = [];
                this.hudView_.filters = [];
                this.setHudMouseEnabled(true);
            }
            this.moveRecords_._F_5(now, player.x_, player.y_);
        }
        this.lastUpdate_ = now;
    }

    private function setHudMouseEnabled(enabled:Boolean):void {
        this.map_.mouseEnabled = enabled;
        this.map_.mouseChildren = enabled;
        this.hudView_.mouseEnabled = enabled;
        this.hudView_.mouseChildren = enabled;
    }

}
}
