// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.EquipmentToolTip

package com.company.assembleegameclient.ui.tooltip {


  import _ke._U_c;

  import com.company.assembleegameclient.net.messages.data.StatData;
  import com.company.assembleegameclient.objects.GameObject;
  import com.company.assembleegameclient.objects.GameObject;
  import com.company.assembleegameclient.objects.ObjectLibrary;
  import com.company.assembleegameclient.objects.Player;
  import com.company.assembleegameclient.parameters.Parameters;
  import com.company.assembleegameclient.ui._return;
  import com.company.ui.SimpleText;
  import com.company.util.BitmapUtil;
  import com.company.util._H_V_;
  import com.hurlant.util.der.Integer;

  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.filters.DropShadowFilter;
  import flash.text.StyleSheet;
  import flash.utils.Dictionary;

  import flashx.textLayout.formats.Float;

  public class EquipmentToolTip extends ToolTip {

    private static const TOOLTIP_WIDTH:int = 286;
    private static const HANGING_INDENT_CSS:String = ".in { margin-left:10px; text-indent: -10px; }";
    private static const fontName:String = "CHIP SB";
    private static const fontSize:int = 13;

    private static function restrictionsToHtml(_arg1:Vector.<Restriction>):String {
      var restriction:Restriction;
      var _local5:String;
      var _local2:String = "";
      var _local3:Boolean = true;
      for each (restriction in _arg1) {
        if (!_local3) {
          _local2 = (_local2 + "\n");
        } else {
          _local3 = false;
        }
        _local5 = (((('<font color="#' + restriction.color_.toString(16)) + '">') + restriction.text_) + "</font>");
        if (restriction.bold_) {
          _local5 = (("<b>" + _local5) + "</b>");
        }
        _local2 = (_local2 + _local5);
      }
      return (_local2);
    }

    public function EquipmentToolTip(_arg1:int, player:Player, containerType:int, ownerId:String, stackCount:uint = 1, ownedByPlayer:Boolean = false, itemData:Object = null) {
      var _local9:uint;
      this.player_ = player;
      this.ownerId_ = ownerId;
      this.stackCount_ = stackCount;
      this.ownedByPlayer_ = ownedByPlayer;
      this.itemData_ = itemData;
      this.playerCanUse_ = (player != null ? ObjectLibrary._d1(_arg1, player) : false);
      this.meetsLevel = ObjectLibrary.checkLevelRequirement(_arg1, player);
      var _local7:uint = ((((this.playerCanUse_ && this.meetsLevel) || ((this.player_ == null)))) ? 0x2A2A2A : 5578255);
      var _local8:uint = ((((this.playerCanUse_ && this.meetsLevel) || ((player == null)))) ? 0x9B9B9B : 10965039);
      super(_local7, 1, _local8, 1, true);
      this.slotHandlers_ = new SlotHandlers();
      this.objectType_ = _arg1;
      this.itemXml_ = ObjectLibrary._Q_F_[_arg1];
      this.playerHasSlot_ = this.player_ != null ? ObjectLibrary._01j(this.objectType_, this.player_) : false;
      this.effects_ = new Vector.<Effect>();
      this.containerType_ = containerType;
      this.slotType_ = int(this.itemXml_.SlotType);
      if (this.player_ == null) {
        this.curItemXML = this.itemXml_;
        this.curItemData = this.itemData_;
      } else {
        if (this.playerHasSlot_) {
          _local9 = 0;
          while (_local9 < 4) {
            if ((((this.slotType_ == this.player_._9A_[_local9])) && (!((this.player_.equipment_[_local9] == -1))))) {
              this.curItemXML = ObjectLibrary._Q_F_[this.player_.equipment_[_local9]];
              this.curItemData = this.player_.equipData_[_local9];
              break;
            }
            _local9++;
          }
        }
      }
      this.init();
    }
    private var icon_:Bitmap;
    private var nameText_:SimpleText;
    private var namePrefixText_:SimpleText;
    private var tierText_:SimpleText;
    private var rank_:SimpleText;
    private var descriptionText_:SimpleText;
    private var level_:SimpleText;
    private var actualName_:SimpleText;
    private var line_:_return;
    private var line1_:_return;
    private var line2_:_return;
    private var line3_:_return;
    private var statsText_:SimpleText;
    private var restrictionsText_:SimpleText;
    private var specialInfoText_:SimpleText;
    private var player_:Player;
    private var playerHasSlot_:Boolean = false;
    private var objectType_:int;
    private var curItemXML:XML = null;
    private var curItemData:Object = null;
    private var itemXml_:XML = null;
    private var slotHandlers_:SlotHandlers;
    private var playerCanUse_:Boolean;
    private var meetsLevel:Boolean;
    private var restrictions_:Vector.<Restriction>;
    private var specialInfo_:Vector.<Restriction>;
    private var effects_:Vector.<Effect>;
    private var slotType_:int;
    private var containerType_:int;
    private var ownerId_:String;
    private var stackCount_:uint;
    private var ownedByPlayer_:Boolean;
    private var nextY_:int;
    private var slotData_:SlotTooltipData;
    private var itemData_:Object;

    private var lineNum:int;
    private var lineArray:Array;

    private function init():void {
      this.initHead();
      this.setData(); // ??
      this.initBody();
      if (this.descriptionText_ != null) this.addLine(((this.descriptionText_.y + this.descriptionText_.height) + 4), 0); // Separator 1 ((Under Icon))
      this.addElem(); // Add Body Elements (Item Stats)
      if (this.statsText_ != null) this.addLine(((this.statsText_.y + this.statsText_.height) + 4), 2); // Separator 2 ((Under Info))
      this.initFoot();
      this.addElem3(); // Add Foot Elements (Restrictions)
      if (this.specialInfoText_ != null) this.addLine(((this.specialInfoText_.y + this.specialInfoText_.height) + 4), 3); // Separator 3 ((Under Special Info))
      this.addElem2(); // Add Head Elements (Restrictions)
    }

    private function initHead():void {
      this.initIcon(); // Icon
      this.initName(); // Name - Color - Prefix
      this.initTier(); // Tier
      this.initDesc(); // Description
      this.initActualName();
      this.initLevel();
    }
    private function initBody():void {
      this.extraToolData_(); // Extra Tooltip Data ((Shurikens))
      this.initProjs(); // NumProjectiles ((Shots))
      this.initBase(); // Projectile - Damage - Range - Shot Effect
      this.initAbility(); // Ability Type
      this.initStats(); // On Equip
      this.initDoses(); // Doses
      this.initMpCost(); // MP Cost
      this.initFame(); // Fame Bonus
    }
    private function initFoot():void {
      this.initSInfo();
      this.initInfo(); // Item Type - Level Requirement
    }

    private function extraToolData_():void {
      var xmlList:XMLList;
      var xml:XML;
      if (this.itemXml_.hasOwnProperty("ExtraTooltipData")) {
        xmlList = this.itemXml_.ExtraTooltipData.EffectInfo;
        for each (xml in xmlList) {
          this.effects_.push(new Effect(xml.attribute("name"), xml.attribute("description")));
        }
      }
    }

    private function isSlotEmpty():Boolean {
      return (((this.playerHasSlot_) && ((this.curItemXML == null))));
    }

    public static function getIconFromValue(_arg1:uint):Bitmap{
      return (new Bitmap(ObjectLibrary.getRedrawnTextureFromType(_arg1, 80, true)));
    }

    private function initIcon():void {
      var xml:XML = ObjectLibrary._Q_F_[this.objectType_];
      var _local2:Number = 5;
      if (xml.hasOwnProperty("ScaleValue")) {
        _local2 = xml.ScaleValue;
      }
      var bitmapData:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.objectType_, 60, true, true, _local2);
      if(this.itemData_ != null && this.itemData_.hasOwnProperty("TextureFile") && this.itemData_.TextureFile != "") {
        bitmapData = ObjectLibrary.getRedrawnTextureFromTypeCustom(this.objectType_, 60, true, this.itemData_, true, _local2);
      }
      bitmapData = BitmapUtil._Y_d(bitmapData, 4, 4, (bitmapData.width - 8), (bitmapData.height - 8));
      this.icon_ = new Bitmap(bitmapData);
      addChild(this.icon_);
    }

    private function initTier():void {
      this.tierText_ = new SimpleText(fontSize + 2, 0xFFFFFF, false, 30, 0, fontName);
      this.rank_ = new SimpleText(fontSize + 2, 0xFFFFFF, false, 30, 0, fontName);
      this.nameText_.setBold(true);
      this.tierText_.y = ((this.icon_.height / 2) - (this.nameText_._I_x / 2) - 8);
      this.tierText_.x = (TOOLTIP_WIDTH - 28);
      this.rank_.y = ((this.icon_.height / 2) - (this.nameText_._I_x / 2) + this.tierText_.y);
      this.rank_.x = (TOOLTIP_WIDTH - 28);
      if (this.itemXml_.hasOwnProperty("Consumable") == false && this.itemXml_.hasOwnProperty("Material") == false && this.isPermaPetItem() == false) {
        if (this.itemXml_.hasOwnProperty("Tier")) {
          if (int(this.itemXml_.Tier).valueOf() <= 3)
            this.tierText_.setColor(0xFFFFFF);
          else if (int(this.itemXml_.Tier).valueOf() <= 7)
            this.tierText_.setColor(0xFFD700);
          else if (int(this.itemXml_.Tier).valueOf() <= 11)
            this.tierText_.setColor(0xFF12C9);
          else
            this.tierText_.setColor(0xAB9CE1);
          this.tierText_.text = ("T" + this.itemXml_.Tier);
          if (int(this.itemXml_.Tier).valueOf() == 33)
          {
            this.tierText_.setColor(0xFFA500);
            this.tierText_.text = "HT";
          }
        } else {
          this.tierText_.setColor(9055202);
          this.tierText_.text = "UT";
        }
        this.tierText_.updateMetrics();
        addChild(this.tierText_);
      }
      this.rank_.setColor(ObjectLibrary.getItemNameColor(this.objectType_));
      this.rank_.text = ObjectLibrary.getRarity(this.objectType_);
      this.rank_.updateMetrics();
    }

    private function isPermaPetItem():Boolean {
      var activateTags:XMLList;
      activateTags = this.itemXml_.Activate.(text() == "PermaPet");
      return ((activateTags.length() >= 1));
    }

    private function initName():void {
      var _local1:int = ((this.playerCanUse_ && this.meetsLevel) || this.player_ == null) ? 0xFFFFFF : 16549442;
      if(this.itemData_ != null && this.itemData_.hasOwnProperty("NameColor") && this.itemData_.NameColor != 0xFFFFFF) {
        _local1 = int(this.itemData_.NameColor);
      }
      this.namePrefixText_ = new SimpleText(fontSize + 2, _local1, false, (((TOOLTIP_WIDTH - this.icon_.width) - 4) - 30), 0, fontName);
      this.namePrefixText_.setBold(true);
      this.namePrefixText_.wordWrap = true;
      if(this.itemData_ != null && this.itemData_.hasOwnProperty("NamePrefix") && this.itemData_.NamePrefix != "") {
        this.namePrefixText_.text = this.itemData_.NamePrefix;
      }
      this.namePrefixText_.updateMetrics();
      this.namePrefixText_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
      this.namePrefixText_.x = (this.icon_.width + 4);
      this.namePrefixText_.y = ((this.icon_.height / 2) - (this.namePrefixText_._I_x / 2) - (fontSize / 2));
      if (this.namePrefixText_.text != "") addChild(this.namePrefixText_);
      this.nameText_ = new SimpleText(fontSize + 2, _local1, false, (((TOOLTIP_WIDTH - this.icon_.width) - 4) - 30), 0, fontName);
      this.nameText_.setBold(true);
      this.nameText_.wordWrap = true;
      this.nameText_.text = ObjectLibrary._0D_N_[this.objectType_];
      if(this.itemData_ != null && this.itemData_.hasOwnProperty("Name") && this.itemData_.Name != "") {
        this.nameText_.text = this.itemData_.Name;
      }
      this.nameText_.updateMetrics();
      this.nameText_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
      this.nameText_.x = (this.icon_.width + 4);
      this.nameText_.y = ((this.icon_.height / 2) - (this.nameText_._I_x / 2) + ((this.namePrefixText_.text != "") ? (fontSize / 2) : 0));
      addChild(this.nameText_);
    }

    private function addLine(_arg1:int, lineIndex:int):void {
      switch (lineIndex) {
        case 0:
          this.line_ = new _return((TOOLTIP_WIDTH - 12), 0x2D2D2D);
          this.line_.x = 8;
          this.line_.y = _arg1;
          addChild(this.line_);
          return;
        case 1:
          this.line1_ = new _return((TOOLTIP_WIDTH - 12), 0x2D2D2D);
          this.line1_.x = 8;
          this.line1_.y = _arg1;
          addChild(this.line1_);
          return;
        case 2:
          this.line2_ = new _return((TOOLTIP_WIDTH - 12), 0x2D2D2D);
          this.line2_.x = 8;
          this.line2_.y = _arg1;
          addChild(this.line2_);
          return;
        case 3:
          this.line3_ = new _return((TOOLTIP_WIDTH - 12), 0x2D2D2D);
          this.line3_.x = 8;
          this.line3_.y = _arg1;
          addChild(this.line3_);
          return;
      }
    }

    private function addElem():void {
      //this.nextY_ = ((this.descriptionText_.y + this.descriptionText_.height) + 8);
      if (((!((this.effects_.length == 0))) || (!((this.slotData_.text == ""))))) {
        /*this.line1_ = new _return((TOOLTIP_WIDTH - 12), 0x2D2D2D);
         this.line1_.x = 8;
         this.line1_.y = this.nextY_;
         addChild(this.line1_);*/
        this.statsText_ = new SimpleText(fontSize, 0xB3B3B3, false, ((TOOLTIP_WIDTH - 4)), 0, fontName);
        this.statsText_.wordWrap = true;
        this.statsText_.htmlText = (this.slotData_.text + this.effectsToHtml(this.effects_));
        this.statsText_._08S_();
        this.statsText_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        this.statsText_.x = 4;
        this.statsText_.y = (this.level_.text != "" || this.actualName_.text != "") ? (this.line1_.y + 4) : (this.line_.y + 4);
        addChild(this.statsText_);
        //this.nextY_ = ((this.statsText_.y + this.statsText_.height) + 8);
      }
    }

    private function initProjs():void {
      if (((this.itemXml_.hasOwnProperty("NumProjectiles")) && (!((this.slotData_._5n.hasOwnProperty(this.itemXml_.NumProjectiles.toXMLString()) == true))))) {
        this.effects_.push(new Effect("Number of Shots", this.itemXml_.NumProjectiles));
      }
    }

    private function initFame():void {
      var _local1:int;
      var _local2:String;
      var _local3:String;
      var _local4:int;
      if (this.itemXml_.hasOwnProperty("FameBonus")) {
        _local1 = int(this.itemXml_.FameBonus);
        _local2 = (_local1 + "%");
        _local3 = ((this.playerCanUse_ && this.meetsLevel) ? TooltipText._rJ_ : TooltipText._iF_);
        if (((!((this.curItemXML == null))) && (this.curItemXML.hasOwnProperty("FameBonus")))) {
          _local4 = int(this.curItemXML.FameBonus.text());
          _local3 = TooltipText._qy((_local1 - _local4));
        }
        this.effects_.push(new Effect("Fame Bonus", TooltipText.colorize(_local2, _local3)));
      }
    }

    private function initMpCost():void {
      if (this.itemXml_.hasOwnProperty("MpCost") && !this.slotData_._5n[this.itemXml_.MpCost[0].toXMLString()]) {
        if (this.itemXml_.hasOwnProperty("MpEndCost"))
          this.effects_.push(new Effect("MP Cost", this.itemXml_.MpEndCost));
        else
          this.effects_.push(new Effect("MP Cost", this.itemXml_.MpCost));
      }
    }

    private function initDoses():void {
      if (this.itemXml_.hasOwnProperty("Doses")) {
        this.effects_.push(new Effect("Doses", this.itemXml_.Doses));
      }
    }

    private function initBase():void {
      var xml:XML;
      var _local2:int;
      var _local3:int;
      var _local4:Number;
      var xml2:XML;
      var _local6:Boolean;
      var _local7:int;
      if (((this.itemXml_.hasOwnProperty("Projectile")) && ((this.slotData_._5n.hasOwnProperty(this.itemXml_.Projectile.toXMLString()) == false)))) {
        xml = XML(this.itemXml_.Projectile);
        _local2 = int(xml.MinDamage);
        _local3 = int(xml.MaxDamage);
        _local6 = false;
        var customMin:int = (this.itemData_ != null && this.itemData_.hasOwnProperty("MinDamage")) ? int(this.itemData_.MinDamage) : 0;
        var customMax:int = (this.itemData_ != null && this.itemData_.hasOwnProperty("MaxDamage")) ? int(this.itemData_.MaxDamage) : 0;
        var addString:String = (customMin != 0 && customMax != 0) ? " <font color=\"#" + (customMin > 0 || customMax > 0 ? "1CABFF" : "FF6863") + "\">(" + (customMin > 0 ? "+" : "-") + customMin + "-" + customMax + " DMG)</font>"
            : customMin != 0 ? " <font color=\"#" + (customMin > 0 ? "1CABFF" : "FF6863") + "\">(" + (customMin > 0 ? "+" : "-") + customMin + " Minimum DMG)</font>"
                : customMax != 0 ? " <font color=\"#" + (customMax > 0 ? "1CABFF" : "FF6863") + "\">(" + (customMax > 0 ? "+" : "-") + customMax + " Maximum DMG)</font>"
                    : "";
        _local2 += customMin;
        _local3 += customMax;
        if(this.itemData_ != null && this.itemData_.hasOwnProperty("DmgPercentage") && this.itemData_.DmgPercentage != 0) {
          _local6 = true;
          _local7 = int(this.itemData_.DmgPercentage);
          _local2 += (_local2 * (_local7 / 100));
          _local3 += (_local3 * (_local7 / 100));
        }
        this.effects_.push(new Effect("Attack Damage", (_local2 == _local3 ? _local2 : _local2 + " - " + _local3).toString() + addString));
        if(_local6) {
          this.effects_.push(new Effect("Damage Multiplier", (_local7 < 0 ? "-" : "+") + _local7.toString() + "%"));
        }
        _local4 = ((Number(xml.Speed) * Number(xml.LifetimeMS)) / 10000);
        this.effects_.push(new Effect("Projectile Range", TooltipText.formatNumber(_local4)));
        if (this.itemXml_.Projectile.hasOwnProperty("MultiHit")) {
          this.effects_.push(new Effect("", "Shots hit multiple targets"));
        }
        if (this.itemXml_.Projectile.hasOwnProperty("PassesCover")) {
          this.effects_.push(new Effect("", "Shots pass through obstacles"));
        }
        for each (xml2 in xml.ConditionEffect) {
          if (this.slotData_._5n[xml2.toXMLString()] == null) {
            this.effects_.push(new Effect("Projectile Effect", (((this.itemXml_.Projectile.ConditionEffect + " for ") + this.itemXml_.Projectile.ConditionEffect.@duration) + " secs")));
          }
        }
      }
    }

    private function initAbility():void {
      var xml:XML;
      var _local2:String;
      var _local3:int;
      var _local4:int;
      for each (xml in this.itemXml_.Activate) {
        if (this.slotData_._5n[xml.toXMLString()] != true) {
          var _local6:String = xml.toString();
          switch (_local6) {
            case "ConditionEffectAura":
              this.effects_.push(new Effect("Party Effect", (("Within " + xml.@range) + " sqrs")));
              this.effects_.push(new Effect("", (((("  " + xml.@effect) + " for ") + xml.@duration) + " secs")));
              break;
            case "ConditionEffectSelf":
              this.effects_.push(new Effect("Effect on Self", ""));
              this.effects_.push(new Effect("", (((("  " + xml.@effect) + " for ") + xml.@duration) + " secs")));
              break;
            case "Heal":
              this.effects_.push(new Effect("", (("+" + xml.@amount) + " HP")));
              break;
            case "HealNova":
              this.effects_.push(new Effect("Party Heal", (((xml.@amount + " HP at ") + xml.@range) + " sqrs")));
              break;
            case "Magic":
              this.effects_.push(new Effect("", (("+" + xml.@amount) + " MP")));
              break;
            case "MagicNova":
              this.effects_.push(new Effect("Fill Party Magic", (((xml.@amount + " MP at ") + xml.@range) + " sqrs")));
              break;
            case "Teleport":
              this.effects_.push(new Effect("", "Teleport to Target"));
              break;
            case "VampireBlast":
              this.effects_.push(new Effect("Steal", (((xml.@totalDamage + " HP within ") + xml.@radius) + " sqrs")));
              break;
            case "Trap":
              this.effects_.push(new Effect("Trap", (((xml.@totalDamage + " HP within ") + xml.@radius) + " sqrs")));
              this.effects_.push(new Effect("", (((("  " + ((xml.hasOwnProperty("@condEffect")) ? xml.@condEffect : "Slowed")) + " for ") + ((xml.hasOwnProperty("@condDuration")) ? xml.@condDuration : "5")) + " secs")));
              break;
            case "StasisBlast":
              this.effects_.push(new Effect("Stasis on Group", (xml.@duration + " secs")));
              break;
            case "Decoy":
              this.effects_.push(new Effect("Decoy", (xml.@duration + " secs")));
              break;
            case "Lightning":
              this.effects_.push(new Effect("Lightning", ""));
              this.effects_.push(new Effect("", ((((" " + xml.@totalDamage) + " to ") + xml.@maxTargets) + " targets")));
              break;
            case "PoisonGrenade":
              this.effects_.push(new Effect("Poison Grenade", ""));
              this.effects_.push(new Effect("", ((((((" " + xml.@totalDamage) + " HP over ") + xml.@duration) + " secs within ") + xml.@radius) + " sqrs\n")));
              break;
            case "RemoveNegativeConditions":
              this.effects_.push(new Effect("", "Removes negative conditions"));
              break;
            case "RemoveNegativeConditionsSelf":
              this.effects_.push(new Effect("", "Removes negative conditions"));
              break;
            case "IncrementStat":
              _local3 = int(xml.@stat);
              _local4 = int(xml.@amount);
              if (((!((_local3 == StatData._V_A_))) && (!((_local3 == StatData._aC_))))) {
                _local2 = ("Permanently increases " + StatData._W_H_(_local3));
              } else {
                _local2 = ((("+" + _local4) + " ") + StatData._W_H_(_local3));
              }
              this.effects_.push(new Effect("", _local2));
              break;
            case "OpenCrate":
              this.effects_.push(new Effect("", "Opens a crate"));
              break;
          }
        }
      }
    }

    private function initStats():void {
      var xml:XML;
      var _local3:String;
      var _local2:Boolean = true;
      for each (xml in this.itemXml_.ActivateOnEquip) {
        if (_local2) {
          this.effects_.push(new Effect("On Equip", ""));
          _local2 = false;
        }
        _local3 = this.slotData_._P_3[xml.toXMLString()];
        if (_local3 != null) {
          this.effects_.push(new Effect("", (_local3)));
        } else {
          if (xml.toString() == "IncrementStat") {
            this.effects_.push(new Effect("", this.statHandler(xml)));
          }
        }
      }
    }

    private function statHandler(_arg1:XML):String {
      var _local2:int = int(_arg1.@stat);
      var _local3:int = int(_arg1.@amount);
      var _local4:String = (_local3 > -1) ? "+" : "";
      return ('<font color="' + textColour(_arg1) + '">' + (_local4 + String(_local3) + " ") + StatData._W_H_(_local2) + '</font>');
    }

    private function textColour(activateXML:XML):String {
      var match:XML;
      var otherAmount:int;
      var stat:int = int(activateXML.@stat);
      var amount:int = int(activateXML.@amount);
      var textColor:String = ((this.playerCanUse_ && this.meetsLevel) ? "#00FF00" : "#FFFF8F");
      var otherMatches:XMLList;
      if (this.curItemXML != null) {
        otherMatches = this.curItemXML.ActivateOnEquip.(@stat == stat);
      }
      if (((!((otherMatches == null))) && ((otherMatches.length() == 1)))) {
        match = XML(otherMatches[0]);
        otherAmount = int(match.@amount);
        textColor = TooltipText._qy((amount - otherAmount));
      }
      if (amount < 0) {
        textColor = "#FF0000";
      }
      return (textColor);
    }

    private function initUse():void {
      this.restrictions_.push(new Restriction("Must be equipped to use", 0xB3B3B3, false));
      if (((this.ownedByPlayer_) || ((this.ownerId_ == _U_c.CURRENT_PLAYER)))) {
        this.restrictions_.push(new Restriction("Double-Click to equip", 0xB3B3B3, false));
      } else {
        this.restrictions_.push(new Restriction("Double-Click to take", 0xB3B3B3, false));
      }
    }

    private function initUse2():void {
      this.restrictions_.push(new Restriction((("Press [" + _H_V_._in[Parameters.data_.useSpecial]) + "] in world to use"), 0xFFFFFF, false));
    }

    private function initUse3():void {
      this.restrictions_.push(new Restriction("Consumed with use", 0xB3B3B3, false));
      if (((this.ownedByPlayer_) || ((this.ownerId_ == _U_c.CURRENT_PLAYER)))) {
        this.restrictions_.push(new Restriction("Double-Click or Shift-Click on item to use", 0xFFFFFF, false));
      } else {
        this.restrictions_.push(new Restriction("Double-Click to take & Shift-Click to use", 0xFFFFFF, false));
      }
    }

    private function initUse4():void {
      this.restrictions_.push(new Restriction("Can be used multiple times", 0xB3B3B3, false));
      this.restrictions_.push(new Restriction("Double-Click or Shift-Click on item to use", 0xFFFFFF, false));
    }

    private function initSInfo():void {
      this.specialInfo_ = new Vector.<Restriction>();
      if (this.itemData_ != null && this.itemData_.hasOwnProperty("Strange") && Boolean(this.itemData_.Strange)) {
        if(this.itemData_.hasOwnProperty("Kills")) {
          this.specialInfo_.push(new Restriction("Kills: " + int(this.itemData_.Kills).toString(), 0xB3B3B3, false));
        }
        if(this.itemData_.hasOwnProperty("StrangeParts")) {
          var _sDict:Object = this.itemData_.StrangeParts;
          for (var _k:Object in _sDict) {
            this.specialInfo_.push(new Restriction(_k + ": " + _sDict[_k], 0xB3B3B3, false));
          }
        }
      }
      if (this.itemData_ != null && this.itemData_.hasOwnProperty("Effect") && this.itemData_.Effect != "") {
        this.specialInfo_.push(new Restriction("Effect: " + this.itemData_.Effect, 0xB3B3B3, false));
      }
      if (this.itemXml_.hasOwnProperty("Material") && !(this.containerType_ == ObjectLibrary._pb["Crafting Station"])) {
        this.specialInfo_.push(new Restriction("Crafting Material", 16549442, true));
      }
      if (this.itemXml_.hasOwnProperty("Soulbound") || (this.itemData_ != null && this.itemData_.hasOwnProperty("Soulbound") && this.itemData_.Soulbound == true)) {
        this.specialInfo_.push(new Restriction("Soulbound", 0xB141FF, false));
      }
    }

    private function initInfo():void {
      var xml:XML;
      var _local3:Boolean;
      var _local4:int;
      var _local5:int;
      this.restrictions_ = new Vector.<Restriction>();
      var _local6:Boolean = (this.itemData_ != null && this.itemData_.hasOwnProperty("MultiUse") && Boolean(this.itemData_.MultiUse));
      if ((this.itemXml_.hasOwnProperty("VaultItem") || _local6) && !(this.containerType_ == -1) && !(this.containerType_ == ObjectLibrary._pb["Vault Chest"])) {
        this.restrictions_.push(new Restriction("Store this item in your Vault to avoid losing it!", 16549442, true));
      }
      if (this.itemXml_.hasOwnProperty("HalloweenItem"))
        this.restrictions_.push(new Restriction("This item is a Halloween special drop!", 0xFFA500, true));
      if (this.playerCanUse_ && this.meetsLevel) {
        if (this.itemXml_.hasOwnProperty("Usable")) {
          this.initUse2();
          this.initUse();
        } else {
          if (this.itemXml_.hasOwnProperty("Consumable") && !_local6) {
            this.initUse3();
          } else {
            if (this.itemXml_.hasOwnProperty("InvUse") || _local6) {
              this.initUse4();
            } else {
              this.initUse();
            }
          }
        }
      } else {
        if (this.player_ != null) {
          if(!this.playerCanUse_) {
            this.restrictions_.push(new Restriction(("Not usable by " + ObjectLibrary._0D_N_[this.player_.objectType_]), 16549442, true));
          }
        }
      }
      var _local1:Vector.<String> = ObjectLibrary._7S_(this.objectType_);
      if (_local1 != null) {
        this.restrictions_.push(new Restriction(("Usable by: " + _local1.join(", ")), 0xB3B3B3, false));
      }
      for each (xml in this.itemXml_.EquipRequirement) {
        _local3 = ObjectLibrary._get(xml, this.player_);
        if (xml.toString() == "Stat") {
          _local4 = int(xml.@stat);
          _local5 = int(xml.@value);
          this.restrictions_.push(new Restriction("Requires " + StatData._W_H_(_local4) + " of " + _local5, (_local3 ? 0xB3B3B3 : 16549442), !_local3));
        }
      }
    }

    private function addElem2():void {
      var styleSheet2:StyleSheet;
      if (this.restrictions_.length != 0) {
        /*this.line2_ = new _return((TOOLTIP_WIDTH - 12), 0x2D2D2D);
         this.line2_.x = 8;
         this.line2_.y = this.nextY_;
         addChild(this.line2_);*/
        styleSheet2 = new StyleSheet();
        styleSheet2.parseCSS(HANGING_INDENT_CSS);
        this.restrictionsText_ = new SimpleText(fontSize, 0xB3B3B3, false, (TOOLTIP_WIDTH - 4), 0, fontName);
        this.restrictionsText_.styleSheet = styleSheet2;
        this.restrictionsText_.wordWrap = true;
        this.restrictionsText_.htmlText = (("<span class='in'>" + restrictionsToHtml(this.restrictions_)) + "</span>");
        this.restrictionsText_._08S_();
        this.restrictionsText_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        this.restrictionsText_.x = 4;
        this.restrictionsText_.y = (this.line3_ != null) ? (this.line3_.y + 4) : (this.line2_ != null) ? (this.line2_.y + 4) : (this.line1_ != null) ? (this.line1_.y + 4) : (this.line_ != null) ? (this.line_.y + 4) : 4;
        addChild(this.restrictionsText_);
      }
    }

    private function addElem3():void {
      var styleSheet2:StyleSheet;
      if (this.specialInfo_.length != 0) {
        styleSheet2 = new StyleSheet();
        styleSheet2.parseCSS(HANGING_INDENT_CSS);
        this.specialInfoText_ = new SimpleText(fontSize, 0xB3B3B3, false, (TOOLTIP_WIDTH - 4), 0, fontName);
        this.specialInfoText_.styleSheet = styleSheet2;
        this.specialInfoText_.wordWrap = true;
        this.specialInfoText_.htmlText = (("<span class='in'>" + restrictionsToHtml(this.specialInfo_)) + "</span>");
        this.specialInfoText_._08S_();
        this.specialInfoText_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        this.specialInfoText_.x = 4;
        this.specialInfoText_.y = (this.line2_ != null) ? (this.line2_.y + 4) : (this.line1_ != null) ? (this.line1_.y + 4) : (this.line_ != null) ? (this.line_.y + 4) : 4;
        addChild(this.specialInfoText_);
      }
    }

    private function initDesc():void {
      this.descriptionText_ = new SimpleText(fontSize, 0xB3B3B3, false, TOOLTIP_WIDTH, 0, fontName);
      this.descriptionText_.wordWrap = true;
      this.descriptionText_.text = String(this.itemXml_.Description);
      this.descriptionText_.updateMetrics();
      this.descriptionText_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
      this.descriptionText_.x = 4;
      this.descriptionText_.y = (this.icon_.y + this.icon_.height);
      addChild(this.descriptionText_);
    }

    private function initActualName():void {
      this.actualName_ = new SimpleText(fontSize, 0xB3B3B3, false, TOOLTIP_WIDTH, 0, fontName);
      this.actualName_.setBold(true);
      this.actualName_.wordWrap = true;
      if (this.itemData_ != null && this.itemData_.hasOwnProperty("Name") && this.itemData_.Name != "") {
        this.actualName_.text = ObjectLibrary._0D_N_[this.objectType_];
      } else {
        this.actualName_.text = "";
      }
      this.actualName_.x = 4;
      this.actualName_.y = ((this.descriptionText_.y + this.descriptionText_.height) + 8);
      if (this.actualName_.text != "") {
        addChild(this.actualName_);
        //this.addLine(((this.actualName_.y + fontSize) + 8), 1);
      }
    }

    private function initLevel():void {
      this.level_ = new SimpleText(fontSize, 0xB3B3B3, false, TOOLTIP_WIDTH, 0, fontName);
      this.level_.setBold(true);
      this.level_.wordWrap = true;
      if (this.itemXml_.hasOwnProperty("LevelReq")) {
        if (String(this.itemXml_.LevelReq) != "") {
          this.level_.text = "Level Required: " + String(this.itemXml_.LevelReq);
        } else {
          this.level_.text = "";
        }
      } else {
        this.level_.text = "";
      }
      this.level_.x = 4;
      this.level_.y = (this.actualName_.text != "") ? (this.actualName_.y + this.actualName_.textHeight) : ((this.descriptionText_.y + this.descriptionText_.height) + 8);
      if (this.level_.text != "") {
        addChild(this.level_);
        this.addLine(((this.level_.y + fontSize) + 8), 1);
      } else if (this.actualName_.text != "") {
        this.addLine(((this.actualName_.y + fontSize) + 8), 1);
      }
    }

    private function setData():void {
      if (this.curItemXML != null) {
        this.slotData_ = this.slotHandlers_.buildData(this.itemXml_, this.curItemXML, this.itemData_, this.curItemData);
      } else {
        this.slotData_ = new SlotTooltipData();
      }
    }

    private function effectsToHtml(_arg1:Vector.<Effect>):String {
      var effect2:Effect;
      var _local5:String;
      var _local2:String = "";
      var _local3:Boolean = true;
      for each (effect2 in _arg1) {
        _local5 = "#FFFF8F";
        if (!_local3) {
          _local2 = (_local2 + "\n");
        } else {
          _local3 = false;
        }
        if (effect2.name_ != "") {
          _local2 = (_local2 + (effect2.name_ + ": "));
        }
        if (this.isSlotEmpty()) {
          _local5 = "#00ff00";
        }
        _local2 = (_local2 + (((('<font color="' + _local5) + '">') + effect2.value_) + "</font>"));
      }
      return (_local2);
    }

  }
}//package com.company.assembleegameclient.ui.tooltip

class Effect {

  public var name_:String;
  public var value_:String;

  public function Effect(_arg1:String, _arg2:String) {
    this.name_ = _arg1;
    this.value_ = _arg2;
  }
}
class Restriction {

  public var text_:String;
  public var color_:uint;
  public var bold_:Boolean;

  public function Restriction(_arg1:String, _arg2:uint, _arg3:Boolean) {
    this.text_ = _arg1;
    this.color_ = _arg2;
    this.bold_ = _arg3;
  }
}

