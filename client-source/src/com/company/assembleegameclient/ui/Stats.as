package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.tooltip.TitleDescriptionToolTip;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

/**
 * Grid of the player's eight stats with value, boost and a tooltip per stat.
 */
public class Stats extends Sprite {

    public static const STAT_ATTACK:int = 0;
    public static const STAT_DEFENSE:int = 1;
    public static const STAT_SPEED:int = 2;
    public static const STAT_DEXTERITY:int = 3;
    public static const STAT_VITALITY:int = 4;
    public static const STAT_WISDOM:int = 5;
    public static const STAT_LUCK:int = 6;
    public static const STAT_CRITICAL:int = 7;

    private static const STAT_DEFINITIONS:XML = <Stats>
        <Stat>
            <Abbr>ATT</Abbr>
            <n>Attack</n>
            <Description>This stat increases the amount of damage done.</Description>
            <RedOnZero/>
        </Stat>
        <Stat>
            <Abbr>DEF</Abbr>
            <n>Defense</n>
            <Description>This stat decreases the amount of damage taken.</Description>
        </Stat>
        <Stat>
            <Abbr>SPD</Abbr>
            <n>Speed</n>
            <Description>This stat increases the speed at which the character moves.</Description>
            <RedOnZero/>
        </Stat>
        <Stat>
            <Abbr>DEX</Abbr>
            <n>Dexterity</n>
            <Description>This stat increases the speed at which the character attacks.</Description>
            <RedOnZero/>
        </Stat>
        <Stat>
            <Abbr>VIT</Abbr>
            <n>Vitality</n>
            <Description>This stat increases the speed at which hit points are recovered.</Description>
            <RedOnZero/>
        </Stat>
        <Stat>
            <Abbr>WIS</Abbr>
            <n>Wisdom</n>
            <Description>This stat increases the speed at which magic points are recovered.</Description>
            <RedOnZero/>
        </Stat>
        <Stat>
            <Abbr>LUCK</Abbr>
            <n>Luck</n>
            <Description>This stat increases the chance to obtain loot.</Description>
            <RedOnZero/>
        </Stat>
        <Stat>
            <Abbr>CRIT</Abbr>
            <n>Critical</n>
            <Description>This stat increases the possibility of making critical damage.</Description>
            <RedOnZero/>
        </Stat>
    </Stats>;

    public var w_:int;
    public var h_:int;
    /** One display per stat, indexed by the STAT_* constants (formerly _086). */
    public var statDisplays_:Vector.<StatDisplay> = new Vector.<StatDisplay>();
    public var toolTip_:TitleDescriptionToolTip = new TitleDescriptionToolTip(0x2A2A2A, 0x9B9B9B, "", "", 200);

    public function Stats(width:int, height:int) {
        super();
        this.w_ = width;
        this.h_ = height;
        for each (var definition:XML in STAT_DEFINITIONS.Stat) {
            // Note: the definitions use <n> for the name, so definition.Name is empty (as in the original).
            var display:StatDisplay = new StatDisplay(definition.Abbr, definition.Name, definition.Description, definition.hasOwnProperty("RedOnZero"));
            display.x = (8 + 26) + (int(this.statDisplays_.length % 2) * ((this.w_ / 2) - 4));
            display.y = (8 + (this.h_ / 6)) + ((int(this.statDisplays_.length / 2) * this.h_) / 3);
            addChild(display);
            this.statDisplays_.push(display);
        }
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    public function draw(player:Player):void {
        this.statDisplays_[STAT_ATTACK].draw(player.attack_, player._05s, player.attackMax_);
        this.statDisplays_[STAT_DEFENSE].draw(player.defense_, player._07f, player.defenseMax_);
        this.statDisplays_[STAT_SPEED].draw(player.speed_, player._065, player.speedMax_);
        this.statDisplays_[STAT_DEXTERITY].draw(player.dexterity_, player._cu, player.dexterityMax_);
        this.statDisplays_[STAT_VITALITY].draw(player.vitality_, player._pP_, player.vitalityMax_);
        this.statDisplays_[STAT_WISDOM].draw(player.wisdom_, player._B_e, player.wisdomMax_);
        this.statDisplays_[STAT_LUCK].draw(player.luck_, player.stat_luck, player.stat_luckI);
        this.statDisplays_[STAT_CRITICAL].draw(player.crit_, player.stat_crit, player.stat_critI);
    }

    private function onAddedToStage(event:Event):void {
        for each (var display:StatDisplay in this.statDisplays_) {
            display.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            display.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        }
    }

    private function onRemovedFromStage(event:Event):void {
        if (this.toolTip_.parent != null) {
            this.toolTip_.parent.removeChild(this.toolTip_);
        }
        // The original re-added the listeners here (copy/paste slip); removing them is what was intended.
        for each (var display:StatDisplay in this.statDisplays_) {
            display.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            display.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        }
    }

    private function onMouseOver(event:MouseEvent):void {
        var display:StatDisplay = event.target as StatDisplay;
        this.toolTip_.setTitle(display.fullName_);
        this.toolTip_.setDescription(display.description_);
        if (!stage.contains(this.toolTip_)) {
            stage.addChild(this.toolTip_);
        }
    }

    private function onMouseOut(event:MouseEvent):void {
        if (this.toolTip_.parent != null) {
            this.toolTip_.parent.removeChild(this.toolTip_);
        }
    }
}
}

import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.text.TextFormat;

/** Abbreviation label and coloured value of one stat. Formerly the file-private class "Stat". */
class StatDisplay extends Sprite {

    private static const NORMAL_COLOR:uint = 0xB3B3B3;
    private static const MAXED_COLOR:uint = 0xFCDF00;
    private static const BAD_COLOR:uint = 0xFF3838;
    private static const BOOSTED_COLOR:uint = 0x5EB531;

    public var fullName_:String;
    public var description_:String;
    public var nameText_:SimpleText;
    public var valText_:SimpleText;
    public var redOnZero_:Boolean;
    public var val_:int = -1;
    public var boost_:int = -1;
    public var valColor_:uint = NORMAL_COLOR;

    public function StatDisplay(abbreviation:String, fullName:String, description:String, redOnZero:Boolean) {
        super();
        this.fullName_ = fullName;
        this.description_ = description;
        this.nameText_ = new SimpleText(12, NORMAL_COLOR, false, 0, 0, "Myriad Pro");
        this.nameText_.text = abbreviation;
        this.nameText_.updateMetrics();
        this.nameText_.x = -this.nameText_.width;
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.nameText_);
        this.valText_ = new SimpleText(12, this.valColor_, false, 0, 0, "Myriad Pro");
        this.valText_.setBold(true);
        this.valText_.text = "-";
        this.valText_.updateMetrics();
        this.valText_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.valText_);
        this.redOnZero_ = redOnZero;
    }

    /**
     * @param value stat value including boosts
     * @param boost bonus from equipment / effects
     * @param max   maximum of the base stat; reaching it turns the value gold
     */
    public function draw(value:int, boost:int, max:int):void {
        if (value == this.val_ && boost == this.boost_) {
            return;
        }
        this.val_ = value;
        this.boost_ = boost;
        var color:uint;
        if ((value - boost) >= max) {
            color = MAXED_COLOR;
        } else if ((this.redOnZero_ && this.val_ <= 0) || this.boost_ < 0) {
            color = BAD_COLOR;
        } else if (this.boost_ > 0) {
            color = BOOSTED_COLOR;
        } else {
            color = NORMAL_COLOR;
        }
        if (this.valColor_ != color) {
            this.valColor_ = color;
            var format:TextFormat = this.valText_.defaultTextFormat;
            format.color = this.valColor_;
            this.valText_.setTextFormat(format);
            this.valText_.defaultTextFormat = format;
        }
        this.valText_.text = this.val_.toString();
        if (this.boost_ != 0) {
            this.valText_.text = this.valText_.text + (" (" + ((this.boost_ > 0) ? "+" : "") + this.boost_.toString() + ")");
        }
        this.valText_.updateMetrics();
    }
}
