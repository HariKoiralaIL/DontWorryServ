package com.company.assembleegameclient.ui.tooltip {
import com.company.assembleegameclient.net.messages.data.StatData;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui._return;
import com.company.ui.SimpleText;
import com.company.util.BitmapUtil;
import com.company.util.KeyCodes;

import constants.ActorType;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.filters.DropShadowFilter;
import flash.text.StyleSheet;

public class EquipmentToolTip extends ToolTip {

    private static const TOOLTIP_WIDTH:int = 286;
    private static const HANGING_INDENT_CSS:String = ".in { margin-left:10px; text-indent: -10px; }";
    private static const FONT_NAME:String = "CHIP SB";
    private static const FONT_SIZE:int = 13;
    private static const EQUIP_SLOTS:int = 4;

    private static const GRAY:uint = 0xB3B3B3;
    private static const WARNING_COLOR:uint = 0xFC8642;
    private static const SEPARATOR_COLOR:uint = 0x2D2D2D;

    // Separator indices (see addSeparator)
    private static const SEP_AFTER_DESCRIPTION:int = 0;
    private static const SEP_AFTER_NAME:int = 1;
    private static const SEP_AFTER_STATS:int = 2;
    private static const SEP_AFTER_SPECIAL:int = 3;

    private var icon_:Bitmap;
    private var nameText_:SimpleText;
    private var namePrefixText_:SimpleText;
    private var tierText_:SimpleText;
    private var rank_:SimpleText;           // built in initTier but never added to the display list
    private var descriptionText_:SimpleText;
    private var level_:SimpleText;
    private var actualName_:SimpleText;
    private var statsText_:SimpleText;
    private var restrictionsText_:SimpleText;
    private var specialInfoText_:SimpleText;
    private var separators_:Array = [];

    private var player_:Player;
    private var playerHasSlot_:Boolean = false;
    private var playerCanUse_:Boolean;
    private var meetsLevel:Boolean;
    private var objectType_:int;
    private var itemXml_:XML = null;
    private var itemData_:Object;
    private var curItemXML:XML = null;
    private var curItemData:Object = null;
    private var slotHandlers_:SlotHandlerRegistry;
    private var slotData_:SlotTooltipData;
    private var restrictions_:Vector.<Restriction>;
    private var specialInfo_:Vector.<Restriction>;
    private var effects_:Vector.<Effect>;
    private var slotType_:int;
    private var containerType_:int;
    private var ownerId_:String;
    private var ownedByPlayer_:Boolean;

    public function EquipmentToolTip(objectType:int, player:Player, containerType:int, ownerId:String, stackCount:uint = 1, ownedByPlayer:Boolean = false, itemData:Object = null) {
        player_ = player;
        ownerId_ = ownerId;
        ownedByPlayer_ = ownedByPlayer;
        itemData_ = itemData;
        playerCanUse_ = player != null ? ObjectLibrary.canUseItem(objectType, player) : false;
        meetsLevel = ObjectLibrary.checkLevelRequirement(objectType, player);
        var usable:Boolean = canUseNow() || player_ == null;
        super(usable ? 0x2A2A2A : 0x551E0F, 1, usable ? 0x9B9B9B : 0xA7502F, 1, true);
        slotHandlers_ = new SlotHandlerRegistry();
        objectType_ = objectType;
        itemXml_ = ObjectLibrary.typeToXML_[objectType];
        playerHasSlot_ = player_ != null ? ObjectLibrary.fitsPlayerSlots(objectType_, player_) : false;
        effects_ = new Vector.<Effect>();
        containerType_ = containerType;
        slotType_ = int(itemXml_.SlotType);
        findCurrentItem();
        init();
    }

    public static function getIconFromValue(objectType:uint):Bitmap {
        return new Bitmap(ObjectLibrary.getRedrawnTextureFromType(objectType, 80, true));
    }

    private static function formatRestrictions(list:Vector.<Restriction>):String {
        var lines:Array = [];
        for each (var restriction:Restriction in list) {
            var line:String = '<font color="#' + restriction.color_.toString(16) + '">' + restriction.text_ + "</font>";
            if (restriction.bold_) {
                line = "<b>" + line + "</b>";
            }
            lines.push(line);
        }
        return lines.join("\n");
    }

    private static function textShadow():Array {
        return [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
    }

    // ---- setup ----

    private function canUseNow():Boolean {
        return playerCanUse_ && meetsLevel;
    }

    private function hasData(key:String):Boolean {
        return itemData_ != null && itemData_.hasOwnProperty(key);
    }

    /** Finds the item the player currently has equipped in the same slot (for stat comparison). */
    private function findCurrentItem():void {
        if (player_ == null) {
            curItemXML = itemXml_;
            curItemData = itemData_;
            return;
        }
        if (!playerHasSlot_) {
            return;
        }
        for (var i:int = 0; i < EQUIP_SLOTS; i++) {
            if (slotType_ == player_.slotTypes_[i] && player_.equipment_[i] != -1) {
                curItemXML = ObjectLibrary.typeToXML_[player_.equipment_[i]];
                curItemData = player_.equipData_[i];
                break;
            }
        }
    }

    private function init():void {
        initHead();
        initSlotData();
        initBody();
        if (descriptionText_ != null) {
            addSeparator(descriptionText_.y + descriptionText_.height + 4, SEP_AFTER_DESCRIPTION);
        }
        addStatsText();
        if (statsText_ != null) {
            addSeparator(statsText_.y + statsText_.height + 4, SEP_AFTER_STATS);
        }
        initFoot();
        addSpecialInfoText();
        if (specialInfoText_ != null) {
            addSeparator(specialInfoText_.y + specialInfoText_.height + 4, SEP_AFTER_SPECIAL);
        }
        addRestrictionsText();
    }

    private function initHead():void {
        initIcon();
        initName();
        initTier();
        initDesc();
        initActualName();
        initLevel();
    }

    private function initBody():void {
        initExtraTooltipData();
        initNumProjectiles();
        initProjectile();
        initAbility();
        initOnEquip();
        initDoses();
        initMpCost();
        initFame();
    }

    private function initFoot():void {
        initSpecialInfo();
        initRestrictions();
    }

    private function initSlotData():void {
        if (curItemXML != null) {
            slotData_ = slotHandlers_.buildData(itemXml_, curItemXML, itemData_, curItemData);
        } else {
            slotData_ = new SlotTooltipData();
        }
    }

    // ---- layout helpers ----

    private function addSeparator(lineY:int, index:int):void {
        var line:_return = new _return(TOOLTIP_WIDTH - 12, SEPARATOR_COLOR);
        line.x = 8;
        line.y = lineY;
        addChild(line);
        separators_[index] = line;
    }

    /** Y just below the lowest separator added so far. */
    private function nextBlockY():int {
        for (var i:int = separators_.length - 1; i >= 0; i--) {
            if (separators_[i] != null) {
                return separators_[i].y + 4;
            }
        }
        return 4;
    }

    private function isSlotEmpty():Boolean {
        return playerHasSlot_ && curItemXML == null;
    }

    // ---- head ----

    private function initIcon():void {
        var scale:Number = 5;
        if (itemXml_.hasOwnProperty("ScaleValue")) {
            scale = itemXml_.ScaleValue;
        }
        var bitmapData:BitmapData = ObjectLibrary.getRedrawnTextureFromType(objectType_, 60, true, true, scale);
        if (hasData("TextureFile") && itemData_.TextureFile != "") {
            bitmapData = ObjectLibrary.getRedrawnTextureFromTypeCustom(objectType_, 60, true, itemData_, true, scale);
        }
        bitmapData = BitmapUtil.crop(bitmapData, 4, 4, bitmapData.width - 8, bitmapData.height - 8);
        icon_ = new Bitmap(bitmapData);
        addChild(icon_);
    }

    private function initName():void {
        var nameColor:uint = (canUseNow() || player_ == null) ? 0xFFFFFF : WARNING_COLOR;
        if (hasData("NameColor") && itemData_.NameColor != 0xFFFFFF) {
            nameColor = int(itemData_.NameColor);
        }
        var nameWidth:int = TOOLTIP_WIDTH - icon_.width - 4 - 30;

        namePrefixText_ = new SimpleText(FONT_SIZE + 2, nameColor, false, nameWidth, 0, FONT_NAME);
        namePrefixText_.setBold(true);
        namePrefixText_.wordWrap = true;
        if (hasData("NamePrefix") && itemData_.NamePrefix != "") {
            namePrefixText_.text = itemData_.NamePrefix;
        }
        namePrefixText_.updateMetrics();
        namePrefixText_.filters = textShadow();
        namePrefixText_.x = icon_.width + 4;
        namePrefixText_.y = icon_.height / 2 - namePrefixText_._I_x / 2 - FONT_SIZE / 2;
        if (namePrefixText_.text != "") {
            addChild(namePrefixText_);
        }

        nameText_ = new SimpleText(FONT_SIZE + 2, nameColor, false, nameWidth, 0, FONT_NAME);
        nameText_.setBold(true);
        nameText_.wordWrap = true;
        nameText_.text = ObjectLibrary.typeToDisplayId_[objectType_];
        if (hasData("Name") && itemData_.Name != "") {
            nameText_.text = itemData_.Name;
        }
        nameText_.updateMetrics();
        nameText_.filters = textShadow();
        nameText_.x = icon_.width + 4;
        nameText_.y = icon_.height / 2 - nameText_._I_x / 2 + (namePrefixText_.text != "" ? FONT_SIZE / 2 : 0);
        addChild(nameText_);
    }

    private function initTier():void {
        tierText_ = new SimpleText(FONT_SIZE + 2, 0xFFFFFF, false, 30, 0, FONT_NAME);
        rank_ = new SimpleText(FONT_SIZE + 2, 0xFFFFFF, false, 30, 0, FONT_NAME);
        tierText_.y = icon_.height / 2 - nameText_._I_x / 2 - 8;
        tierText_.x = TOOLTIP_WIDTH - 28;
        rank_.y = icon_.height / 2 - nameText_._I_x / 2 + tierText_.y;
        rank_.x = TOOLTIP_WIDTH - 28;

        if (!itemXml_.hasOwnProperty("Consumable") && !itemXml_.hasOwnProperty("Material") && !isPermaPetItem()) {
            if (itemXml_.hasOwnProperty("Tier")) {
                var tier:int = int(itemXml_.Tier);
                if (tier <= 3) {
                    tierText_.setColor(0xFFFFFF);
                } else if (tier <= 7) {
                    tierText_.setColor(0xFFD700);
                } else if (tier <= 11) {
                    tierText_.setColor(0xFF12C9);
                } else {
                    tierText_.setColor(0xAB9CE1);
                }
                tierText_.text = "T" + itemXml_.Tier;
                if (tier == 33) {
                    tierText_.setColor(0xFFA500);
                    tierText_.text = "HT";
                }
            } else {
                tierText_.setColor(0x8A2BE2);
                tierText_.text = "UT";
            }
            tierText_.updateMetrics();
            addChild(tierText_);
        }
        rank_.setColor(ObjectLibrary.getItemNameColor(objectType_));
        rank_.text = ObjectLibrary.getRarity(objectType_);
        rank_.updateMetrics();
    }

    private function isPermaPetItem():Boolean {
        return itemXml_.Activate.(text() == "PermaPet").length() >= 1;
    }

    private function initDesc():void {
        descriptionText_ = new SimpleText(FONT_SIZE, GRAY, false, TOOLTIP_WIDTH, 0, FONT_NAME);
        descriptionText_.wordWrap = true;
        descriptionText_.text = String(itemXml_.Description);
        descriptionText_.updateMetrics();
        descriptionText_.filters = textShadow();
        descriptionText_.x = 4;
        descriptionText_.y = icon_.y + icon_.height;
        addChild(descriptionText_);
    }

    /** Shows the base item name when a custom name replaces it. */
    private function initActualName():void {
        actualName_ = new SimpleText(FONT_SIZE, GRAY, false, TOOLTIP_WIDTH, 0, FONT_NAME);
        actualName_.setBold(true);
        actualName_.wordWrap = true;
        if (hasData("Name") && itemData_.Name != "") {
            actualName_.text = ObjectLibrary.typeToDisplayId_[objectType_];
        } else {
            actualName_.text = "";
        }
        actualName_.x = 4;
        actualName_.y = descriptionText_.y + descriptionText_.height + 8;
        if (actualName_.text != "") {
            addChild(actualName_);
        }
    }

    private function initLevel():void {
        level_ = new SimpleText(FONT_SIZE, GRAY, false, TOOLTIP_WIDTH, 0, FONT_NAME);
        level_.setBold(true);
        level_.wordWrap = true;
        if (itemXml_.hasOwnProperty("LevelReq") && String(itemXml_.LevelReq) != "") {
            level_.text = "Level Required: " + String(itemXml_.LevelReq);
        } else {
            level_.text = "";
        }
        level_.x = 4;
        level_.y = actualName_.text != "" ? actualName_.y + actualName_.textHeight : descriptionText_.y + descriptionText_.height + 8;
        if (level_.text != "") {
            addChild(level_);
            addSeparator(level_.y + FONT_SIZE + 8, SEP_AFTER_NAME);
        } else if (actualName_.text != "") {
            addSeparator(actualName_.y + FONT_SIZE + 8, SEP_AFTER_NAME);
        }
    }

    // ---- body (effects list) ----

    private function addEffect(name:String, value:String):void {
        effects_.push(new Effect(name, value));
    }

    private function initExtraTooltipData():void {
        if (itemXml_.hasOwnProperty("ExtraTooltipData")) {
            for each (var info:XML in itemXml_.ExtraTooltipData.EffectInfo) {
                addEffect(info.attribute("name"), info.attribute("description"));
            }
        }
    }

    private function initNumProjectiles():void {
        if (itemXml_.hasOwnProperty("NumProjectiles") && !slotData_.handledXml.hasOwnProperty(itemXml_.NumProjectiles.toXMLString())) {
            addEffect("Number of Shots", itemXml_.NumProjectiles);
        }
    }

    private function initProjectile():void {
        if (!itemXml_.hasOwnProperty("Projectile") || slotData_.handledXml.hasOwnProperty(itemXml_.Projectile.toXMLString())) {
            return;
        }
        var projectile:XML = XML(itemXml_.Projectile);
        var minDamage:int = int(projectile.MinDamage);
        var maxDamage:int = int(projectile.MaxDamage);
        var customMin:int = hasData("MinDamage") ? int(itemData_.MinDamage) : 0;
        var customMax:int = hasData("MaxDamage") ? int(itemData_.MaxDamage) : 0;
        var damageNote:String = customDamageNote(customMin, customMax);
        minDamage += customMin;
        maxDamage += customMax;

        var hasMultiplier:Boolean = false;
        var percent:int = 0;
        if (hasData("DmgPercentage") && itemData_.DmgPercentage != 0) {
            hasMultiplier = true;
            percent = int(itemData_.DmgPercentage);
            minDamage += minDamage * (percent / 100);
            maxDamage += maxDamage * (percent / 100);
        }
        addEffect("Attack Damage", (minDamage == maxDamage ? minDamage : minDamage + " - " + maxDamage).toString() + damageNote);
        if (hasMultiplier) {
            addEffect("Damage Multiplier", (percent < 0 ? "-" : "+") + percent.toString() + "%");
        }

        var range:Number = Number(projectile.Speed) * Number(projectile.LifetimeMS) / 10000;
        addEffect("Projectile Range", TooltipText.formatNumber(range));
        if (itemXml_.Projectile.hasOwnProperty("MultiHit")) {
            addEffect("", "Shots hit multiple targets");
        }
        if (itemXml_.Projectile.hasOwnProperty("PassesCover")) {
            addEffect("", "Shots pass through obstacles");
        }
        for each (var condition:XML in projectile.ConditionEffect) {
            if (slotData_.handledXml[condition.toXMLString()] == null) {
                addEffect("Projectile Effect", itemXml_.Projectile.ConditionEffect + " for " + itemXml_.Projectile.ConditionEffect.@duration + " secs");
            }
        }
    }

    private function customDamageNote(customMin:int, customMax:int):String {
        if (customMin != 0 && customMax != 0) {
            return damageNote((customMin > 0 || customMax > 0) ? "1CABFF" : "FF6863",
                    (customMin > 0 ? "+" : "-") + customMin + "-" + customMax + " DMG");
        }
        if (customMin != 0) {
            return damageNote(customMin > 0 ? "1CABFF" : "FF6863", (customMin > 0 ? "+" : "-") + customMin + " Minimum DMG");
        }
        if (customMax != 0) {
            return damageNote(customMax > 0 ? "1CABFF" : "FF6863", (customMax > 0 ? "+" : "-") + customMax + " Maximum DMG");
        }
        return "";
    }

    private function damageNote(color:String, text:String):String {
        return ' <font color="#' + color + '">(' + text + ")</font>";
    }

    private function initAbility():void {
        for each (var xml:XML in itemXml_.Activate) {
            if (slotData_.handledXml[xml.toXMLString()] == true) {
                continue;
            }
            switch (xml.toString()) {
                case "ConditionEffectAura":
                    addEffect("Party Effect", "Within " + xml.@range + " sqrs");
                    addEffect("", "  " + xml.@effect + " for " + xml.@duration + " secs");
                    break;
                case "ConditionEffectSelf":
                    addEffect("Effect on Self", "");
                    addEffect("", "  " + xml.@effect + " for " + xml.@duration + " secs");
                    break;
                case "Heal":
                    addEffect("", "+" + xml.@amount + " HP");
                    break;
                case "HealNova":
                    addEffect("Party Heal", xml.@amount + " HP at " + xml.@range + " sqrs");
                    break;
                case "Magic":
                    addEffect("", "+" + xml.@amount + " MP");
                    break;
                case "MagicNova":
                    addEffect("Fill Party Magic", xml.@amount + " MP at " + xml.@range + " sqrs");
                    break;
                case "Teleport":
                    addEffect("", "Teleport to Target");
                    break;
                case "VampireBlast":
                    addEffect("Steal", xml.@totalDamage + " HP within " + xml.@radius + " sqrs");
                    break;
                case "Trap":
                    addEffect("Trap", xml.@totalDamage + " HP within " + xml.@radius + " sqrs");
                    addEffect("", "  " + (xml.hasOwnProperty("@condEffect") ? xml.@condEffect : "Slowed")
                            + " for " + (xml.hasOwnProperty("@condDuration") ? xml.@condDuration : "5") + " secs");
                    break;
                case "StasisBlast":
                    addEffect("Stasis on Group", xml.@duration + " secs");
                    break;
                case "Decoy":
                    addEffect("Decoy", xml.@duration + " secs");
                    break;
                case "Lightning":
                    addEffect("Lightning", "");
                    addEffect("", " " + xml.@totalDamage + " to " + xml.@maxTargets + " targets");
                    break;
                case "PoisonGrenade":
                    addEffect("Poison Grenade", "");
                    addEffect("", " " + xml.@totalDamage + " HP over " + xml.@duration + " secs within " + xml.@radius + " sqrs\n");
                    break;
                case "RemoveNegativeConditions":
                case "RemoveNegativeConditionsSelf":
                    addEffect("", "Removes negative conditions");
                    break;
                case "IncrementStat":
                    var stat:int = int(xml.@stat);
                    var amount:int = int(xml.@amount);
                    if (stat != StatData.HP_STAT && stat != StatData.MP_STAT) {
                        addEffect("", "Permanently increases " + StatData.statToName(stat));
                    } else {
                        addEffect("", "+" + amount + " " + StatData.statToName(stat));
                    }
                    break;
                case "OpenCrate":
                    addEffect("", "Opens a crate");
                    break;
            }
        }
    }

    private function initOnEquip():void {
        var first:Boolean = true;
        for each (var xml:XML in itemXml_.ActivateOnEquip) {
            if (first) {
                addEffect("On Equip", "");
                first = false;
            }
            var text:String = slotData_.onEquipText[xml.toXMLString()];
            if (text != null) {
                addEffect("", text);
            } else if (xml.toString() == "IncrementStat") {
                addEffect("", statLine(xml));
            }
        }
    }

    private function statLine(xml:XML):String {
        var stat:int = int(xml.@stat);
        var amount:int = int(xml.@amount);
        var sign:String = amount > -1 ? "+" : "";
        return '<font color="' + statColor(xml) + '">' + sign + String(amount) + " " + StatData.statToName(stat) + "</font>";
    }

    private function statColor(activateXML:XML):String {
        var stat:int = int(activateXML.@stat);
        var amount:int = int(activateXML.@amount);
        var color:String = canUseNow() ? "#00FF00" : "#FFFF8F";
        var otherMatches:XMLList;
        if (curItemXML != null) {
            otherMatches = curItemXML.ActivateOnEquip.(@stat == stat);
        }
        if (otherMatches != null && otherMatches.length() == 1) {
            color = TooltipText.compareColor(amount - int(XML(otherMatches[0]).@amount));
        }
        if (amount < 0) {
            color = "#FF0000";
        }
        return color;
    }

    private function initDoses():void {
        if (itemXml_.hasOwnProperty("Doses")) {
            addEffect("Doses", itemXml_.Doses);
        }
    }

    private function initMpCost():void {
        if (itemXml_.hasOwnProperty("MpCost") && !slotData_.handledXml[itemXml_.MpCost[0].toXMLString()]) {
            if (itemXml_.hasOwnProperty("MpEndCost")) {
                addEffect("MP Cost", itemXml_.MpEndCost);
            } else {
                addEffect("MP Cost", itemXml_.MpCost);
            }
        }
    }

    private function initFame():void {
        if (!itemXml_.hasOwnProperty("FameBonus")) {
            return;
        }
        var bonus:int = int(itemXml_.FameBonus);
        var color:String = canUseNow() ? TooltipText.GREEN : TooltipText.YELLOW;
        if (curItemXML != null && curItemXML.hasOwnProperty("FameBonus")) {
            color = TooltipText.compareColor(bonus - int(curItemXML.FameBonus.text()));
        }
        addEffect("Fame Bonus", TooltipText.colorize(bonus + "%", color));
    }

    private function addStatsText():void {
        if (effects_.length == 0 && slotData_.text == "") {
            return;
        }
        statsText_ = new SimpleText(FONT_SIZE, GRAY, false, TOOLTIP_WIDTH - 4, 0, FONT_NAME);
        statsText_.wordWrap = true;
        statsText_.htmlText = slotData_.text + effectsToHtml(effects_);
        statsText_._08S_();
        statsText_.filters = textShadow();
        statsText_.x = 4;
        statsText_.y = nextBlockY();
        addChild(statsText_);
    }

    private function effectsToHtml(list:Vector.<Effect>):String {
        var valueColor:String = isSlotEmpty() ? "#00ff00" : "#FFFF8F";
        var lines:Array = [];
        for each (var effect:Effect in list) {
            var line:String = effect.name_ != "" ? effect.name_ + ": " : "";
            lines.push(line + '<font color="' + valueColor + '">' + effect.value_ + "</font>");
        }
        return lines.join("\n");
    }

    // ---- foot (special info + restrictions) ----

    private function initSpecialInfo():void {
        specialInfo_ = new Vector.<Restriction>();
        if (hasData("Strange") && Boolean(itemData_.Strange)) {
            if (itemData_.hasOwnProperty("Kills")) {
                addSpecialInfo("Kills: " + int(itemData_.Kills).toString(), GRAY, false);
            }
            if (itemData_.hasOwnProperty("StrangeParts")) {
                var parts:Object = itemData_.StrangeParts;
                for (var key:Object in parts) {
                    addSpecialInfo(key + ": " + parts[key], GRAY, false);
                }
            }
        }
        if (hasData("Effect") && itemData_.Effect != "") {
            addSpecialInfo("Effect: " + itemData_.Effect, GRAY, false);
        }
        if (itemXml_.hasOwnProperty("Material") && containerType_ != ObjectLibrary.idToType_["Crafting Station"]) {
            addSpecialInfo("Crafting Material", WARNING_COLOR, true);
        }
        if (itemXml_.hasOwnProperty("Soulbound") || (hasData("Soulbound") && itemData_.Soulbound == true)) {
            addSpecialInfo("Soulbound", 0xB141FF, false);
        }
    }

    private function addSpecialInfo(text:String, color:uint, bold:Boolean):void {
        specialInfo_.push(new Restriction(text, color, bold));
    }

    private function addRestriction(text:String, color:uint, bold:Boolean):void {
        restrictions_.push(new Restriction(text, color, bold));
    }

    private function initRestrictions():void {
        restrictions_ = new Vector.<Restriction>();
        var multiUse:Boolean = hasData("MultiUse") && Boolean(itemData_.MultiUse);
        if ((itemXml_.hasOwnProperty("VaultItem") || multiUse) && containerType_ != -1 && containerType_ != ObjectLibrary.idToType_["Vault Chest"]) {
            addRestriction("Store this item in your Vault to avoid losing it!", WARNING_COLOR, true);
        }
        if (itemXml_.hasOwnProperty("HalloweenItem")) {
            addRestriction("This item is a Halloween special drop!", 0xFFA500, true);
        }
        if (canUseNow()) {
            if (itemXml_.hasOwnProperty("Usable")) {
                addUseKeyHint();
                addEquipHints();
            } else if (itemXml_.hasOwnProperty("Consumable") && !multiUse) {
                addConsumableHints();
            } else if (itemXml_.hasOwnProperty("InvUse") || multiUse) {
                addMultiUseHints();
            } else {
                addEquipHints();
            }
        } else if (player_ != null && !playerCanUse_) {
            addRestriction("Not usable by " + ObjectLibrary.typeToDisplayId_[player_.objectType_], WARNING_COLOR, true);
        }
        var classes:Vector.<String> = ObjectLibrary.usableByClasses(objectType_);
        if (classes != null) {
            addRestriction("Usable by: " + classes.join(", "), GRAY, false);
        }
        for each (var requirement:XML in itemXml_.EquipRequirement) {
            var met:Boolean = ObjectLibrary.checkEquipRequirement(requirement, player_);
            if (requirement.toString() == "Stat") {
                addRestriction("Requires " + StatData.statToName(int(requirement.@stat)) + " of " + int(requirement.@value),
                        met ? GRAY : WARNING_COLOR, !met);
            }
        }
    }

    private function addEquipHints():void {
        addRestriction("Must be equipped to use", GRAY, false);
        if (ownedByPlayer_ || ownerId_ == ActorType.CURRENT_PLAYER) {
            addRestriction("Double-Click to equip", GRAY, false);
        } else {
            addRestriction("Double-Click to take", GRAY, false);
        }
    }

    private function addUseKeyHint():void {
        addRestriction("Press [" + KeyCodes.KEY_NAMES[Parameters.data_.useSpecial] + "] in world to use", 0xFFFFFF, false);
    }

    private function addConsumableHints():void {
        addRestriction("Consumed with use", GRAY, false);
        if (ownedByPlayer_ || ownerId_ == ActorType.CURRENT_PLAYER) {
            addRestriction("Double-Click or Shift-Click on item to use", 0xFFFFFF, false);
        } else {
            addRestriction("Double-Click to take & Shift-Click to use", 0xFFFFFF, false);
        }
    }

    private function addMultiUseHints():void {
        addRestriction("Can be used multiple times", GRAY, false);
        addRestriction("Double-Click or Shift-Click on item to use", 0xFFFFFF, false);
    }

    private function addSpecialInfoText():void {
        if (specialInfo_.length == 0) {
            return;
        }
        specialInfoText_ = createHangingText(formatRestrictions(specialInfo_));
        specialInfoText_.y = nextBlockY();
        addChild(specialInfoText_);
    }

    private function addRestrictionsText():void {
        if (restrictions_.length == 0) {
            return;
        }
        restrictionsText_ = createHangingText(formatRestrictions(restrictions_));
        restrictionsText_.y = nextBlockY();
        addChild(restrictionsText_);
    }

    private function createHangingText(html:String):SimpleText {
        var styleSheet:StyleSheet = new StyleSheet();
        styleSheet.parseCSS(HANGING_INDENT_CSS);
        var text:SimpleText = new SimpleText(FONT_SIZE, GRAY, false, TOOLTIP_WIDTH - 4, 0, FONT_NAME);
        text.styleSheet = styleSheet;
        text.wordWrap = true;
        text.htmlText = "<span class='in'>" + html + "</span>";
        text._08S_();
        text.filters = textShadow();
        text.x = 4;
        return text;
    }

}
}

class Effect {

    public var name_:String;
    public var value_:String;

    public function Effect(name:String, value:String) {
        name_ = name;
        value_ = value;
    }

}

class Restriction {

    public var text_:String;
    public var color_:uint;
    public var bold_:Boolean;

    public function Restriction(text:String, color:uint, bold:Boolean) {
        text_ = text;
        color_ = color;
        bold_ = bold;
    }

}
