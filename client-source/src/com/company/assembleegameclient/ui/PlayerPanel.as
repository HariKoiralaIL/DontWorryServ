package com.company.assembleegameclient.ui {
import client.ui.screens.MenuButton;

import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.net.messages.incoming.ItemSelectStart;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.utils.Dictionary;

import optionsscreen.Options;

/**
 * The player panel of the HUD: portrait, name, Nexus / Options button,
 * level / fame, HP and MP bars, equipment row and the tab area
 * (inventory, stats, teleport shortcuts and - for admins - admin commands).
 *
 * Formerly: InvTabs
 */
public class PlayerPanel extends Sprite {

    private static const TAB_Y:int = 152;
    private static const MAX_LEVEL:int = 120;
    private static const BAR_WIDTH:int = 176;
    private static const BAR_HEIGHT:int = 16;
    private static const BAR_BACK_COLOR:uint = 0x2D2D2D;

    private static const COMMAND_FONT_SIZE:int = 11;
    private static const COMMAND_LEFT_X:int = 7;
    private static const COMMAND_RIGHT_X:int = 70;

    /** Equipment row (first four slots). */
    public var equips_:Inventory;
    /** The inventory tab's slots (formerly _e9). */
    public var inventory_:Inventory;
    public var itemSelect_:ItemSelect;

    private var gs_:GameSprite;
    private var player_:Player;
    private var w_:int;
    private var h_:int;
    private var portrait_:Bitmap;
    private var nameText_:SimpleText;
    /** "Nexus" button, or "Options" inside the Nexus (formerly _nw). */
    private var actionButton_:HotkeyButton = null;
    private var levelBar_:StatusBar;
    private var fameBar_:StatusBar;
    private var healthBar_:StatusBar;
    private var manaBar_:StatusBar;
    private var stats_:Stats;
    private var invTab_:TabButton;
    private var statTab_:TabButton;
    private var teleportTab_:TabButton;
    private var adminTab_:TabButton;
    private var tabList_:Array;
    private var selectedTab_:int = 0;
    /** Last seen XP multiplier, to detect changes (formerly _0E__). */
    private var lastMultiplier_:int;
    /** Chat command sent by each command button. */
    private var commands_:Dictionary = new Dictionary();

    public function PlayerPanel(gs:GameSprite, player:Player, width:int, height:int) {
        super();
        this.gs_ = gs;
        this.player_ = player;
        this.w_ = width;
        this.h_ = height;
        this.portrait_ = new Bitmap(null);
        this.portrait_.x = -2;
        this.portrait_.y = -10;
        addChild(this.portrait_);
        this.nameText_ = new SimpleText(20, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        this.nameText_.setBold(true);
        this.nameText_.x = 36;
        this.nameText_.y = -2;
        if (this.gs_.charList_.name_ == null) {
            this.nameText_.text = this.player_.name_;
        } else {
            this.nameText_.text = this.gs_.charList_.name_;
        }
        this.nameText_.updateMetrics();
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.nameText_);
        if (this.gs_.gsc_.gameId_ != Parameters.NEXUS_ID) {
            this.actionButton_ = new HotkeyButton(AssetLibrary.getImageFromSet("lofiInterfaceBig", 6), "Nexus", "escapeToNexus");
            this.actionButton_.addEventListener(MouseEvent.CLICK, this.onNexusClick);
        } else {
            this.actionButton_ = new HotkeyButton(AssetLibrary.getImageFromSet("lofiInterfaceBig", 5), "Options", "options");
            this.actionButton_.addEventListener(MouseEvent.CLICK, this.onOptionsClick);
        }
        this.actionButton_.x = 172;
        this.actionButton_.y = 2;
        addChild(this.actionButton_);

        this.levelBar_ = this.createBar(0x5A8025, "Lvl X", 30, true);
        this.fameBar_ = this.createBar(0xE25F00, "Fame", 30, false);
        this.healthBar_ = this.createBar(0xE03434, "HP", 54, true);
        this.manaBar_ = this.createBar(0x6084E0, "MP", 78, true);

        this.equips_ = new Inventory(gs, player, "Inventory", player.slotTypes_.slice(0, 4), 4, true, 0, true);
        this.equips_.x = 14;
        this.equips_.y = 104;
        addChild(this.equips_);

        this.tabList_ = [];
        this.invTab_ = this.createTab(0x20, true, 0, 7);
        this.statTab_ = this.createTab(0x21, false, 1, 35);
        this.stats_ = new Stats(191, 45);
        this.stats_.x = 6;
        this.stats_.y = 7;
        this.statTab_.holder_.addChild(this.stats_);
        this.inventory_ = new Inventory(gs, player, "Inventory", player.slotTypes_.slice(4), 8, true, 4);
        this.inventory_.x = 7;
        this.inventory_.y = 7;
        this.invTab_.holder_.addChild(this.inventory_);

        this.teleportTab_ = this.createTab(0x27, false, 2, 35 + 28);
        this.addCommandButton(this.teleportTab_, "Vault", COMMAND_LEFT_X, 10, "/vault");
        this.addCommandButton(this.teleportTab_, "Nexus", COMMAND_LEFT_X, 25, "/nexus");
        this.addCommandButton(this.teleportTab_, "Shop", COMMAND_LEFT_X, 40, "/shop");
        this.addCommandButton(this.teleportTab_, "Gold Shop", COMMAND_LEFT_X, 55, "/goldshop");
        this.addCommandButton(this.teleportTab_, "XP Farm", COMMAND_LEFT_X, 70, "/xpgift");
        this.addCommandButton(this.teleportTab_, "Elder Realm", COMMAND_RIGHT_X, 55, "/realm");
        this.addCommandButton(this.teleportTab_, "Event Arena", COMMAND_RIGHT_X, 10, "/earena");
        this.addCommandButton(this.teleportTab_, "Arena", COMMAND_RIGHT_X, 25, "/arena");
        this.addCommandButton(this.teleportTab_, "Godlands", COMMAND_RIGHT_X, 40, "/eglands");
        this.addCommandButton(this.teleportTab_, "Cloth Market", COMMAND_RIGHT_X, 70, "/clothmarket");

        if (Player._e_D) {
            this.adminTab_ = this.createTab(0x26, false, 3, 35 + 56);
            this.addCommandButton(this.adminTab_, "Max this Character!", COMMAND_LEFT_X, 10, "/m");
            this.addCommandButton(this.adminTab_, "Restart the server!", COMMAND_LEFT_X, 25, "/restart");
            this.addCommandButton(this.adminTab_, "Summon all players!", COMMAND_LEFT_X, 40, "/summonall");
            this.addCommandButton(this.adminTab_, "Max Level!", COMMAND_LEFT_X, 55, "/stats lvl 120");
        }
        mouseEnabled = false;
        this.setChildIndex(this.invTab_, this.numChildren - 1);
        this.draw();
    }

    public function setName(name:String):void {
        this.nameText_.text = name;
        this.nameText_.updateMetrics();
    }

    public function nextTab():void {
        if (this.selectedTab_ + 1 == this.tabList_.length) {
            this.switchTab(this.tabList_[0] as TabButton);
        } else {
            this.switchTab(this.tabList_[this.selectedTab_ + 1] as TabButton);
        }
    }

    public function switchTab(tab:TabButton):void {
        if (tab.selected_) {
            return;
        }
        for each (var other:TabButton in this.tabList_) {
            other.setSelected(false);
        }
        tab.setSelected(true);
        this.selectedTab_ = tab.tabId_;
        this.setChildIndex(tab, this.numChildren - 1);
    }

    public function draw():void {
        this.portrait_.bitmapData = this.player_.getPortrait();
        var levelLabel:String = "Lvl " + this.player_.level_;
        if (levelLabel != this.levelBar_.labelText_.text) {
            this.levelBar_.labelText_.text = levelLabel;
            this.levelBar_.labelText_.updateMetrics();
        }
        if (this.player_.level_ != MAX_LEVEL) {
            if (!this.levelBar_.visible) {
                this.levelBar_.visible = true;
                this.fameBar_.visible = false;
            }
            this.levelBar_.draw(this.player_.exp_, this.player_._7V_, 0);
            if (this.lastMultiplier_ != this.player_._gz) {
                this.lastMultiplier_ = this.player_._gz;
                this.levelBar_.setMultiplier(this.lastMultiplier_ != 0, this.player_._gz);
            }
        } else {
            if (!this.fameBar_.visible) {
                this.fameBar_.visible = true;
                this.levelBar_.visible = false;
            }
            this.fameBar_.draw(this.player_._0L_o, this.player_._n8, 0);
        }
        this.healthBar_.draw(this.player_.HP_, this.player_.maxHP_, this.player_._P_7, this.player_.maxHPMax_);
        this.manaBar_.draw(this.player_.MP_, this.player_.maxMP_, this.player_._0D_G_, this.player_.maxMPMax_);
        this.stats_.draw(this.player_);
        this.equips_.draw(this.player_.equipment_.slice(0, 4));
        this.inventory_.draw(this.player_.equipment_.slice(4));
    }

    public function destroy():void {
    }

    /** Replaces the equipment / inventory tabs with the item-select window. */
    public function selectItems(itemSelectStart:ItemSelectStart):void {
        if (this.itemSelect_ != null) {
            return;
        }
        this.equips_.visible = false;
        this.statTab_.visible = false;
        this.invTab_.visible = false;
        this.itemSelect_ = new ItemSelect(this.gs_, itemSelectStart);
        this.itemSelect_.y = 62;
        addChild(this.itemSelect_);
        this.itemSelect_.addEventListener(Event.CANCEL, this.cancelSelect);
    }

    public function cancelSelect(event:Event = null):void {
        this.equips_.visible = true;
        this.statTab_.visible = true;
        this.invTab_.visible = true;
        if (this.itemSelect_ != null) {
            this.itemSelect_.removeEventListener(Event.CANCEL, this.cancelSelect);
            removeChild(this.itemSelect_);
            this.itemSelect_ = null;
        }
    }

    private function createBar(color:uint, label:String, y:int, visible:Boolean):StatusBar {
        var bar:StatusBar = new StatusBar(BAR_WIDTH, BAR_HEIGHT, color, BAR_BACK_COLOR, label);
        bar.x = 12;
        bar.y = y;
        addChild(bar);
        bar.visible = visible;
        return bar;
    }

    private function createTab(iconIndex:int, selected:Boolean, tabId:int, x:int):TabButton {
        var tab:TabButton = new TabButton(AssetLibrary.getImageFromSet("lofiInterfaceBig", iconIndex), selected, tabId);
        tab.addEventListener(MouseEvent.CLICK, this.onTabClick);
        tab.x = x;
        tab.y = TAB_Y;
        addChild(tab);
        this.tabList_[tabId] = tab;
        return tab;
    }

    /** Adds a button to a tab that sends a chat command when clicked. */
    private function addCommandButton(tab:TabButton, label:String, x:int, y:int, command:String):void {
        var button:MenuButton = new MenuButton(label, COMMAND_FONT_SIZE, false);
        button.addEventListener(MouseEvent.CLICK, this.onCommandClick);
        button.x = x;
        button.y = y;
        button.buttonMode = true;
        button.useHandCursor = true;
        tab.holder_.addChild(button);
        this.commands_[button] = command;
    }

    private function onCommandClick(event:MouseEvent):void {
        this.gs_.gsc_.playerText(this.commands_[event.currentTarget]);
    }

    /** Formerly _Q_C_ */
    private function onNexusClick(event:MouseEvent):void {
        this.gs_.gsc_.escape();
        Parameters.data_.needsRandomRealm = false;
        Parameters.save();
    }

    /** Formerly _nD_ */
    private function onOptionsClick(event:MouseEvent):void {
        this.gs_.mui_.clearInput();
        this.gs_.addChild(new Options(this.gs_));
    }

    private function onTabClick(event:MouseEvent):void {
        if (event.target is TabButton) {
            this.switchTab(event.target as TabButton);
        }
    }
}
}
