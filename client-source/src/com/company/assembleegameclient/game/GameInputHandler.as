package com.company.assembleegameclient.game {

import client.debug.Stats;
import client.ui.frames.GiveBox;

import com.company.assembleegameclient.map.Square;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.tutorial.Tutorial;
import com.company.assembleegameclient.tutorial.doneAction;
import com.company.assembleegameclient.ui.FrameHolder;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util._H_V_;

import flash.display.Stage;
import flash.display.StageDisplayState;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.system.Capabilities;
import flash.utils.Timer;

import game.marketplace.MarketplaceContainerUI;

import optionsscreen.Options;

/**
 * Keyboard / mouse input handler for the GameSprite (movement, shooting,
 * hotkeys, debug keys). Public API is unchanged: gs_, clearInput(), _vB_().
 */
public class GameInputHandler {

    private static const DOUBLE_CLICK_WINDOW_MS:uint = 175;

    private static var stats:Stats = new Stats();

    public var gs_:GameSprite;

    private var moveLeftHeld:Boolean = false;
    private var moveRightHeld:Boolean = false;
    private var moveUpHeld:Boolean = false;
    private var moveDownHeld:Boolean = false;
    private var rotateLeftHeld:Boolean = false;
    private var rotateRightHeld:Boolean = false;
    private var mouseDown:Boolean = false;
    private var autofire:Boolean = false;
    /** When false all gameplay input is ignored. (Original: _G_v, set via _vB_) */
    private var inputEnabled:Boolean = true;
    private var doubleClickTimer:Timer;
    private var clickCount:uint;

    public function GameInputHandler(gameSprite:GameSprite) {
        this.gs_ = gameSprite;
        this.doubleClickTimer = new Timer(DOUBLE_CLICK_WINDOW_MS, 1);
        this.doubleClickTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onDoubleClickTimer);
        this.gs_.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        this.gs_.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    /** Releases every held input and tells the player to stop moving. */
    public function clearInput():void {
        this.moveLeftHeld = false;
        this.moveRightHeld = false;
        this.moveUpHeld = false;
        this.moveDownHeld = false;
        this.rotateLeftHeld = false;
        this.rotateRightHeld = false;
        this.mouseDown = false;
        this.autofire = false;
        this.updatePlayerMovement();
    }

    /** Enables / disables gameplay input. (Original name: _vB_) */
    public function _vB_(enabled:Boolean):void {
        if (this.inputEnabled == enabled) {
            return;
        }
        this.inputEnabled = enabled;
        this.clearInput();
    }

    // ---------------------------------------------------------------- stage wiring

    private function onAddedToStage(event:Event):void {
        var stage:Stage = this.gs_.stage;
        stage.addEventListener(Event.DEACTIVATE, this.onDeactivate);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
        stage.addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
        stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        stage.addEventListener(MouseEvent.RIGHT_CLICK, this.onRightClick);
        this.gs_.map_.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
        this.gs_.map_.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
    }

    private function onRemovedFromStage(event:Event):void {
        var stage:Stage = this.gs_.stage;
        stage.removeEventListener(Event.DEACTIVATE, this.onDeactivate);
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
        stage.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
        stage.removeEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
        stage.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        stage.removeEventListener(MouseEvent.RIGHT_CLICK, this.onRightClick);
        this.gs_.map_.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
        this.gs_.map_.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
    }

    private function onDeactivate(event:Event):void {
        this.clearInput();
    }

    // ---------------------------------------------------------------- helpers

    /** Pushes the current rotate / x / y input state to the player. (Original: _B_Q_) */
    private function updatePlayerMovement():void {
        var player:Player = this.gs_.map_.player_;
        if (player == null) {
            return;
        }
        if (this.inputEnabled) {
            player._vr(
                (this.rotateRightHeld ? 1 : 0) - (this.rotateLeftHeld ? 1 : 0),
                (this.moveRightHeld ? 1 : 0) - (this.moveLeftHeld ? 1 : 0),
                (this.moveDownHeld ? 1 : 0) - (this.moveUpHeld ? 1 : 0));
        } else {
            player._vr(0, 0, 0);
        }
    }

    private function useItem(slot:int):void {
        var sidebar:* = this.gs_.hudView_;
        if (sidebar._02y == null || sidebar._02y._e9 == null) {
            return;
        }
        sidebar._02y._e9.useItem(slot);
    }

    private function togglePerformanceStats():void {
        if (this.gs_.contains(stats)) {
            this.gs_.removeChild(stats);
            this.gs_.removeChild(this.gs_.gsc_._0l);
            this.gs_.gsc_._rT_();
        } else {
            this.gs_.addChild(stats);
            this.gs_.gsc_._9G_();
            this.gs_.gsc_._0l.y = stats.height;
            this.gs_.addChild(this.gs_.gsc_._0l);
        }
    }

    /** Debug (F2): hides / shows the sidebar and chat. (Original: _0D_2) */
    private function toggleHud():void {
        Parameters._0F_o = !Parameters._0F_o;
        var visible:Boolean = !Parameters._0F_o;
        this.gs_.hudView_.visible = visible;
        this.gs_.textBox_._01P_.visible = visible;
    }

    private function toggleFullscreen(stage:Stage):void {
        if (Capabilities.playerType != "Desktop") {
            return;
        }
        Parameters.data_.fullscreenMode = !Parameters.data_.fullscreenMode;
        Parameters.save();
        stage.displayState = Parameters.data_.fullscreenMode ? "fullScreenInteractive" : StageDisplayState.NORMAL;
    }

    /** Keys that must work even while a text field has focus; everything else is ignored then. */
    private function isIgnoredWhileTyping(keyCode:uint, stage:Stage):Boolean {
        switch (keyCode) {
            case _H_V_.F1:
            case _H_V_.F2:
            case _H_V_.F3:
            case _H_V_.F4:
            case _H_V_.F5:
            case _H_V_.F6:
            case _H_V_.F7:
            case _H_V_.F8:
            case _H_V_.F9:
            case _H_V_.F10:
            case _H_V_.F11:
            case _H_V_.F12:
            case _H_V_.INSERT:
            case _H_V_.ALT:
                return false;
            default:
                return stage.focus != null;
        }
    }

    // ---------------------------------------------------------------- mouse

    private function onMouseDown(event:MouseEvent):void {
        var player:Player = this.gs_.map_.player_;
        if (player == null) {
            return;
        }
        if (!this.doubleClickTimer.running) {
            this.clickCount = 1;
            this.doubleClickTimer.start();
        } else {
            this.clickCount++;
        }
        if (!this.inputEnabled) {
            return;
        }
        if (event.shiftKey) {
            player.useAltWeapon(event.localX, event.localY);
            return;
        }
        doneAction(this.gs_, Tutorial._9Z_);
        player._O_7(Math.atan2(event.localY, event.localX)); // also handles the (Unstable) debuff
        this.mouseDown = true;
    }

    private function onMouseUp(event:MouseEvent):void {
        this.mouseDown = false;
    }

    /**
     * Fires after the double-click window. The map-position lookup result is
     * discarded (double-click action was removed) but the call is kept as-is.
     */
    private function onDoubleClickTimer(event:TimerEvent):void {
        if (this.clickCount > 1) {
            var target:Point = this.gs_.map_.pSTopW(this.gs_.map_.mouseX, this.gs_.map_.mouseY);
        }
    }

    /** Intentionally empty; the listener is kept so right-click keeps being captured. */
    private function onRightClick(event:MouseEvent):void {
    }

    private function onMouseWheel(event:MouseEvent):void {
        if (this.gs_ == null || this.gs_.hudView_ == null || this.gs_.hudView_._F_ == null) {
            return;
        }
        if (event.delta > 0) {
            this.gs_.hudView_._F_._K_r();   // minimap zoom in
        } else {
            this.gs_.hudView_._F_._w_();    // minimap zoom out
        }
    }

    private function onEnterFrame(event:Event):void {
        doneAction(this.gs_, Tutorial._xX_);
        if (this.inputEnabled && (this.mouseDown || this.autofire)) {
            var player:Player = this.gs_.map_.player_;
            if (player != null) {
                player._O_7(Math.atan2(this.gs_.map_.mouseY, this.gs_.map_.mouseX));
            }
        }
    }

    // ---------------------------------------------------------------- keyboard

    private function onKeyDown(event:KeyboardEvent):void {
        var stage:Stage = this.gs_.stage;
        if (this.isIgnoredWhileTyping(event.keyCode, stage)) {
            return;
        }
        var player:Player = this.gs_.map_.player_;
        switch (event.keyCode) {
            case Parameters.data_.moveUp:
                doneAction(this.gs_, Tutorial._04m);
                this.moveUpHeld = true;
                break;
            case Parameters.data_.moveDown:
                doneAction(this.gs_, Tutorial._03b);
                this.moveDownHeld = true;
                break;
            case Parameters.data_.moveLeft:
                doneAction(this.gs_, Tutorial._S_B_);
                this.moveLeftHeld = true;
                break;
            case Parameters.data_.moveRight:
                doneAction(this.gs_, Tutorial._0A_j);
                this.moveRightHeld = true;
                break;
            case Parameters.data_.rotateLeft:
                if (!Parameters.data_.allowRotation) break;
                doneAction(this.gs_, Tutorial._0B_d);
                this.rotateLeftHeld = true;
                break;
            case Parameters.data_.rotateRight:
                if (!Parameters.data_.allowRotation) break;
                doneAction(this.gs_, Tutorial._95);
                this.rotateRightHeld = true;
                break;
            case Parameters.data_.resetToDefaultCameraAngle:
                Parameters.data_.cameraAngle = Parameters.data_.defaultCameraAngle;
                Parameters.save();
                break;
            case Parameters.data_.useSpecial:
                player.useAltWeapon(this.gs_.map_.mouseX, this.gs_.map_.mouseY);
                break;
            case Parameters.data_.autofireToggle:
                this.autofire = !this.autofire;
                break;
            case Parameters.data_.useInvSlot1: this.useItem(0); break;
            case Parameters.data_.useInvSlot2: this.useItem(1); break;
            case Parameters.data_.useInvSlot3: this.useItem(2); break;
            case Parameters.data_.useInvSlot4: this.useItem(3); break;
            case Parameters.data_.useInvSlot5: this.useItem(4); break;
            case Parameters.data_.useInvSlot6: this.useItem(5); break;
            case Parameters.data_.useInvSlot7: this.useItem(6); break;
            case Parameters.data_.useInvSlot8: this.useItem(7); break;
            case Parameters.data_.miniMapZoomOut:
                if (this.gs_.hudView_._F_ == null) break;
                this.gs_.hudView_._F_._w_();
                break;
            case Parameters.data_.miniMapZoomIn:
                if (this.gs_.hudView_._F_ == null) break;
                this.gs_.hudView_._F_._K_r();
                break;
            case Parameters.data_.togglePerformanceStats:
                this.togglePerformanceStats();
                break;
            case Parameters.data_.escapeToNexus:
            case Parameters.data_.escapeToNexus2:
                this.gs_.gsc_._M_6();
                Parameters.data_.needsRandomRealm = false;
                Parameters.save();
                break;
            case Parameters.data_.options:
                this.clearInput();
                this.gs_.addChild(new Options(this.gs_));
                break;
            case Parameters.data_.toggleCentering:
                Parameters.data_.centerOnPlayer = !Parameters.data_.centerOnPlayer;
                Parameters.save();
                break;
            case Parameters.data_.toggleFullscreen:
                this.toggleFullscreen(stage);
                break;
            case Parameters.data_.switchTabs:
                if (this.gs_.hudView_._02y == null) break;
                this.gs_.hudView_._02y.nextTab();
                break;
            case Parameters.data_.marketHotkey:
                this.clearInput();
                this.gs_.addChild(new MarketplaceContainerUI(this.gs_));
                break;
        }
        if (Parameters._1h) {
            this.handleDebugKeys(event.keyCode);
        }
        if (!Parameters.isTesting) {
            this.handleTestKeys(event.keyCode);
        }
        this.updatePlayerMovement();
    }

    /** F2-F4 debug toggles (only when Parameters._1h is set). */
    private function handleDebugKeys(keyCode:uint):void {
        switch (keyCode) {
            case _H_V_.F2:
                this.toggleHud();
                break;
            case _H_V_.F3:
                Parameters._ih = !Parameters._ih;
                break;
            case _H_V_.F4:
                this.gs_.map_.mapOverlay_.visible = !this.gs_.map_.mapOverlay_.visible;
                this.gs_.map_.partyOverlay_.visible = !this.gs_.map_.partyOverlay_.visible;
                break;
        }
    }

    /** F6-F9 rendering / survey test keys (only when not Parameters.isTesting). */
    private function handleTestKeys(keyCode:uint):void {
        switch (keyCode) {
            case _H_V_.F6:
                TextureRedrawer.clearCache();
                Parameters._Q_b = (Parameters._Q_b + 1) % 7;
                this.gs_.textBox_.addText(Parameters.SendError, "Projectile Color Type: " + Parameters._Q_b);
                break;
            case _H_V_.F7:
                for each (var square:Square in this.gs_.map_.squares_) {
                    if (square != null) {
                        square.faces_.length = 0;
                    }
                }
                Parameters._R_P_ = (Parameters._R_P_ + 1) % 2;
                this.gs_.textBox_.addText(Parameters.SendClient, "Blend type: " + Parameters._R_P_);
                break;
            case _H_V_.F8:
                Parameters.data_.surveyDate = 0;
                Parameters.data_.needsSurvey = true;
                Parameters.data_.playTimeLeftTillSurvey = 5;
                Parameters.data_.surveyGroup = "testing";
                break;
            case _H_V_.F9:
                Parameters._Q_w = !Parameters._Q_w;
                break;
        }
    }

    private function onKeyUp(event:KeyboardEvent):void {
        var player:Player = this.gs_.map_.player_;
        switch (event.keyCode) {
            case Parameters.data_.moveUp:
                this.moveUpHeld = false;
                break;
            case Parameters.data_.moveDown:
                this.moveDownHeld = false;
                break;
            case Parameters.data_.moveLeft:
                this.moveLeftHeld = false;
                break;
            case Parameters.data_.moveRight:
                this.moveRightHeld = false;
                break;
            case Parameters.data_.rotateLeft:
                this.rotateLeftHeld = false;
                break;
            case Parameters.data_.rotateRight:
                this.rotateRightHeld = false;
                break;
            case Parameters.data_.useSpecial:
                player.shukAbil(this.gs_.map_.mouseX, this.gs_.map_.mouseY);
                break;
            case Parameters.data_.giveItem:
                this.openGiveBox();
                break;
        }
        this.updatePlayerMovement();
    }

    private function openGiveBox():void {
        if (this.gs_.stage.focus != null) {
            return;
        }
        if (this.gs_.charList_.isAdmin_) {
            this.clearInput();
            var giveBox:GiveBox = new GiveBox(this.gs_);
            this.gs_.stage.addChild(new FrameHolder(giveBox));
        } else {
            this.gs_.textBox_.addText(Parameters.SendError, "You are not an admin.");
        }
    }

}
}
