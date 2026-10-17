package com.company.assembleegameclient.ui {
import client.ui.panels.InteractPanel;

import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.net.messages.incoming.ItemSelectStart;
import com.company.assembleegameclient.net.messages.incoming.TradeAccepted;
import com.company.assembleegameclient.net.messages.incoming.TradeChanged;
import com.company.assembleegameclient.net.messages.incoming.TradeStart;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.util.DisplayUtil;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;

/**
 * The right-hand HUD column: minimap on top, player panel (portrait, bars,
 * equipment, tabs) below it, and the interact panel at the bottom. Swaps the
 * player panel for the trade window while a trade is open.
 *
 * Formerly: _0B_X_
 */
public class HudView extends Sprite {

    [Bindable]
    [Embed(source="/assets/GUI.png")]
    private var GUI:Class;
    [Embed(source="/assets/GUI_Dark.png")]
    private var GUI_Dark:Class;
    [Embed(source="/assets/GUI_Dark_Pink.png")]
    private var GUI_Dark_Pink:Class;
    [Embed(source="/assets/GUI_Darker_Pink.png")]
    private var GUI_Darker_Pink:Class;

    private static const MINIMAP_BORDER:int = 4;
    private static const PANEL_WIDTH:int = 200;

    /** Formerly _F_ */
    public var miniMap_:MiniMap = null;
    /** Formerly _02y */
    public var invTabs_:PlayerPanel;
    /** Formerly _U_T_ */
    public var interactPanel_:InteractPanel;
    /** Formerly _6K_ */
    public var tradeWindow_:TradeWindow = null;

    private var gs_:GameSprite;
    private var w_:int;
    private var h_:int;
    private var initialized_:Boolean;
    private var background_:Shape;
    private var divider_:LineSeparator = new LineSeparator(184, 0x2D2D2D);

    public function HudView(gs:GameSprite, width:int, height:int) {
        super();
        this.gs_ = gs;
        this.w_ = width;
        this.h_ = height;
        this.initialized_ = false;
        mouseEnabled = true;
        mouseChildren = true;
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    public function initialize():void {
        this.createMiniMap();
    }

    public function dispose():void {
        if (this.miniMap_ != null) {
            if (contains(this.miniMap_)) {
                removeChild(this.miniMap_);
            }
            this.miniMap_.dispose();
            this.miniMap_ = null;
        }
        if (this.invTabs_ != null) {
            if (contains(this.invTabs_)) {
                removeChild(this.invTabs_);
            }
            this.invTabs_ = null;
        }
    }

    /** A trade started; the window is shown on the next draw(). Formerly _0L_v. */
    public function startTrade(tradeStart:TradeStart):void {
        if (this.tradeWindow_ != null) {
            return;
        }
        this.tradeWindow_ = new TradeWindow(this.gs_, tradeStart);
        this.tradeWindow_.y = 200;
        this.tradeWindow_.addEventListener(Event.CANCEL, this.onTradeCancel);
    }

    public function selectItem(itemSelectStart:ItemSelectStart):void {
        if (this.invTabs_ == null) {
            return;
        }
        this.invTabs_.selectItems(itemSelectStart);
    }

    /** Formerly _ss */
    public function onTradeChanged(tradeChanged:TradeChanged):void {
        if (this.tradeWindow_ == null) {
            return;
        }
        this.tradeWindow_.setTheirOffer(tradeChanged.offer_);
    }

    /** Formerly _mH_ */
    public function onTradeAccepted(tradeAccepted:TradeAccepted):void {
        if (this.tradeWindow_ == null) {
            return;
        }
        this.tradeWindow_.onTradeAccepted(tradeAccepted.myOffer_, tradeAccepted.yourOffer_);
    }

    /** Closes the trade window, or cancels an open item selection. Formerly _A_a / _0L_A_. */
    public function closeTradeOrSelection():void {
        if (this.tradeWindow_ != null) {
            this.tradeWindow_.removeEventListener(Event.CANCEL, this.onTradeCancel);
            DisplayUtil.safeRemoveChild(this, this.tradeWindow_);
            this.tradeWindow_ = null;
        } else if (this.invTabs_ != null && this.invTabs_.itemSelect_ != null) {
            this.invTabs_.cancelSelect();
        }
    }

    public function draw():void {
        if (this.gs_.map_.player_ == null) {
            return;
        }
        if (!this.initialized_) {
            this.loadBackground();
            DisplayUtil.safeAddChild(this, this.miniMap_);
            this.createPanels();
            this.initialized_ = true;
        }
        this.miniMap_.draw();
        if (this.tradeWindow_ != null) {
            this.divider_.visible = false;
            DisplayUtil.safeRemoveChild(this, this.invTabs_);
            DisplayUtil.safeRemoveChild(this, this.interactPanel_);
            DisplayUtil.safeAddChild(this, this.tradeWindow_);
        } else {
            this.divider_.visible = false;
            DisplayUtil.safeAddChild(this, this.invTabs_);
            DisplayUtil.safeAddChild(this, this.interactPanel_);
            this.invTabs_.draw();
            this.interactPanel_.draw();
        }
    }

    /**
     * (Re)builds the HUD background according to Parameters.data_.GUI_screen:
     * 0 = flat colour, 1..4 = the embedded GUI textures. Formerly _loadGUIBG.
     */
    public function loadBackground():void {
        if (this.background_ != null && contains(this.background_)) {
            removeChild(this.background_);
        }
        this.background_ = new Shape();
        var g:Graphics = this.background_.graphics;
        g.clear();
        switch (Parameters.data_.GUI_screen) {
            case 0:
                g.beginFill(0x2A2A2A);
                break;
            case 1:
                g.beginBitmapFill(new GUI().bitmapData);
                break;
            case 2:
                g.beginBitmapFill(new GUI_Dark().bitmapData);
                break;
            case 3:
                g.beginBitmapFill(new GUI_Dark_Pink().bitmapData);
                break;
            case 4:
                g.beginBitmapFill(new GUI_Darker_Pink().bitmapData);
                break;
        }
        g.drawRect(0, 0, this.w_, this.h_);
        g.endFill();
        addChildAt(this.background_, 0);
        this.divider_.x = 8;
        this.divider_.y = 500;
        //addChild(this.divider_); // Enable if adding HP/MP pot buttons
    }

    /** Formerly _4T_ */
    private function createMiniMap():void {
        var size:int = PANEL_WIDTH - (2 * MINIMAP_BORDER);
        this.miniMap_ = new MiniMap(this.gs_.map_, size, size);
        this.miniMap_.x = MINIMAP_BORDER;
        this.miniMap_.y = MINIMAP_BORDER;
    }

    /** Formerly _0J_s */
    private function createPanels():void {
        var player:Player = this.gs_.map_.player_;
        this.invTabs_ = new PlayerPanel(this.gs_, player, 200, 300);
        this.invTabs_.y = 200;
        this.interactPanel_ = new InteractPanel(this.gs_, player, 200, 135);
        this.interactPanel_.x = 0;
        this.interactPanel_.y = 475;
    }

    /** Formerly _05I_ */
    private function onTradeCancel(event:Event):void {
        this.closeTradeOrSelection();
    }

    private function onEnterFrame(event:Event):void {
        this.draw();
    }

    private function onAddedToStage(event:Event):void {
        stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onRemovedFromStage(event:Event):void {
        stage.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }
}
}
