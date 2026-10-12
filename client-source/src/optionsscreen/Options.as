package optionsscreen {

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageDisplayState;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.system.Capabilities;
import flash.text.TextFieldAutoSize;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import flash.ui.MouseCursorData;

import client.ui.screens.MenuButton;

import audio.SfxSettings;
import audio.MusicManager;

import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui._0M_Y_;
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;
import com.company.util._H_V_;

/**
 * The options screen: a row of tabs, and a two-column grid of options for the selected tab.
 * Each option is a BaseOption (ChoiceOption or KeyCodeOption) bound to a key in Parameters.data_.
 */
public class Options extends Sprite {

    private static const op_controls:String = "Controls";
    private static const op_hotkey:String = "Hot Keys";
    private static const op_chat:String = "Chat";
    private static const op_graph:String = "Graphics";
    private static const op_sound:String = "Sound";
    private static const op_antilag:String = "Anti Lag";
    private static const op_extras:String = "Extras";
    private static const TAB_NAMES:Vector.<String> = new <String>[op_controls, op_hotkey, op_chat, op_graph, op_sound, op_antilag, op_extras];
    private static var registeredCursors:Vector.<String> = new Vector.<String>(0);

    private var gs_:GameSprite;
    private var titleText:SimpleText;
    private var continueButton:MenuButton;
    private var resetButton:MenuButton;
    private var homeButton:MenuButton;
    private var tabs:Vector.<OptionsTabTitle> = new Vector.<OptionsTabTitle>();
    private var selected_:OptionsTabTitle = null;

    /** The rows on the current tab (includes empty spacer Sprites). */
    private var optionRows:Vector.<Sprite> = new Vector.<Sprite>();

    /** Number of cells filled so far on the current tab; drives the two-column layout. */
    private var rowCount:int = 0;

    public function Options(gameSprite:GameSprite) {
        this.gs_ = gameSprite;
        graphics.clear();
        graphics.beginFill(0x2B2B2B, 0.8);
        graphics.drawRect(0, 0, 800, 600);
        graphics.endFill();
        graphics.lineStyle(1, 0x5E5E5E);
        graphics.moveTo(0, 100);
        graphics.lineTo(800, 100);
        graphics.lineStyle();
        this.titleText = new SimpleText(36, 0xFFFFFF, false, 800, 0, "Myriad Pro");
        this.titleText.setBold(true);
        this.titleText.htmlText = '<p align="center">Options</p>';
        this.titleText.autoSize = TextFieldAutoSize.CENTER;
        this.titleText.filters = [new DropShadowFilter(0, 0, 0)];
        this.titleText.updateMetrics();
        this.titleText.x = (800 / 2) - (this.titleText.width / 2);
        this.titleText.y = 8;
        addChild(this.titleText);
        //addChild(new ScreenGraphic());
        this.continueButton = new MenuButton("continue", 36, false);
        this.continueButton.addEventListener(MouseEvent.CLICK, this.onContinueClick);
        addChild(this.continueButton);
        this.resetButton = new MenuButton("reset to defaults", 22, false);
        this.resetButton.addEventListener(MouseEvent.CLICK, this.onResetClick);
        addChild(this.resetButton);
        this.homeButton = new MenuButton("back to home", 22, false);
        this.homeButton.addEventListener(MouseEvent.CLICK, this.onHomeClick);
        addChild(this.homeButton);
        var tabX:int = 14;
        var i:int = 0;
        while (i < TAB_NAMES.length) {
            var tab:OptionsTabTitle = new OptionsTabTitle(TAB_NAMES[i]);
            tab.x = tabX;
            tab.y = 70;
            addChild(tab);
            tab.addEventListener(MouseEvent.CLICK, this.onTabClick);
            this.tabs.push(tab);
            tabX = tabX + 108;
            i++;
        }
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    /** Name of the modifier key used to swap inventory items on this OS. */
    public function invSwap():String {
        return (Capabilities.os.split(" ")[0] == "Mac") ? "Command" : "Ctrl";
    }

    private function setSelected(tab:OptionsTabTitle):void {
        if (tab == this.selected_) {
            return;
        }
        if (this.selected_ != null) {
            this.selected_.setSelected(false);
        }
        this.selected_ = tab;
        this.selected_.setSelected(true);
        this.clearOptions();
        switch (this.selected_.text_) {
            case op_controls:
                this.addControlsOptions();
                return;
            case op_hotkey:
                this.addHotKeyOptions();
                return;
            case op_chat:
                this.addChatOptions();
                return;
            case op_graph:
                this.addGraphicsOptions();
                return;
            case op_sound:
                this.addSoundOptions();
                return;
            case op_antilag:
                this.addAntiLagOptions();
                return;
            case op_extras:
                this.addExtraOptions();
                return;
        }
    }

    private function close():void {
        stage.focus = null;
        parent.removeChild(this);
    }

    /** Removes the rows of the current tab. */
    private function clearOptions():void {
        var row:Sprite;
        for each (row in this.optionRows) {
            removeChild(row);
        }
        this.optionRows.length = 0;
        this.rowCount = 0;
    }

    private function addControlsOptions():void {
        this.addOption(new KeyCodeOption("moveUp", "Move Up", "Key to will move character up"));
        this.addOption(new KeyCodeOption("moveLeft", "Move Left", "Key to will move character to the left"));
        this.addOption(new KeyCodeOption("moveDown", "Move Down", "Key to will move character down"));
        this.addOption(new KeyCodeOption("moveRight", "Move Right", "Key to will move character to the right"));
        this.addOption(new ChoiceOption("allowRotation", new <String>["On", "Off"], [true, false], "Allow Camera Rotation", "Toggles whether to allow for camera rotation", this.onAllowRotationChange));
        this.addOption(new Sprite());
        this.addOption(new KeyCodeOption("rotateLeft", "Rotate Left", "Key to will rotate the camera to the left", !(Parameters.data_.allowRotation)));
        this.addOption(new KeyCodeOption("rotateRight", "Rotate Right", "Key to will rotate the camera to the right", !(Parameters.data_.allowRotation)));
        this.addOption(new KeyCodeOption("useSpecial", "Use Special Ability", "This key will activate your special ability"));
        this.addOption(new KeyCodeOption("autofireToggle", "Autofire Toggle", "This key will toggle autofire"));
        this.addOption(new KeyCodeOption("resetToDefaultCameraAngle", "Reset To Default Camera Angle", ("This key will reset the camera angle to the default " + "position")));
        this.addOption(new KeyCodeOption("togglePerformanceStats", "Toggle Performance Stats", "This key will toggle a display of fps and memory usage"));
        this.addOption(new KeyCodeOption("toggleCentering", "Toggle Centering of Player", ("This key will toggle the position between centered and " + "offset")));
        this.addOption(new KeyCodeOption("interact", "Interact/Buy", "This key will allow you to enter a portal or buy an item"));
        this.addOption(new ChoiceOption("contextualClick", new <String>["On", "Off"], [true, false], "Contextual Click", "Toggle the contextual click functionality", null));
        this.addOption(new ChoiceOption("clickForGold", new <String>["On", "Off"], [true, false], "Double Click for Gold", "Double clicking on gold/fame while in a Realm will open the payments screen", null));
    }

    /** Greys out the rotate-key options when camera rotation is turned off. */
    private function onAllowRotationChange():void {
        var keyOption:KeyCodeOption;
        var i:int = 0;
        while (i < this.optionRows.length) {
            keyOption = (this.optionRows[i] as KeyCodeOption);
            if (keyOption != null) {
                if (keyOption.paramName == "rotateLeft" || keyOption.paramName == "rotateRight") {
                    keyOption.setDisabled(!Parameters.data_.allowRotation);
                }
            }
            i++;
        }
    }

    private function addHotKeyOptions():void {
        this.addOption(new KeyCodeOption("useInvSlot1", "Use Inventory Slot 1", "Use item in inventory slot 1"));
        this.addOption(new KeyCodeOption("useInvSlot2", "Use Inventory Slot 2", "Use item in inventory slot 1"));
        this.addOption(new KeyCodeOption("useInvSlot3", "Use Inventory Slot 3", "Use item in inventory slot 1"));
        this.addOption(new KeyCodeOption("useInvSlot4", "Use Inventory Slot 4", "Use item in inventory slot 1"));
        this.addOption(new KeyCodeOption("useInvSlot5", "Use Inventory Slot 5", "Use item in inventory slot 1"));
        this.addOption(new KeyCodeOption("useInvSlot6", "Use Inventory Slot 6", "Use item in inventory slot 1"));
        this.addOption(new KeyCodeOption("useInvSlot7", "Use Inventory Slot 7", "Use item in inventory slot 1"));
        this.addOption(new KeyCodeOption("useInvSlot8", "Use Inventory Slot 8", "Use item in inventory slot 1"));
        this.addOption(new KeyCodeOption("miniMapZoomIn", "Mini-Map Zoom In", "This key will zoom in the minimap"));
        this.addOption(new KeyCodeOption("miniMapZoomOut", "Mini-Map Zoom Out", "This key will zoom out the minimap"));
        this.addOption(new KeyCodeOption("escapeToNexus", "Escape To Nexus", "This key will instantly escape you to the Nexus"));
        this.addOption(new KeyCodeOption("options", "Show Options", "This key will bring up the options screen"));
        this.addOption(new KeyCodeOption("switchTabs", "Switch Tabs", "THis key will flip through your tabs."));
        this.addOption(new KeyCodeOption("giveItem", "Give Item", "Opens the item give box (admin-only)"));
        this.addOption(new KeyCodeOption("marketHotkey", "Open Marketplace", "Open The Marketplace with the click of a button"));
        if (Capabilities.playerType == "Desktop") {
            this.addOption(new KeyCodeOption("toggleFullscreen", "Toggle Fullscreen Mode", ("Toggle whether the game is " + "run in a window or fullscreen")));
        }
    }

    private function addChatOptions():void {
        this.addOption(new KeyCodeOption("chat", "Activate Chat", "This key will bring up the chat input box"));
        this.addOption(new KeyCodeOption("chatCommand", "Start Chat Command", ("This key will bring up the chat with a '/' prepended to " + "allow for commands such as /who, /ignore, etc.")));
        this.addOption(new KeyCodeOption("tell", "Begin Tell", ("This key will bring up a tell (private message) in the chat" + " input box")));
        this.addOption(new KeyCodeOption("guildChat", "Begin Guild Chat", ("This key will bring up a guild chat in the chat" + " input box")));
        this.addOption(new KeyCodeOption("partyChat", "Begin Party Chat", "This key will bring up a party chat in the chat input box"));
        this.addOption(new ChoiceOption("filterLanguage", new <String>["On", "Off"], [true, false], "Filter Offensive Language", "This toggles whether offensive language be filtering will be attempted", null));
        this.addOption(new KeyCodeOption("scrollChatUp", "Scroll Chat Up", ("This key will scroll up to older messages in the chat " + "buffer")));
        this.addOption(new KeyCodeOption("scrollChatDown", "Scroll Chat Down", ("This key will scroll down to newer messages in the chat " + "buffer")));
        this.addOption(new ChoiceOption("hidePlayerChat", new <String>["On", "Off"], [true, false], "Hide Player Chat", "Hides player chat messages in the chat box.", null));
        this.addOption(new ChoiceOption("chatStarRequirement", new <String>["Off", "1", "2", "3", "5", "10"], [0, 1, 2, 3, 5, 10], "Star Requirement", "Only see chat from players who have earned at least this amount of stars. May help with chat spam.", null));
    }

    private function addGraphicsOptions():void {
        this.addOption(new ChoiceOption("defaultCameraAngle", new <String>["45°", "0°"], [((7 * Math.PI) / 4), 0], "Default Camera Angle", "This toggles the default camera angle", this.onDefaultCameraAngleChange));
        this.addOption(new ChoiceOption("centerOnPlayer", new <String>["On", "Off"], [true, false], "Center On Player", "This toggles whether the player is centered or offset", null));
        this.addOption(new ChoiceOption("showQuestPortraits", new <String>["On", "Off"], [true, false], "Show Quest Portraits", "This toggles whether quest portraits are displayed", this.onShowQuestPortraitsChange));
        this.addOption(new ChoiceOption("showProtips", new <String>["On", "Off"], [true, false], "Show Tips", "This toggles whether a tip is displayed when you join a new game", null));
        this.addOption(new ChoiceOption("drawShadows", new <String>["On", "Off"], [true, false], "Draw Shadows", "This toggles whether to draw shadows", null));
        this.addOption(new ChoiceOption("textBubbles", new <String>["On", "Off"], [true, false], "Draw Text Bubbles", "This toggles whether to draw text bubbles", null));
        this.addOption(new ChoiceOption("showTradePopup", new <String>["On", "Off"], [true, false], "Show Trade Request Panel", "This toggles whether to show trade requests in the lower-right panel or just in chat.", null));
        this.addOption(new ChoiceOption("showGuildInvitePopup", new <String>["On", "Off"], [true, false], "Show Guild Invite Panel", "This toggles whether to show guild invites in the lower-right panel or just in chat.", null));
        this.addOption(new ChoiceOption("toggleBarText", new <String>["On", "Off"], [true, false], "Toggle HP/MP Text", "Always show text values for remaining HP/MP", this.onBarTextChange));
        if (Capabilities.playerType == "Desktop") {
            this.addOption(new ChoiceOption("fullscreenMode", new <String>["On", "Off"], [true, false], "Fullscreen Mode", "This toggles whether the game is run in fullscreen mode.", this.onFullscreenModeChange));
        }
    }

    private function addAntiLagOptions():void {
        this.addOption(new ChoiceOption("disableAllyProjectiles", new <String>["On", "Off"], [true, false], "Disable Ally Projectiles", "You don't see other Projectiles anymore", null));
        this.addOption(new ChoiceOption("disableWeather", new <String>["On", "Off"], [true, false], "Disable Weather", "Disables Weather", null));
        this.addOption(new ChoiceOption("HideOtherPlayers", new <String>["On", "Off"], [true, false], "Disable Other Players", "Other Players are invisible", null));
        this.addOption(new ChoiceOption("disableParticles", new <String>["On", "Off"], [true, false], "Disable Particles", "All Particles will be disabled", null));
        this.addOption(new ChoiceOption("disableDamageText", new <String>["On", "Off"], [true, false], "Disable Damage Text", "All Damage Text will be removed", null));
        this.addOption(new ChoiceOption("forceLowQuality", new <String>["On", "Off"], [true, false], "Force Low Quality", "Forces Low Quality", null));
    }

    private function addExtraOptions():void {
        this.addOption(new ChoiceOption("rotationSpeed", new <String>["Slow", "Normal", "Fast", "Hyper"], [0.001, 0.003, 0.007, 0.01], "Manage Rotation Speed", "Changes the speed you rotate the camera", null));
        this.addOption(new ChoiceOption("togglePercentage", new <String>["On", "Off"], [true, false], "Show HP/MP Percentage", "Display HP/MP as percent values", this.onBarTextChange));
        this.addOption(new ChoiceOption("blureffect", new <String>["On", "Off"], [true, false], "Motion Blur", "Enable a Motion Blur to make the game look even better", null));
        this.addOption(new ChoiceOption("damageInfo", new <String>["On", "Off"], [true, false], "Damage Info", "Displays the current health of the monster upon hit", null));
        this.addOption(new ChoiceOption("mscale", new <String>["0.5", "0.6", "0.7", "0.8", "0.9", "1", "1.1", "1.2","1.3","1.4","1.5","1.6","1.7","1.8","1.9","2"], [0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0], "Map Scale", "The lower the value, the more zoomed out your view is! Works the opposite way!", null));
        //  this.addOption(new ChoiceOption("ultraView", new <String>["On", "Off"], [true, false], "Ultra Viewing Distance", "Only use if using fullscreen! This may cause FPS lag!", null));
        //Hey bledi, in order to fix those 2 options below, all you have to do, is add them to Parameters.as, as it can't grab a unset value!
        //this.addOption(new ChoiceOption("brightness", new <String>["20", "40", "60", "80", "100"], [0.1, 0.2, 0.3, 0.4, 0.5], "Brightness", "Changes the brightness level!", null));
        this.addOption(new ChoiceOption("cursorSelect", new <String>["Cursor 1", "Cursor 2", "Cursor 3", "Cursor 4", "Cursor 5", "Cursor 6", "Cursor 7", "Cursor 8", "Cursor 9", "Cursor 10"], [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], "Cursor", "Changes your Cursor!", refreshCursor));
        this.addOption(new ChoiceOption("GUI_screen", new <String>["Normal", "Light", "Dark", "Dark Pink", "Darker Pink"], [0, 1, 2, 3, 4], "GUI Look", "Changes the theme of your Game Client!", null));
    }

    private function onDefaultCameraAngleChange():void {
        Parameters.data_.cameraAngle = Parameters.data_.defaultCameraAngle;
        Parameters.save();
    }

    private function onShowQuestPortraitsChange():void {
        if (this.gs_ != null && this.gs_.map_ != null
                && this.gs_.map_.partyOverlay_ != null
                && this.gs_.map_.partyOverlay_.questArrow_ != null) {
            this.gs_.map_.partyOverlay_.questArrow_.refreshToolTip();
        }
    }

    private function onFullscreenModeChange():void {
        stage.displayState = (Parameters.data_.fullscreenMode) ? "fullScreenInteractive" : StageDisplayState.NORMAL;
    }

    private function onBarTextChange():void {
        _0M_Y_.options_.dispatch(Parameters.data_.toggleBarText);
    }

    private function addSoundOptions():void {
        this.addOption(new ChoiceOption("playMusic", new <String>["On", "Off"], [true, false], "Play Music", "This toggles whether music is played", this.onPlayMusicChange));
        this.addOption(new Sprite());
        this.addOption(new ChoiceOption("playSFX", new <String>["On", "Off"], [true, false], "Play Sound Effects", "This toggles whether sound effects are played", this.onPlaySfxChange));
        this.addOption(new Sprite());
        this.addOption(new ChoiceOption("playPewPew", new <String>["On", "Off"], [true, false], "Play Weapon Sounds", "This toggles whether weapon sounds are played", null));
    }

    private function onPlayMusicChange():void {
        MusicManager.setMusicEnabled(Parameters.data_.playMusic);
    }

    private function onPlaySfxChange():void {
        SfxSettings.setSfxEnabled(Parameters.data_.playSFX);
    }

    /** Places an option in the next free cell of the two-column grid. */
    private function addOption(option:Sprite):void {
        option.x = ((this.rowCount % 2) == 0) ? 20 : 415;
        option.y = (int(this.rowCount / 2) * 44) + 122;
        addChild(option);
        option.addEventListener(Event.CHANGE, this.onOptionChange);
        this.optionRows.push(option);
        this.rowCount++;
    }

    /** Re-reads every option's value from Parameters.data_. */
    private function refresh():void {
        var option:BaseOption;
        var i:int = 0;
        while (i < this.optionRows.length) {
            option = (this.optionRows[i] as BaseOption);
            if (option != null) {
                option.refresh();
            }
            i++;
        }
    }

    private function onContinueClick(event:MouseEvent):void {
        this.close();
    }

    private function onResetClick(event:MouseEvent):void {
        var option:BaseOption;
        var i:int = 0;
        while (i < this.optionRows.length) {
            option = (this.optionRows[i] as BaseOption);
            if (option != null) {
                delete Parameters.data_[option.paramName];
            }
            i++;
        }
        Parameters.initDefaults();
        Parameters.save();
        this.refresh();
    }

    private function onHomeClick(event:MouseEvent):void {
        this.gs_.dispatchEvent(new Event(Event.COMPLETE));
    }

    private function onTabClick(event:MouseEvent):void {
        var tab:OptionsTabTitle = (event.target as OptionsTabTitle);
        this.setSelected(tab);
    }

    private function onAddedToStage(event:Event):void {
        this.continueButton.x = (800 / 2) - (this.continueButton.width / 2);
        this.continueButton.y = 545;
        this.resetButton.x = 20;
        this.resetButton.y = 555;
        this.homeButton.x = 620;
        this.homeButton.y = 555;
        if (Capabilities.playerType == "Desktop") {
            Parameters.data_.fullscreenMode = (stage.displayState == "fullScreenInteractive");
            Parameters.save();
        }
        this.setSelected(this.tabs[0]);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown, false, 1);
        stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp, false, 1);
    }

    private function onRemovedFromStage(event:Event):void {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown, false);
        stage.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUp, false);
    }

    /** Switches to the cursor chosen in Parameters.data_.cursorSelect, registering it on first use. */
    public static function refreshCursor():void {
        var cursorData:MouseCursorData;
        var bitmaps:Vector.<BitmapData>;
        if (Parameters.data_.cursorSelect != MouseCursor.AUTO
                && registeredCursors.indexOf(Parameters.data_.cursorSelect) == -1) {
            cursorData = new MouseCursorData();
            cursorData.hotSpot = new Point(15, 15);
            bitmaps = new Vector.<BitmapData>(1, true);
            bitmaps[0] = AssetLibrary._xK_("cursorsEmbed", int(Parameters.data_.cursorSelect));
            cursorData.data = bitmaps;
            Mouse.registerCursor(Parameters.data_.cursorSelect, cursorData);
            registeredCursors.push(Parameters.data_.cursorSelect);
        }
        Mouse.cursor = Parameters.data_.cursorSelect;
    }

    private function onKeyDown(event:KeyboardEvent):void {
        if (Capabilities.playerType == "Desktop" && event.keyCode == _H_V_.ESCAPE) {
            Parameters.data_.fullscreenMode = false;
            Parameters.save();
            this.refresh();
        }
        if (event.keyCode == Parameters.data_.options) {
            this.close();
        }
        event.stopImmediatePropagation();
    }

    private function onKeyUp(event:KeyboardEvent):void {
        event.stopImmediatePropagation();
    }

    private function onOptionChange(event:Event):void {
        this.refresh();
    }

}
}//package optionsscreen
