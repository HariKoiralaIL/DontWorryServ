package com.company.assembleegameclient.objects {
    import mapoverlay.CharacterStatusText;

    import particleeffects.LevelUpEffect;
    import particleeffects.AuraEffect;
    import particleeffects.HealingEffect;
    import particleeffects.EffectProperties;
    import particleeffects.ParticleEffect;

    import audio.SoundEffects;

    import com.company.assembleegameclient.map.Square;
    import com.company.assembleegameclient.map.GameCamera;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.tutorial.Tutorial;
    import com.company.assembleegameclient.tutorial.doneAction;
    import com.company.assembleegameclient.ui.Inventory;
    import com.company.assembleegameclient.util.ConditionEffect;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.assembleegameclient.util._J_H_;
    import com.company.assembleegameclient.util._Z_B_;
    import com.company.assembleegameclient.util._lJ_;
    import com.company.assembleegameclient.util._wW_;
    import com.company.ui.SimpleText;
    import com.company.util.AssetLibrary;
    import com.company.util.ConversionUtil;
    import com.company.util.GraphicHelper;
    import com.company.util.IntPoint;
    import com.company.util.MoreColorUtil;
    import com.company.util.PointUtil;
    import com.company.util.Trig;
    import com.company.util._G_;

    import flash.display.BitmapData;
    import flash.display.GraphicsPath;
    import flash.display.GraphicsSolidFill;
    import flash.display.IGraphicsData;
    import flash.display.Sprite;
    import flash.filters.GlowFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;

    public class Player extends Character {

        public static const TELEPORT_COOLDOWN_MS:int = 10000;

        public static var _atk;
        public static var _def;
        public static var _spd;
        public static var _dex;
        public static var _vit;
        public static var _wis;

        public static var _mindmg;
        public static var _maxdmg;

        public var statScale_:int = 75;

        public static var _e_D:Boolean = false;
        private static const NEIGHBOR_OFFSETS:Vector.<Point> = new <Point>[new Point(0, 0), new Point(1, 0), new Point(0, 1), new Point(1, 1)];
        private static const MOVE_STEP_SIZE:Number = 0.4;
        private static const STAR_MATRIX:Matrix = new Matrix(1, 0, 0, 1, 2, 4);
        private static const NAME_MATRIX:Matrix = new Matrix(1, 0, 0, 1, 20, 0);
        private static const MIN_MOVE_SPEED:Number = 0.004;
        private static const MAX_MOVE_SPEED:Number = 0.0096;
        private static const MIN_ATTACK_FREQ:Number = 0.0015;
        private static const MAX_ATTACK_FREQ:Number = 0.008;
        private static const MIN_ATTACK_MULT:Number = 0.5;
        private static const MAX_ATTACK_MULT:Number = 2;

        private static var tempPoint2_:Point = new Point();

        public static function fromCharXML(name:String, xml:XML):Player {
            var _local3:int = int(xml.ObjectType);
            var _local4:XML = ObjectLibrary.typeToXML_[_local3];
            var _local5:Player = new Player(_local4);
            _local5.name_ = name;
            _local5.level_ = int(xml.Level);
            _local5.exp_ = int(xml.Exp);
            _local5.equipment_ = ConversionUtil._04n(xml._Equipment);
            _local5.maxHP_ = int(xml.MaxHitPoints);
            _local5.HP_ = int(xml.HitPoints);
            _local5.maxMP_ = int(xml.MaxMagicPoints);
            _local5.MP_ = int(xml.MagicPoints);
            _local5.attack_ = int(xml.Attack);
            _local5.defense_ = int(xml.Defense);
            _local5.speed_ = int(xml.Speed);
            _local5.dexterity_ = int(xml.Dexterity);
            _local5.vitality_ = int(xml.HpRegen);
            _local5.wisdom_ = int(xml.MpRegen);
            _local5.luck_ = int(xml.Luck);
            _local5.crit_ = int(xml.Crit);
            _local5.tex1Id_ = int(xml.Tex1);
            _local5.tex2Id_ = int(xml.Tex2);
            _local5.setSkin(int(xml.Skin));
            return (_local5);
        }

        private static function getFacing(angle:Number, camera:GameCamera):int {
            var _local4:int;
            var _local3:Number = Trig._V_r((angle - camera.angleRad_));
            if ((((_local3 > (Math.PI / 4))) && ((_local3 < ((3 * Math.PI) / 4))))) {
                _local4 = _lJ_.DOWN;
            } else {
                if ((((_local3 <= (Math.PI / 4))) && ((_local3 >= (-(Math.PI) / 4))))) {
                    _local4 = _lJ_.RIGHT;
                } else {
                    if ((((_local3 < (-(Math.PI) / 4))) && ((_local3 > ((-3 * Math.PI) / 4))))) {
                        _local4 = _lJ_.UP;
                    } else {
                        _local4 = _lJ_.LEFT;
                    }
                }
            }
            return (_local4);
        }

        public function Player(xml:XML) {
            this.merchLookupKey_ = new IntPoint();
            super(xml);
            this.attackMax_ = int(xml.Attack.@max);
            this.defenseMax_ = int(xml.Defense.@max);
            this.speedMax_ = int(xml.Speed.@max);
            this.dexterityMax_ = int(xml.Dexterity.@max);
            this.vitalityMax_ = int(xml.HpRegen.@max);
            this.wisdomMax_ = int(xml.MpRegen.@max);
            this.stat_luckI = int(xml.Luck.@max);
            this.stat_critI = int(xml.Crit.@max);
            this.maxHPMax_ = int(xml.MaxHitPoints.@max);
            this.maxMPMax_ = int(xml.MaxMagicPoints.@max);
            textureCache_ = new Dictionary();
            unusualEffects_ = new Vector.<ParticleEffect>();
        }
        public var accountId_:int = -1;
        public var credits_:int = 0;
        public var numStars_:int = 0;
        public var fame_:int = 0;
        public var keys_:int = 0;
        public var nameChosen_:Boolean = false;
        public var _Hh:Boolean = false;
        public var _0L_o:int = 0;
        public var _n8:int = -1;
        public var glowColor_:int = -1;
        public var guildName_:String = null;
        public var guildRank_:int = -1;
        public var partyID_:int = -1;
        public var partyLeader:Boolean = false;
        public var isFellowGuild_:Boolean = false;
        public var inParty:Boolean = false;
        public var breath_:int = -1;
        public var maxMP_:int = 200;
        public var MP_:Number = 0;
        public var _7V_:int = 1000;
        public var exp_:int = 0;
        public var attack_:int = 0;
        public var speed_:int = 0;
        public var dexterity_:int = 0;
        public var vitality_:int = 0;
        public var wisdom_:int = 0;
        public var _P_7:int = 0;
        public var _0D_G_:int = 0;
        public var _05s:int = 0;
        public var _07f:int = 0;
        public var _065:int = 0;
        public var _pP_:int = 0;
        public var _B_e:int = 0;
        public var luck_:int = 0;
        public var crit_:int = 0;
        public var stat_luck:int = 0;
        public var stat_crit:int = 0;
        public var stat_luckI:int = 0;
        public var stat_critI:int = 0;
        public var _cu:int = 0;
        public var _gz:int = 0;
        public var attackMax_:int = 0;
        public var defenseMax_:int = 0;
        public var speedMax_:int = 0;
        public var dexterityMax_:int = 0;
        public var vitalityMax_:int = 0;
        public var wisdomMax_:int = 0;
        public var maxHPMax_:int = 0;
        public var maxMPMax_:int = 0;
        public var starred_:Boolean = false;
        public var isIgnored_:Boolean = false;
        public var distSqFromThisPlayer_:Number = 0;
        public var attackPeriod_:int = 0;
        public var altCooldownEnd_:int = 0;
        public var nextTeleportAt_:int = 0;
        public var inventory:Inventory;
        public var _K_X_:BitmapData = null;
        public var usiShukAbil:Boolean = false;
        public var canNexus:Boolean = true;
        protected var rotate_:Number = 0;
        protected var inputDir_:Point = null;
        protected var moveMultiplier_:Number = 1;
        protected var healingEffect_:HealingEffect = null;
        protected var nearestMerchant_:Merchant = null;
        private var playerHallucinationTex_:BitmapData = null;
        private var isDefaultTexture_:Boolean = true;
        private var merchLookupKey_:IntPoint;
        private var breathBgFill_:GraphicsSolidFill = null;
        private var breathBgPath_:GraphicsPath = null;
        private var breathFill_:GraphicsSolidFill = null;
        private var breathPath_:GraphicsPath = null;
        private var prevEffect_:String = "";
        private var effString_:String = "";
        private var unusualEffects_:Vector.<ParticleEffect> = null;

        override public function moveTo(x:Number, y:Number):Boolean {
            var _local3:Boolean = super.moveTo(x, y);
            this.nearestMerchant_ = this.findNearestMerchant();
            return (_local3);
        }

        override public function update(time:int, dt:int):Boolean {
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            var _local6:int;
            if(prevEffect_ != effString_) {
                prevEffect_ = effString_;
                for each(var _effect:ParticleEffect in unusualEffects_) {
                    map_.removeObj(_effect.objectId_);
                }
                this.unusualEffects_ = new Vector.<ParticleEffect>();
                var _effXML:XML = XML(this.effString_);
                if(_effXML.name() == "Effects") {
                    for each(var _childEff:XML in _effXML.children()) {
                        var _newEff:ParticleEffect = ParticleEffect.fromProps(new EffectProperties(_childEff), this);
                        if(_newEff != null) {
                            this.unusualEffects_.push(_newEff);
                        }
                    }
                } else {
                    var _newEff:ParticleEffect = ParticleEffect.fromProps(new EffectProperties(XML(this.effString_)), this);
                    if(_newEff != null) {
                        this.unusualEffects_.push(_newEff);
                    }
                }
                for each(var _effect:ParticleEffect in unusualEffects_) {
                    map_.addObj(_effect, x_, y_);
                }
            }
            if (((isHealing()) && (!(isPaused())))) {
                if (this.healingEffect_ == null) {
                    this.healingEffect_ = new HealingEffect(this);
                    map_.addObj(this.healingEffect_, x_, y_);
                }
            } else {
                if (this.healingEffect_ != null) {
                    map_.removeObj(this.healingEffect_.objectId_);
                    this.healingEffect_ = null;
                }
            }
            if ((((map_.player_ == this)) && (isPaused()))) {
                return (true);
            }
            if (this.inputDir_ != null) {
                _local3 = Parameters.data_.cameraAngle;
                if (this.rotate_ != 0) {
                    _local3 = (_local3 + ((dt * Parameters.data_.rotationSpeed) * this.rotate_));
                    Parameters.data_.cameraAngle = _local3;
                }
                if (((!((this.inputDir_.x == 0))) || (!((this.inputDir_.y == 0))))) {
                    _local4 = this.getMoveSpeed();
                    _local5 = Math.atan2(this.inputDir_.y, this.inputDir_.x);
                    moveVec_.x = (_local4 * Math.cos((_local3 + _local5)));
                    moveVec_.y = (_local4 * Math.sin((_local3 + _local5)));
                } else {
                    moveVec_.x = 0;
                    moveVec_.y = 0;
                }
                if (((!((square_ == null))) && (square_.props_.push_))) {
                    moveVec_.x = (moveVec_.x - (square_.props_.animate_.dx_ / 1000));
                    moveVec_.y = (moveVec_.y - (square_.props_.animate_.dy_ / 1000));
                }
                this.walkTo((x_ + (dt * moveVec_.x)), (y_ + (dt * moveVec_.y)));
            } else {
                if (!super.update(time, dt)) {
                    return (false);
                }
            }
            if ((((((((((map_.player_ == this)) && ((square_.props_.maxDamage_ > 0)))) && (((square_.lastDamage_ + 500) < time)))) && (!(isInvincible())))) && ((((square_.obj_ == null)) || (!(square_.obj_.props_.protectFromGroundDamage_)))))) {
                _local6 = map_.gs_.gsc_.getNextDamage(square_.props_.minDamage_, square_.props_.maxDamage_);
                damage(-1, _local6, null, (HP_ <= _local6), null);
                map_.gs_.gsc_.groundDamage(time, x_, y_);
                square_.lastDamage_ = time;
            }
            return (true);
        }

        public function setEffect(effect:String) {
            this.effString_ = effect;
        }

        override protected function generateNameBitmapData(nameText:SimpleText):BitmapData {
            if (this.inParty) {
                nameText.setColor(Parameters.partyColor);
            } else if (this.isFellowGuild_) {
                nameText.setColor(Parameters._mg);
            } else if (this.name_ == "$Bledixon$") {
                nameText.setColor(Parameters._colorBled);
            } else if (this.name_ == "Quest") {
                nameText.setColor(Parameters._colorArc);
            } else if (this.name_ == "Antidote") {
                nameText.setColor(Parameters._colorSec);
            } else if (this.name_ == "Crisp") {
                nameText.setColor(Parameters._colorSec);
            } else if (this.nameChosen_) {
                nameText.setColor(Parameters._8T_);
            }
            var _local2:BitmapData = new BitmapData((nameText.width + 20), 64, true, 0);
            _local2.draw(nameText, NAME_MATRIX);
            _local2.applyFilter(_local2, _local2.rect, PointUtil._P_5, new GlowFilter(0, 1, 3, 3, 2, 1));
            var _local3:Sprite = _Z_B_._0M_r(this.numStars_);
            _local2.draw(_local3, STAR_MATRIX);
            return (_local2);
        }

        override public function draw(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
            if(Parameters.data_.HideOtherPlayers) {
                if(this != map_.player_) {
                    return;
                }
            }
            super.draw(graphicsData, camera, time);
            if (this != map_.player_) {
                if (!Parameters._0F_o) {
                    if (this != this.map_.player_ && this.map_.player_.canBeHitBy(this)) {
                        if (!this.isInvisible()) {
                            drawName(graphicsData, camera);
                        }
                    } else {
                        drawName(graphicsData, camera);
                    }
                }
            } else {
                if (this.breath_ >= 0) {
                    this.drawBreathBar(graphicsData, camera, time);
                }
            }
        }

        override protected function getTexture(camera:GameCamera, time:int):BitmapData {
            var _local10:int;
            var _local11:Dictionary;
            var _local12:Number;
            var _local13:int;
            var _local14:ColorTransform;
            var _local3:Number = 0;
            var _local4:int = _lJ_._sS_;
            if (time < (attackStart_ + this.attackPeriod_)) {
                facing_ = attackAngle_;
                _local3 = (((time - attackStart_) % this.attackPeriod_) / this.attackPeriod_);
                _local4 = _lJ_._E_w;
            } else {
                if (((!((moveVec_.x == 0))) || (!((moveVec_.y == 0))))) {
                    _local10 = (3.5 / this.getMoveSpeed());
                    if (((!((moveVec_.y == 0))) || (!((moveVec_.x == 0))))) {
                        facing_ = Math.atan2(moveVec_.y, moveVec_.x);
                    }
                    _local3 = ((time % _local10) / _local10);
                    _local4 = _lJ_._m1;
                }
            }
            if (((this.isHexed()) && (this.isDefaultTexture_))) {
                this.applyHexTexture();
            }
            if (((!(this.isHexed())) && (!(this.isDefaultTexture_)))) {
                this.restoreTexture();
            }
            var _local5:_J_H_ = animatedChar_.imageFromFacing(facing_, camera, _local4, _local3);
            if (camera.isHallucinating_) {
                _local5 = new _J_H_(getHallucinationTexture(), null);
            }
            var _local6:int = tex1Id_;
            var _local7:int = tex2Id_;
            var _local8:BitmapData;
            if (this.nearestMerchant_ != null) {
                _local11 = textureCache_[this.nearestMerchant_];
                if (_local11 == null) {
                    textureCache_[this.nearestMerchant_] = new Dictionary();
                } else {
                    _local8 = _local11[_local5];
                }
                _local6 = this.nearestMerchant_.getTex1Id(tex1Id_);
                _local7 = this.nearestMerchant_.getTex2Id(tex2Id_);
                this.previewSkin(this.nearestMerchant_.getSkinId(skinId_, this));
            } else {
                _local8 = textureCache_[_local5];
                this.previewSkin(-1);
            }
            if (_local8 == null) {
                _local8 = TextureRedrawer.resize(_local5.image_, _local5.mask_, size_, false, _local6, _local7);
                if (this.nearestMerchant_ != null) {
                    textureCache_[this.nearestMerchant_][_local5] = _local8;
                } else {
                    textureCache_[_local5] = _local8;
                }
            }
            if (HP_ < (maxHP_ * 0.2)) {
                _local12 = (int((Math.abs(Math.sin((time / 200))) * 10)) / 10);
                _local13 = 128;
                _local14 = new ColorTransform(1, 1, 1, 1, (_local12 * _local13), (-(_local12) * _local13), (-(_local12) * _local13));
                _local8 = _G_._B_2(_local8, _local14);
            }
            var _local9:BitmapData = textureCache_[_local8];
            if (_local9 == null) {
                _local9 = TextureRedrawer.outlineGlow(_local8, 0, this.glowColor_ == -1 ? 0 : this.glowColor_);
                textureCache_[_local8] = _local9;
            }
            if (((isPaused()) || (isStasis()))) {
                _local9 = _G_._R_9(_local9, GRAYSCALE_FILTER);
            } else {
                if (isInvisible()) {
                    if (this != this.map_.player_ && this.map_.player_.canBeHitBy(this)) {
                        _local9 = _G_._0C_m(_local9, 0);
                    } else {
                        _local9 = _G_._0C_m(_local9, 0.4);
                    }
                }
            }
            return (_local9);
        }

        override public function getPortrait():BitmapData {
            var _local1:_J_H_;
            var _local2:int;
            if (portrait_ == null) {
                _local1 = animatedChar_.imageFromDir(_lJ_.RIGHT, _lJ_._sS_, 0);
                _local2 = ((4 / _local1.image_.width) * 100);
                portrait_ = TextureRedrawer.resize(_local1.image_, _local1.mask_, _local2, true, tex1Id_, tex2Id_);
                portrait_ = TextureRedrawer.outlineGlow(portrait_, 0, 0);
            }
            return (portrait_);
        }

        override public function setAttack(itemType:int, angle:Number):void {
            var _local3:XML = ObjectLibrary.typeToXML_[itemType];
            if (_local3 == null || !_local3.hasOwnProperty("RateOfFire")) {
                return;
            }
            var _local4:Number = Number(_local3.RateOfFire);
            this.attackPeriod_ = ((1 / this.getAttackFrequency()) * (1 / _local4));
            super.setAttack(itemType, angle);
        }

        override public function toString():String {
            return ("<Char>" + "<Name>" + name_ + "</Name>" + "<ObjectType>" + objectType_ + "</ObjectType>" + "<Level>" + level_ + "</Level>" + "<Exp>" + this.exp_ + "</Exp>" + "<Equipment>" + equipment_ + "</Equipment>" + "<MaxHitPoints>" + maxHP_ + "</MaxHitPoints>" + "<HitPoints>" + HP_ + "</HitPoints>" + "<MaxMagicPoints>" + this.maxMP_ + "</MaxMagicPoints>" + "<MagicPoints>" + this.MP_ + "</MagicPoints>" + "<Attack>" + this.attack_ + "</Attack>" + "<Defense>" + defense_ + "</Defense>" + "<Speed>" + this.speed_ + "</Speed>" + "<HpRegen>" + this.vitality_ + "</HpRegen>" + "<MpRegen>" + this.wisdom_ + "</MpRegen>" + "<Dexterity>" + this.dexterity_ + "</Dexterity>" + "</Char>");
        }

        public function setRelativeMovement(rotate:Number, x:Number, y:Number):void {
            var _local4:Number;
            if (this.inputDir_ == null) {
                this.inputDir_ = new Point();
            }
            this.rotate_ = rotate;
            this.inputDir_.x = x;
            this.inputDir_.y = y;
            if (isConfused()) {
                _local4 = this.inputDir_.x;
                this.inputDir_.x = -(this.inputDir_.y);
                this.inputDir_.y = -(_local4);
                this.rotate_ = -(this.rotate_);
            }
        }

        public function setCredits(credits:int):void {
            this.credits_ = credits;
        }

        public function setKeys(keys:int):void {
            this.keys_ = keys;
        }

        public function setGuildName(name:String):void {
            var _local3:GameObject;
            var _local4:Player;
            var _local5:Boolean;
            this.guildName_ = name;
            var _local2:Player = map_.player_;
            if (_local2 == this) {
                for each (_local3 in map_.goDict_) {
                    _local4 = (_local3 as Player);
                    if (((!((_local4 == null))) && (!((_local4 == this))))) {
                        _local4.setGuildName(_local4.guildName_);
                    }
                }
            } else {
                _local5 = ((((((!((_local2 == null))) && (!((_local2.guildName_ == null))))) && (!((_local2.guildName_ == ""))))) && ((_local2.guildName_ == this.guildName_)));
                if (_local5 != this.isFellowGuild_) {
                    this.isFellowGuild_ = _local5;
                    nameBitmap_ = null;
                }
            }
        }

        public function UpdateParty(partyId:int):void {
            var _local3:GameObject;
            var _local4:Player;
            var _local5:Boolean;
            this.partyID_ = partyId;
            var _local2:Player = map_.player_;
            if (_local2 == this) {
                for each (_local3 in map_.goDict_) {
                    _local4 = (_local3 as Player);
                    if (((!((_local4 == null))) && (!((_local4 == this))))) {
                        _local4.UpdateParty(_local4.partyID_);
                    }
                }
            } else {
                _local5 = _local2 != null && _local2.partyID_ != -1 && _local2.partyID_ == this.partyID_;
                if (_local5 != this.inParty) {
                    this.inParty = _local5;
                    nameBitmap_ = null;
                }
            }
        }

        public function canTeleportTo(player:Player):Boolean {
            if (((player.isPaused()) || (player.isInvisible()))) {
                return (false);
            }
            return (true);
        }

        public function msUntilTeleport():int {
            var _local1:int = getTimer();
            return (Math.max(0, (this.nextTeleportAt_ - _local1)));
        }

        public function teleportTo(player:Player):Boolean {
            if (isPaused()) {
                map_.gs_.textBox_.addText(Parameters.SendError, "Can not teleport while paused.");
                return (false);
            }
            var _local2:int = this.msUntilTeleport();
            if (_local2 > 0) {
                map_.gs_.textBox_.addText(Parameters.SendError, (("You can not teleport for another " + int(((_local2 / 1000) + 1))) + " seconds."));
                return (false);
            }
            if (!this.canTeleportTo(player)) {
                if (player.isInvisible()) {
                    map_.gs_.textBox_.addText(Parameters.SendError, (("Can not teleport to " + player.name_) + " while they are invisible."));
                }
                map_.gs_.textBox_.addText(Parameters.SendError, ("Can not teleport to " + player.name_));
                return (false);
            }
            map_.gs_.gsc_.teleport(player.objectId_);
            this.nextTeleportAt_ = (getTimer() + TELEPORT_COOLDOWN_MS);
            return (true);
        }

        public function levelUpEffect(text:String):void {
            this.levelUpParticles();
            map_.mapOverlay_.addChild(new CharacterStatusText(this, text, 0xFF00, 2000));
        }

        public function handleLevelUp(isNewClass:Boolean):void {
            SoundEffects.play("level_up");
            if (isNewClass) {
                this.levelUpEffect("New Class Unlocked!");
            } else {
                this.levelUpEffect("Level Up!");
            }
        }

        public function levelUpParticles():void {
            map_.addObj(new LevelUpEffect(this, 0xFF00FF00, 20), x_, y_);
        }

        public function auraEffect():void {
            map_.addObj(new AuraEffect(this, 0xFFFFFF), x_, y_);
        }

        public function handleExpUp(exp:int):void {
            if (level_ == 120) {
                return;
            }
            map_.mapOverlay_.addChild(new CharacterStatusText(this, (("+" + exp) + "XP"), 0xFF00, 1000));
        }

        public function walkTo(x:Number, y:Number):Boolean {
            this.modifyMove(x, y, tempPoint2_);
            return (this.moveTo(tempPoint2_.x, tempPoint2_.y));
        }

        public function modifyMove(x:Number, y:Number, point:Point):void {
            if (isParalyzed()) {
                point.x = x_;
                point.y = y_;
                return;
            }
            var _local4:Number = (x - x_);
            var _local5:Number = (y - y_);
            if ((((((((_local4 < MOVE_STEP_SIZE)) && ((_local4 > -(MOVE_STEP_SIZE))))) && ((_local5 < MOVE_STEP_SIZE)))) && ((_local5 > -(MOVE_STEP_SIZE))))) {
                this.modifyStep(x, y, point);
                return;
            }
            var _local6:Number = Math.atan2(_local4, _local5);
            var _local7:Number = (MOVE_STEP_SIZE / Math.max(Math.abs(_local4), Math.abs(_local5)));
            var _local8:Number = 0;
            point.x = x_;
            point.y = y_;
            var _local9:Boolean;
            while (!(_local9)) {
                if ((_local8 + _local7) >= 1) {
                    _local7 = (1 - _local8);
                    _local9 = true;
                }
                this.modifyStep((point.x + (_local4 * _local7)), (point.y + (_local5 * _local7)), point);
                _local8 = (_local8 + _local7);
            }
        }

        public function modifyStep(x:Number, y:Number, point:Point):void {
            var _local6:Number;
            var _local7:Number;
            var _local4:Boolean = ((((((x_ % 0.5) == 0)) && (!((x == x_))))) || (!((int((x_ / 0.5)) == int((x / 0.5))))));
            var _local5:Boolean = ((((((y_ % 0.5) == 0)) && (!((y == y_))))) || (!((int((y_ / 0.5)) == int((y / 0.5))))));
            if (((((!(_local4)) && (!(_local5)))) || (this.isValidPosition(x, y)))) {
                point.x = x;
                point.y = y;
                return;
            }
            if (_local4) {
                _local6 = (((x) > x_) ? (int((x * 2)) / 2) : (int((x_ * 2)) / 2));
                if (int(_local6) > int(x_)) {
                    _local6 = (_local6 - 0.01);
                }
            }
            if (_local5) {
                _local7 = (((y) > y_) ? (int((y * 2)) / 2) : (int((y_ * 2)) / 2));
                if (int(_local7) > int(y_)) {
                    _local7 = (_local7 - 0.01);
                }
            }
            if (!_local4) {
                point.x = x;
                point.y = _local7;
                return;
            }
            if (!_local5) {
                point.x = _local6;
                point.y = y;
                return;
            }
            var _local8:Number = (((x) > x_) ? (x - _local6) : (_local6 - x));
            var _local9:Number = (((y) > y_) ? (y - _local7) : (_local7 - y));
            if (_local8 > _local9) {
                if (this.isValidPosition(x, _local7)) {
                    point.x = x;
                    point.y = _local7;
                    return;
                }
                if (this.isValidPosition(_local6, y)) {
                    point.x = _local6;
                    point.y = y;
                    return;
                }
            } else {
                if (this.isValidPosition(_local6, y)) {
                    point.x = _local6;
                    point.y = y;
                    return;
                }
                if (this.isValidPosition(x, _local7)) {
                    point.x = x;
                    point.y = _local7;
                    return;
                }
            }
            point.x = _local6;
            point.y = _local7;
        }

        public function isValidPosition(x:Number, y:Number):Boolean {
            var _local3:Square = map_.getSquare(x, y);
            if (((!((square_ == _local3))) && ((((_local3 == null)) || (!(_local3.isWalkable())))))) {
                return (false);
            }
            var _local4:Number = (x - int(x));
            var _local5:Number = (y - int(y));
            if (_local4 < 0.5) {
                if (this.isFullOccupy((x - 1), y)) {
                    return (false);
                }
                if (_local5 < 0.5) {
                    if (((this.isFullOccupy(x, (y - 1))) || (this.isFullOccupy((x - 1), (y - 1))))) {
                        return (false);
                    }
                } else {
                    if (_local5 > 0.5) {
                        if (((this.isFullOccupy(x, (y + 1))) || (this.isFullOccupy((x - 1), (y + 1))))) {
                            return (false);
                        }
                    }
                }
            } else {
                if (_local4 > 0.5) {
                    if (this.isFullOccupy((x + 1), y)) {
                        return (false);
                    }
                    if (_local5 < 0.5) {
                        if (((this.isFullOccupy(x, (y - 1))) || (this.isFullOccupy((x + 1), (y - 1))))) {
                            return (false);
                        }
                    } else {
                        if (_local5 > 0.5) {
                            if (((this.isFullOccupy(x, (y + 1))) || (this.isFullOccupy((x + 1), (y + 1))))) {
                                return (false);
                            }
                        }
                    }
                } else {
                    if (_local5 < 0.5) {
                        if (this.isFullOccupy(x, (y - 1))) {
                            return (false);
                        }
                    } else {
                        if (_local5 > 0.5) {
                            if (this.isFullOccupy(x, (y + 1))) {
                                return (false);
                            }
                        }
                    }
                }
            }
            return (true);
        }

        public function isFullOccupy(x:Number, y:Number):Boolean {
            var _local3:Square = map_.lookupSquare(x, y);
            return ((((((_local3 == null)) || ((_local3.tileType_ == 0xFF)))) || (((!((_local3.obj_ == null))) && (_local3.obj_.props_.fullOccupy_)))));
        }

        public function updateMoveMultiplier():void {
            var _local1:Square = map_.getSquare(x_, y_);
            if (_local1.props_.sinking_) {
                sinkLevel_ = Math.min((sinkLevel_ + 1), Parameters._K_5);
                this.moveMultiplier_ = (0.1 + ((1 - (sinkLevel_ / Parameters._K_5)) * (_local1.props_.speed_ - 0.1)));
            } else {
                sinkLevel_ = 0;
                this.moveMultiplier_ = _local1.props_.speed_;
            }
        }

        public function getAttackFrequency():Number {
            if (isDazed()) {
                return (MIN_ATTACK_FREQ);
            }

            _atk = this.attack_;
            _def = this.defense_;
            _spd = this.speed_;
            _vit = this.vitality_;
            _wis = this.wisdom_;
            _dex = this.dexterity_;

            var _local1:Number = (MIN_ATTACK_FREQ + ((this.dexterity_ / statScale_) * (MAX_ATTACK_FREQ - MIN_ATTACK_FREQ)));
            if (isBerserk()) {
                _local1 = (_local1 * 1.5);
            }
            if (statScale_ != 75) {
                statScale_ = 75
            }
            return (_local1);
        }

        public function useAltWeapon(x:Number, y:Number):void {
            var _local7:XML;
            var _local8:int;
            var _local10:Number;
            if (map_ == null || isPaused()) {
                return;
            }
            var _local3:int = equipment_[1];
            if (_local3 == -1) {
                return;
            }
            var _local4:XML = ObjectLibrary.typeToXML_[_local3];
            if (_local4 == null || !_local4.hasOwnProperty("Usable")) {
                return;
            }
            var _local5:int = int(_local4.MpCost);
            if (_local5 > this.MP_) {
                SoundEffects.play("no_mana");
                return;
            }
            var _local6:Point = map_.pSTopW(x, y);
            if (_local6 == null) {
                SoundEffects.play("error");
                return;
            }
            for each (_local7 in _local4.Activate) {
                if (_local7.toString() == "Teleport") {
                    if (!this.isValidPosition(_local6.x, _local6.y)) {
                        SoundEffects.play("error");
                        return;
                    }
                }
            }
            if (usiShukAbil) {
                return;
            }
            _local8 = getTimer();
            var _local19:XML = ObjectLibrary.typeToXML_[equipment_[3]];
            if (_local8 < this.altCooldownEnd_) {
                SoundEffects.play("error");
                return;
            }
            var _local9 = 500;
            if (_local4.hasOwnProperty("Cooldown")) {
                _local9 = (Number(_local4.Cooldown) * 1000);
            }
            if (_local19 != null && _local19.hasOwnProperty("BypassCool")) {
                _local9 = 0;
            }
            this.altCooldownEnd_ = (_local8 + _local9);
            map_.gs_.gsc_.useItem(_local8, objectId_, 1, _local3, _local6.x, _local6.y);
            if (_local4.Activate == "Shoot") {
                _local10 = Math.atan2(y, x);
                this.doShoot(_local8, _local3, _local4, (Parameters.data_.cameraAngle + _local10), false, 1);
            }
            if (_local4.Activate == "ShurikenAbility") {
                this.usiShukAbil = true;
            }
        }

        public function shukAbil(x:Number, y:Number):void {

            if (!usiShukAbil)
                return;

            var _local3:int = equipment_[1];
            var _local4:XML = ObjectLibrary.typeToXML_[_local3];
            var _local6:Point = map_.pSTopW(x, y);
            var _local8:int;

            if (_local3 == -1) {
                return;
            }
            if (_local6 == null) {
                return;
            }
            _local8 = getTimer();

            this.usiShukAbil = false;

            map_.gs_.gsc_.useItem(_local8, objectId_, 1, _local3, _local6.x, _local6.y);

            var _local5:int = int(_local4.MpEndCost);
            var _local10:Number = Math.atan2(y, x);
            if (_local5 > this.MP_) {
                SoundEffects.play("error");
            } else {
                this.doShoot(_local8, _local3, _local4, (Parameters.data_.cameraAngle + _local10), false, 1);
            }
        }

        public function attemptAttackAngle(angle:Number):void {
            this.shoot(Parameters.data_.cameraAngle + angle);
        }

        public function getClassName():String {
            return (ObjectLibrary.typeToDisplayId_[objectType_]);
        }

        public function isHexed():Boolean {
            return (!(((condition_ & ConditionEffect._gY_) == 0)));
        }

        override public function drawShadow(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
            if(this != this.map_.player_ && this.map_.player_.canBeHitBy(this) && this.isInvisible()) {
                return;
            }
            super.drawShadow(graphicsData, camera, time);
        }

        protected function drawBreathBar(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
            var _local8:Number;
            var _local9:Number;
            if (this.breathPath_ == null) {
                this.breathBgFill_ = new GraphicsSolidFill();
                this.breathBgPath_ = new GraphicsPath(GraphicHelper._H_2, new Vector.<Number>());
                this.breathFill_ = new GraphicsSolidFill(2542335);
                this.breathPath_ = new GraphicsPath(GraphicHelper._H_2, new Vector.<Number>());
            }
            if (this.breath_ <= Parameters._E_S_) {
                _local8 = ((Parameters._E_S_ - this.breath_) / Parameters._E_S_);
                this.breathBgFill_.color = MoreColorUtil._oH_(0x545454, 0xFF0000, (Math.abs(Math.sin((time / 300))) * _local8));
            } else {
                this.breathBgFill_.color = 0x545454;
            }
            var _local4:int = 20;
            var _local5:int = 4;
            var _local6:int = 6;
            var _local7:Vector.<Number> = this.breathBgPath_.data;
            _local7.length = 0;
            _local7.push((screenVec_[0] - _local4), (screenVec_[1] + _local5), (screenVec_[0] + _local4), (screenVec_[1] + _local5), (screenVec_[0] + _local4), ((screenVec_[1] + _local5) + _local6), (screenVec_[0] - _local4), ((screenVec_[1] + _local5) + _local6));
            graphicsData.push(this.breathBgFill_);
            graphicsData.push(this.breathBgPath_);
            graphicsData.push(GraphicHelper.END_FILL);
            if (this.breath_ > 0) {
                _local7 = this.breathPath_.data;
                _local9 = (((this.breath_ / 100) * 2) * _local4);
                _local7.length = 0;
                _local7.push((screenVec_[0] - _local4), (screenVec_[1] + _local5), ((screenVec_[0] - _local4) + _local9), (screenVec_[1] + _local5), ((screenVec_[0] - _local4) + _local9), ((screenVec_[1] + _local5) + _local6), (screenVec_[0] - _local4), ((screenVec_[1] + _local5) + _local6));
                graphicsData.push(this.breathFill_);
                graphicsData.push(this.breathPath_);
                graphicsData.push(GraphicHelper.END_FILL);
            }
        }

        protected function getPlayerHallucinationTexture():BitmapData {
            if (this.playerHallucinationTex_ == null) {
                this.playerHallucinationTex_ = AssetLibrary._xK_("lofiChar8x8", int((Math.random() * 239)));
            }
            return (this.playerHallucinationTex_);
        }

        private function findNearestMerchant():Merchant {
            var _local3:Point;
            var _local4:Merchant;
            var _local1:int = ((((x_ - int(x_))) > 0.5) ? 1 : -1);
            var _local2:int = ((((y_ - int(y_))) > 0.5) ? 1 : -1);
            for each (_local3 in NEIGHBOR_OFFSETS) {
                this.merchLookupKey_.x_ = (x_ + (_local1 * _local3.x));
                this.merchLookupKey_.y_ = (y_ + (_local2 * _local3.y));
                _local4 = map_.merchLookup_[this.merchLookupKey_];
                if (_local4 != null) {
                    return ((((PointUtil._bm(_local4.x_, _local4.y_, x_, y_) < 1)) ? _local4 : null));
                }
            }
            return (null);
        }

        private function getMoveSpeed():Number {
            if (isSlowed()) {
                return ((MIN_MOVE_SPEED * this.moveMultiplier_));
            }
            var _local1:Number = (MIN_MOVE_SPEED + ((this.speed_ / statScale_) * (MAX_MOVE_SPEED - MIN_MOVE_SPEED)));
            if (isSpeedy()) {
                _local1 = (_local1 * 1.5);
            }
            if (statScale_ != 75) {
                statScale_ = 75
            }
            return ((_local1 * this.moveMultiplier_));
        }

        private function getAttackMultiplier():Number {
            if (isWeak()) {
                return (MIN_ATTACK_MULT);
            }

            var _local1:Number = (MIN_ATTACK_MULT + ((this.attack_ / statScale_) * (MAX_ATTACK_MULT - MIN_ATTACK_MULT)));
            if (isDamaging()) {
                _local1 = (_local1 * 1.5);
            }
            if (statScale_ != 75) {
                statScale_ = 75
            }
            return (_local1);
        }

        private function restoreTexture():void {
            var _local1:TextureData = ObjectLibrary.typeToTextureData_[objectType_];
            texture_ = _local1.texture_;
            mask_ = _local1.mask_;
            animatedChar_ = _local1.animatedChar_;
            this.isDefaultTexture_ = true;
        }

        private function applyHexTexture():void {
            var _local1:Vector.<XML> = ObjectLibrary.hexableXmls_;
            var _local2:uint = Math.floor((Math.random() * _local1.length));
            var _local3:int = _local1[_local2].@type;
            var _local4:TextureData = ObjectLibrary.typeToTextureData_[_local3];
            texture_ = _local4.texture_;
            mask_ = _local4.mask_;
            animatedChar_ = _local4.animatedChar_;
            this.isDefaultTexture_ = false;
        }

        private function shoot(angle:Number):void {
            if (map_ == null || isStunned() || isPaused()) {
                return;
            }
            var _local2:int = equipment_[0];
            if (_local2 == -1) {
                map_.gs_.textBox_.addText(Parameters.SendError, "You do not have a weapon equipped!");
                return;
            }
            var _local3:XML = ObjectLibrary.typeToXML_[_local2];
            var _local4:int = getTimer();
            var _local5:Number = Number(_local3.RateOfFire);
            this.attackPeriod_ = ((1 / this.getAttackFrequency()) * (1 / _local5));
            if (_local4 < (attackStart_ + this.attackPeriod_)) {
                return;
            }
            doneAction(map_.gs_, Tutorial.ATTACK);
            map_.gs_.gsc_.playerCheatCheck();
            attackAngle_ = angle;
            attackStart_ = _local4;
            this.doShoot(attackStart_, _local2, _local3, attackAngle_, true, 0);
        }

        private function doShoot(time:int, itemType:int, itemXml:XML, angle:Number, isAttack:Boolean, slotIndex:int):void {
            var _local12:uint;
            var _local13:Projectile;
            var _local14:int;
            var _local15:int;
            var _local16:Number;
            var _local17:int;
            var _local6:int = ((itemXml.hasOwnProperty("NumProjectiles")) ? int(itemXml.NumProjectiles) : 1);
            var _local7:Number = (((itemXml.hasOwnProperty("ArcGap")) ? Number(itemXml.ArcGap) : 11.25) * Trig._km);
            var _local8:Vector.<Projectile> = new Vector.<Projectile>();
            var _local9:Number = (_local7 * (_local6 - 1));
            var _local10:Number = (angle - (_local9 / 2));
            var _local11:int;
            var itemData_:Object = this.equipData_[slotIndex];
            while (_local11 < _local6) {
                _local12 = getNextBulletId();
                _local13 = (_wW_._B_1(Projectile) as Projectile);
                _local13.reset(itemType, 0, objectId_, _local12, _local10, time);
                _local14 = int(_local13.projProps_.minDamage_);
                _local15 = int(_local13.projProps_.maxDamage_);
                if(itemData_ != null && itemData_.hasOwnProperty("DmgPercentage") && itemData_.DmgPercentage != 0) {
                    var _local18:int = int(itemData_.DmgPercentage);
                    _local14 += (_local14 * (_local18 / 100));
                    _local15 += (_local15 * (_local18 / 100));
                }
                _local16 = ((isAttack) ? this.getAttackMultiplier() : 1);
                _local17 = (map_.gs_.gsc_.getNextDamage(_local14, _local15) * _local16);
                if (time > (map_.gs_.moveRecords_.lastClearTime_ + 600)) {
                    _local17 = 0;
                }
                _local13.setDamage(_local17);
                if ((((_local11 == 0)) && (!((_local13.sound_ == null))))) {
                    SoundEffects.play(_local13.sound_, 0.75, false);
                }
                map_.addObj(_local13, (x_ + (Math.cos(angle) * 0.3)), (y_ + (Math.sin(angle) * 0.3)));
                map_.gs_.gsc_.playerShoot(time, _local13);
                _local10 = (_local10 + _local7);
                _local11++;

                _mindmg = _local14;
                _maxdmg = _local15;
            }
        }

    }
}//package com.company.assembleegameclient.objects
