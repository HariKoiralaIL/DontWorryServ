package com.company.assembleegameclient.objects {
    import com.company.assembleegameclient.engine3d.MeshModel;
    import com.company.assembleegameclient.engine3d.Object3D;
    import com.company.assembleegameclient.map.Square;
    import com.company.assembleegameclient.map.GameCamera;
    import com.company.assembleegameclient.map.GameMap;
    import com.company.assembleegameclient.net.messages.data.LocationData;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.util.ConditionEffect;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.assembleegameclient.util.BloodComposition;
    import com.company.assembleegameclient.util.MaskedImage;
    import com.company.assembleegameclient.util.AnimatedChar;
    import com.company.ui.SimpleText;
    import com.company.util.AssetLibrary;
    import com.company.util.BitmapUtil;
    import com.company.util.ConversionUtil;
    import com.company.util.GraphicHelper;
    import com.company.util.MoreColorUtil;
    import com.company.util.PointUtil;
    import com.company.util._G_;

    import flash.display.BitmapData;
    import flash.display.GradientType;
    import flash.display.GraphicsBitmapFill;
    import flash.display.GraphicsGradientFill;
    import flash.display.GraphicsPath;
    import flash.display.IGraphicsData;
    import flash.filters.ColorMatrixFilter;
    import flash.filters.GlowFilter;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Vector3D;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getTimer;

    import mapoverlay.CharacterStatusText;

    import particleeffects.ExplosionEffect;
    import particleeffects.HitEffect;
    import particleeffects.ParticleEffect;

    import spriteanimation.Animations;
    import spriteanimation.AnimationsData;

    import audio.SoundEffects;

    public class GameObject extends BasicObject {

        private static const MOVE_EPSILON:Number = 1E-5;
        private static const MOVE_EPSILON_NEG:Number = -(MOVE_EPSILON);
        protected static const GRAYSCALE_FILTER:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil._0M_l);
        public static const ATTACK_PERIOD_MS:int = 300;

        public static function getDamageAfterDefense(damage:int, defense:int, armorPierced:Boolean, condition:int):int {
            var _local5:int = defense;
            if (((armorPierced) || (!(((condition & ConditionEffect.ARMOR_BROKEN_BIT) == 0))))) {
                _local5 = 0;
            } else {
                if ((condition & ConditionEffect.ARMORED_BIT) != 0) {
                    _local5 = (_local5 * 2);
                }
            }
            var _local6:int = ((damage * 3) / 20);
            var _local7:int = Math.max(_local6, (damage - _local5));
            if ((condition & ConditionEffect.INVULNERABLE_BIT) != 0) {
                _local7 = 0;
            }
            return (_local7);
        }

        public function GameObject(xml:XML) {
            var _local4:int;
            this.props_ = ObjectLibrary.defaultProps_;
            this.startPos_ = new Point();
            this.tickPos_ = new Point();
            this.moveVec_ = new Vector3D();
            this.bitmapFill_ = new GraphicsBitmapFill(null, null, false, false);
            this.path_ = new GraphicsPath(GraphicHelper._H_2, null);
            this.quadVerts_ = new Vector.<Number>();
            this.unusedVec_ = new Vector.<Number>();
            this.drawMatrix_ = new Matrix();
            super();
            if (xml == null) {
                return;
            }
            this.objectType_ = int(xml.@type);
            this.props_ = ObjectLibrary.typeToProps_[this.objectType_];
            hasShadow_ = (this.props_.shadowSize_ > 0);
            var _local2:TextureData = ObjectLibrary.typeToTextureData_[this.objectType_];
            this.texture_ = _local2.texture_;
            this.mask_ = _local2.mask_;
            this.animatedChar_ = _local2.animatedChar_;
            this.randomTextureData_ = _local2.randomTextureData_;
            if (_local2.effectProps_ != null) {
                this.effect_ = ParticleEffect.fromProps(_local2.effectProps_, this);
            }
            if (this.texture_ != null) {
                this.textureScale_ = (this.texture_.height / 8);
            }
            if (xml.hasOwnProperty("Model")) {
                this.obj3D_ = MeshModel.createObject3D(String(xml.Model));
            }
            var _local3:AnimationsData = ObjectLibrary.typeToAnimationsData_[this.objectType_];
            if (_local3 != null) {
                this.animations_ = new Animations(_local3);
            }
            z_ = this.props_.z_;
            this.flying_ = this.props_.flying_;
            if (xml.hasOwnProperty("MaxHitPoints")) {
                this.HP_ = (this.maxHP_ = int(xml.MaxHitPoints));
            }
            if (xml.hasOwnProperty("Defense")) {
                this.defense_ = int(xml.Defense);
            }
            if (xml.hasOwnProperty("SlotTypes")) {
                this.slotTypes_ = ConversionUtil._04n(xml.SlotTypes);
                this.equipment_ = new Vector.<int>(this.slotTypes_.length);
                this.equipData_ = new Vector.<Object>(this.slotTypes_.length);
                _local4 = 0;
                while (_local4 < this.equipment_.length) {
                    this.equipment_[_local4] = -1;
                    this.equipData_[_local4] = null;
                    _local4++;
                }
            }
            if (xml.hasOwnProperty("Tex1")) {
                this.tex1Id_ = int(xml.Tex1);
            }
            if (xml.hasOwnProperty("Tex2")) {
                this.tex2Id_ = int(xml.Tex2);
            }
            if (xml.hasOwnProperty("Skin")) {
                this.setSkin(int(xml.SkinId));
            }
            this.props_.loadSounds();
        }
        public var props_:ObjectProperties;
        public var name_:String;
        public var radius_:Number = 0.5;
        public var facing_:Number = 0;
        public var flying_:Boolean = false;
        public var attackAngle_:Number = 0;
        public var attackStart_:int = 0;
        public var animatedChar_:AnimatedChar = null;
        public var texture_:BitmapData = null;
        public var mask_:BitmapData = null;
        public var randomTextureData_:Vector.<TextureData> = null;
        public var obj3D_:Object3D = null;
        public var effect_:ParticleEffect = null;
        public var animations_:Animations = null;
        public var dead_:Boolean = false;
        public var maxHP_:int = 200;
        public var HP_:int = 200;
        public var size_:int = 100;
        public var level_:int = -1;
        public var defense_:int = 0;
        public var slotTypes_:Vector.<int> = null;
        public var equipment_:Vector.<int> = null;
        /* public var backpack1:Vector.<int> = null;
        public var backpack2:Vector.<int> = null; */
        public var equipData_:Vector.<Object> = null;
        public var condition_:uint = 0;
        public var isInteractive_:Boolean = false;
        public var objectType_:int;
        public var sinkLevel_:int = 0;
        public var hallucinationTex_:BitmapData = null;
        public var colorFlash_:ColorFlash = null;
        public var connectedMask_:int = -1;
        public var nameText_:SimpleText = null;
        public var nameBitmap_:BitmapData = null;
        public var skinId_:int = -1;
        public var tempSkinId_:int = -1;
        public var pvp_:Boolean = false;
        public var team_:int = 0;
        protected var portrait_:BitmapData = null;
        protected var textureCache_:Dictionary = null;
        protected var tex1Id_:int = 0;
        protected var tex2Id_:int = 0;
        protected var moveStartTime_:int = 0;
        protected var tickId_:int = -1;
        protected var startPos_:Point;
        protected var tickPos_:Point;
        protected var moveVec_:Vector3D;
        protected var bitmapFill_:GraphicsBitmapFill;
        protected var path_:GraphicsPath;
        protected var quadVerts_:Vector.<Number>;
        protected var unusedVec_:Vector.<Number>;
        protected var drawMatrix_:Matrix;
        protected var shadowFill_:GraphicsGradientFill = null;
        protected var shadowPath_:GraphicsPath = null;
        private var nextBulletId_:uint = 1;
        private var textureScale_:Number = 1;
        private var nameFill_:GraphicsBitmapFill = null;
        private var namePath_:GraphicsPath = null;
        private var condIcons_:Vector.<BitmapData> = null;
        private var condIconFills_:Vector.<GraphicsBitmapFill> = null;
        private var condIconPaths_:Vector.<GraphicsPath> = null;

        override public function dispose():void {
            var _local1:Object;
            var _local2:BitmapData;
            var _local3:Dictionary;
            var _local4:Object;
            var _local5:BitmapData;
            super.dispose();
            this.texture_ = null;
            if (this.portrait_ != null) {
                this.portrait_.dispose();
                this.portrait_ = null;
            }
            if (this.textureCache_ != null) {
                for each (_local1 in this.textureCache_) {
                    _local2 = (_local1 as BitmapData);
                    if (_local2 != null) {
                        _local2.dispose();
                    } else {
                        _local3 = (_local1 as Dictionary);
                        for each (_local4 in _local3) {
                            _local5 = (_local4 as BitmapData);
                            if (_local5 != null) {
                                _local5.dispose();
                            }
                        }
                    }
                }
                this.textureCache_ = null;
            }
            if (this.obj3D_ != null) {
                this.obj3D_.dispose();
                this.obj3D_ = null;
            }
            this.slotTypes_ = null;
            this.equipment_ = null;
            this.equipData_ = null;
            this.nameText_ = null;
            if (this.nameBitmap_ != null) {
                this.nameBitmap_.dispose();
                this.nameBitmap_ = null;
            }
            this.nameFill_ = null;
            this.namePath_ = null;
            this.bitmapFill_ = null;
            this.path_.commands = null;
            this.path_.data = null;
            this.quadVerts_ = null;
            this.unusedVec_ = null;
            this.drawMatrix_ = null;
            this.condIcons_ = null;
            this.condIconFills_ = null;
            this.condIconPaths_ = null;
            this.shadowFill_ = null;
            if (this.shadowPath_ != null) {
                this.shadowPath_.commands = null;
                this.shadowPath_.data = null;
                this.shadowPath_ = null;
            }
        }

        override public function addTo(map:GameMap, x:Number, y:Number):Boolean {
            map_ = map;
            this.startPos_.x = (this.tickPos_.x = x);
            this.startPos_.y = (this.tickPos_.y = y);
            if (!this.moveTo(x, y)) {
                map_ = null;
                return (false);
            }
            if (this.effect_ != null) {
                map_.addObj(this.effect_, x, y);
            }
            return (true);
        }

        override public function removeFromMap():void {
            if (((this.props_.static_) && (!((square_ == null))))) {
                if (square_.obj_ == this) {
                    square_.obj_ = null;
                }
                square_ = null;
            }
            if (this.effect_ != null) {
                map_.removeObj(this.effect_.objectId_);
            }
            super.removeFromMap();
            this.dispose();
        }

        override public function update(time:int, dt:int):Boolean {
            var _local4:int;
            var _local5:Number;
            var _local6:Number;
            var _local3:Boolean;
            if (!(((this.moveVec_.x == 0)) && ((this.moveVec_.y == 0)))) {
                if (this.tickId_ < map_.gs_.gsc_.lastTickId_) {
                    this.moveVec_.x = 0;
                    this.moveVec_.y = 0;
                    this.moveTo(this.tickPos_.x, this.tickPos_.y);
                } else {
                    _local4 = (time - this.moveStartTime_);
                    _local5 = (this.startPos_.x + (_local4 * this.moveVec_.x));
                    _local6 = (this.startPos_.y + (_local4 * this.moveVec_.y));
                    this.moveTo(_local5, _local6);
                    _local3 = true;
                }
            }
            if (this.props_.whileMoving_ != null) {
                if (!_local3) {
                    z_ = this.props_.z_;
                    this.flying_ = this.props_.flying_;
                } else {
                    z_ = this.props_.whileMoving_.z_;
                    this.flying_ = this.props_.whileMoving_.flying_;
                }
            }
            return (true);
        }

        override public function draw(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
            var _local4:BitmapData = this.getTexture(camera, time);
            if (this.props_.drawOnGround_) {
                if (square_.faces_.length == 0) {
                    return;
                }
                this.path_.data = square_.faces_[0].face_.screenVertices_;
                this.bitmapFill_.bitmapData = _local4;
                square_.baseTexMatrix_.calculateTextureMatrix(this.path_.data);
                this.bitmapFill_.matrix = square_.baseTexMatrix_.tToS_;
                graphicsData.push(this.bitmapFill_);
                graphicsData.push(this.path_);
                graphicsData.push(GraphicHelper.END_FILL);
                return;
            }
            if (this.obj3D_ != null) {
                this.obj3D_.draw(graphicsData, camera, this.props_.color_, _local4);
                return;
            }
            var _local5:int = _local4.width;
            var _local6:int = _local4.height;
            var _local7:int = (square_.sink_ + this.sinkLevel_);
            if ((((_local7 > 0)) && (((this.flying_) || (((!((square_.obj_ == null))) && (square_.obj_.props_.protectFromSink_))))))) {
                _local7 = 0;
            }
            this.quadVerts_.length = 0;
            this.quadVerts_.push((screenVec_[3] - (_local5 / 2)), ((screenVec_[4] - _local6) + _local7), (screenVec_[3] + (_local5 / 2)), ((screenVec_[4] - _local6) + _local7), (screenVec_[3] + (_local5 / 2)), screenVec_[4], (screenVec_[3] - (_local5 / 2)), screenVec_[4]);
            this.path_.data = this.quadVerts_;
            this.bitmapFill_.bitmapData = _local4;
            this.drawMatrix_.identity();
            this.drawMatrix_.translate(this.quadVerts_[0], this.quadVerts_[1]);
            this.bitmapFill_.matrix = this.drawMatrix_;
            graphicsData.push(this.bitmapFill_);
            graphicsData.push(this.path_);
            graphicsData.push(GraphicHelper.END_FILL);
            if (((((!(this.isPaused())) && (!(((this.condition_ & ConditionEffect.ICON_BITMASK) == 0))))) && (!(Parameters._0F_o)))) {
                this.drawConditionIcons(graphicsData, camera, time);
            }
            if (((((this.props_.showName_) && (!((this.name_ == null))))) && (!((this.name_.length == 0))))) {
                this.drawName(graphicsData, camera);
            }
        }

        override public function drawShadow(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
            if (this.shadowFill_ == null) {
                this.shadowFill_ = new GraphicsGradientFill(GradientType.RADIAL, [this.props_.shadowColor_, this.props_.shadowColor_], [0.5, 0], null, new Matrix());
                this.shadowPath_ = new GraphicsPath(GraphicHelper._H_2, new Vector.<Number>());
            }
            var _local4:Number = (((this.size_ / 100) * (this.props_.shadowSize_ / 100)) * this.textureScale_);
            var _local5:Number = (30 * _local4);
            var _local6:Number = (15 * _local4);
            this.shadowFill_.matrix.createGradientBox((_local5 * 2), (_local6 * 2), 0, (screenVec_[0] - _local5), (screenVec_[1] - _local6));
            graphicsData.push(this.shadowFill_);
            this.shadowPath_.data.length = 0;
            this.shadowPath_.data.push((screenVec_[0] - _local5), (screenVec_[1] - _local6), (screenVec_[0] + _local5), (screenVec_[1] - _local6), (screenVec_[0] + _local5), (screenVec_[1] + _local6), (screenVec_[0] - _local5), (screenVec_[1] + _local6)); //unresolved function??
            graphicsData.push(this.shadowPath_);
            graphicsData.push(GraphicHelper.END_FILL);
        }

        public function setObjectId(id:int):void {
            var _local2:TextureData;
            objectId_ = id;
            if (this.randomTextureData_ != null) {
                _local2 = this.randomTextureData_[(objectId_ % this.randomTextureData_.length)];
                this.texture_ = _local2.texture_;
                this.mask_ = _local2.mask_;
                this.animatedChar_ = _local2.animatedChar_;
            }
        }

        public function setAltTexture(altId:int):void {
            var _local3:TextureData;
            var _local2:TextureData = ObjectLibrary.typeToTextureData_[this.objectType_];
            if (altId == 0) {
                _local3 = _local2;
            } else {
                _local3 = _local2.getAltTextureData(altId);
                if (_local3 == null) {
                    return;
                }
            }
            this.texture_ = _local3.texture_;
            this.mask_ = _local3.mask_;
            this.animatedChar_ = _local3.animatedChar_;
            if (this.effect_ != null) {
                map_.removeObj(this.effect_.objectId_);
                this.effect_ = null;
            }
            if (_local3.effectProps_ != null) {
                this.effect_ = ParticleEffect.fromProps(_local3.effectProps_, this);
                if (map_ != null) {
                    map_.addObj(this.effect_, x_, y_);
                }
            }
        }

        public function setTex1(texId:int):void {
            if (texId == this.tex1Id_) {
                return;
            }
            this.tex1Id_ = texId;
            this.textureCache_ = new Dictionary();
            this.portrait_ = null;
        }

        public function setTex2(texId:int):void {
            if (texId == this.tex2Id_) {
                return;
            }
            this.tex2Id_ = texId;
            this.textureCache_ = new Dictionary();
            this.portrait_ = null;
        }

        public function setSkin(skinId:int, preview:Boolean = false):void {
            if (skinId == this.skinId_ && !preview) return;
            if (!preview)
                this.skinId_ = skinId;
            if (skinId == -1 || ObjectLibrary.typeToTextureData_[skinId] == null) {
                var _local2:TextureData = ObjectLibrary.typeToTextureData_[this.objectType_];
                this.texture_ = _local2.texture_;
                this.mask_ = _local2.mask_;
                this.animatedChar_ = _local2.animatedChar_;
                this.randomTextureData_ = _local2.randomTextureData_;
            } else {
                var _local2:TextureData = ObjectLibrary.typeToTextureData_[skinId];
                this.texture_ = _local2.texture_;
                this.mask_ = _local2.mask_;
                this.animatedChar_ = _local2.animatedChar_;
                this.randomTextureData_ = _local2.randomTextureData_;
            }
        }

        public function previewSkin(skinId:int):void {
            if (skinId == this.tempSkinId_) return;
            if (skinId == -1)
                this.setSkin(this.skinId_, true);
            else
                this.setSkin(skinId, true);
            this.tempSkinId_ = skinId;
        }

        public function playSound(soundId:int):void {
            SoundEffects.play(this.props_.sounds_[soundId]);
        }

        public function isQuiet():Boolean {
            return (!(((this.condition_ & ConditionEffect.QUIET_BIT) == 0)));
        }

        public function isWeak():Boolean {
            return (!(((this.condition_ & ConditionEffect.WEAK_BIT) == 0)));
        }

        public function isSlowed():Boolean {
            return (!(((this.condition_ & ConditionEffect.SLOWED_BIT) == 0)));
        }

        public function isSick():Boolean {
            return (!(((this.condition_ & ConditionEffect.SICK_BIT) == 0)));
        }

        public function isDazed():Boolean {
            return (!(((this.condition_ & ConditionEffect.DAZED_BIT) == 0)));
        }

        public function isStunned():Boolean {
            return (!(((this.condition_ & ConditionEffect.STUNNED_BIT) == 0)));
        }

        public function isBlind():Boolean {
            return (!(((this.condition_ & ConditionEffect.BLIND_BIT) == 0)));
        }

        public function isDrunk():Boolean {
            return (!(((this.condition_ & ConditionEffect.DRUNK_BIT) == 0)));
        }

        public function hasConditionN_c():Boolean {
            return (!(((this.condition_ & ConditionEffect.BLUR_BIT) == 0)));
        }

        public function isConfused():Boolean {
            return (!(((this.condition_ & ConditionEffect.CONFUSED_BIT) == 0)));
        }

        public function isStunImmune():Boolean {
            return (!(((this.condition_ & ConditionEffect.STUN_IMMUNE_BIT) == 0)));
        }

        public function isInvisible():Boolean {
            return (!(((this.condition_ & ConditionEffect.INVISIBLE_BIT) == 0)));
        }

        public function isParalyzed():Boolean {
            return (!(((this.condition_ & ConditionEffect.PARALYZED_BIT) == 0)));
        }

        public function isSpeedy():Boolean {
            return (!(((this.condition_ & ConditionEffect.SPEEDY_BIT) == 0)));
        }

        public function isNinjaSpeedy():Boolean {
            return (!(((this.condition_ & ConditionEffect.HALLUCINATING_BIT) == 0)));
        }

        public function isHealing():Boolean {
            return (!(((this.condition_ & ConditionEffect.HEALING_BIT) == 0)));
        }

        public function isDamaging():Boolean {
            return (!(((this.condition_ & ConditionEffect.DAMAGING_BIT) == 0)));
        }

        public function isBerserk():Boolean {
            return (!(((this.condition_ & ConditionEffect.BERSERK_BIT) == 0)));
        }

        public function isPaused():Boolean {
            return (!(((this.condition_ & ConditionEffect.PAUSED_BIT) == 0)));
        }

        public function isStasis():Boolean {
            return (!(((this.condition_ & ConditionEffect.STASIS_BIT) == 0)));
        }

        public function isInvincible():Boolean {
            return (!(((this.condition_ & ConditionEffect.INVINCIBLE_BIT) == 0)));
        }

        public function isInvulnerable():Boolean {
            return (!(((this.condition_ & ConditionEffect.INVULNERABLE_BIT) == 0)));
        }

        public function isArmored():Boolean {
            return (!(((this.condition_ & ConditionEffect.ARMORED_BIT) == 0)));
        }

        public function isArmorBroken():Boolean {
            return (!(((this.condition_ & ConditionEffect.ARMOR_BROKEN_BIT) == 0)));
        }

        public function noCharactersNearby():Boolean {
            var _local1:GameObject;
            var _local2:int;
            var _local3:int;
            for each (_local1 in map_.goDict_) {
                if (!(_local1 is Player)) {
                    if ((_local1 is Character)) {
                        _local2 = (((x_ > _local1.x_)) ? (x_ - _local1.x_) : (_local1.x_ - x_));
                        _local3 = (((y_ > _local1.y_)) ? (y_ - _local1.y_) : (_local1.y_ - y_));
                        if ((((_local2 < 20)) && ((_local3 < 20)))) {
                            return (false);
                        }
                    }
                }
            }
            return (true);
        }
        public function canBeHitBy(attacker:GameObject) {
            return (this.pvp_ && attacker.pvp_ && (this.team_ == 0 || this.team_ != attacker.team_));
        }
        public function getName():String {
            return ((((((this.name_ == null)) || ((this.name_ == "")))) ? ObjectLibrary.typeToDisplayId_[this.objectType_] : this.name_));
        }

        public function getColor():uint {
            return (BitmapUtil._B_n(this.texture_));
        }

        public function getNextBulletId():uint {
            var _local1:uint = this.nextBulletId_;
            this.nextBulletId_ = ((this.nextBulletId_ + 1) % 128);
            return (_local1);
        }

        public function distTo(loc:LocationData):Number {
            var _local2:Number = (loc.x_ - x_);
            var _local3:Number = (loc.y_ - y_);
            return (Math.sqrt(((_local2 * _local2) + (_local3 * _local3))));
        }

        public function moveTo(x:Number, y:Number):Boolean {
            var _local3:Square = map_.getSquare(x, y);
            if (_local3 == null) {
                return (false);
            }
            x_ = x;
            y_ = y;
            if (this.props_.static_) {
                if (square_ != null) {
                    square_.obj_ = null;
                }
                _local3.obj_ = this;
            }
            square_ = _local3;
            if (this.obj3D_ != null) {
                this.obj3D_.setPosition(x_, y_, 0, this.props_.rotation_);
            }
            return (true);
        }

        public function onGoto(x:Number, y:Number, time:int):void {
            this.moveTo(x, y);
            this.moveStartTime_ = time;
            this.tickPos_.x = x;
            this.tickPos_.y = y;
            this.startPos_.x = x;
            this.startPos_.y = y;
            this.moveVec_.x = 0;
            this.moveVec_.y = 0;
        }

        public function onTickPos(x:Number, y:Number, tickTime:int, tickId:int):void {
            if (this.tickId_ < map_.gs_.gsc_.lastTickId_) {
                this.moveTo(this.tickPos_.x, this.tickPos_.y);
            }
            this.moveStartTime_ = map_.gs_.lastUpdate_;
            this.tickPos_.x = x;
            this.tickPos_.y = y;
            this.startPos_.x = x_;
            this.startPos_.y = y_;
            this.moveVec_.x = ((this.tickPos_.x - this.startPos_.x) / tickTime);
            this.moveVec_.y = ((this.tickPos_.y - this.startPos_.y) / tickTime);
            this.tickId_ = tickId;
        }

        public function damage(itemType:int, damage:int, effects:Vector.<uint>, kill:Boolean, proj:Projectile):void {
            var _local7:int;
            var _local8:uint;
            var _local9:ConditionEffect;
            var _local10:Boolean;
            if (kill) {
                this.dead_ = true;
            } else {
                if (effects != null) {
                    _local7 = 0;
                    for each (_local8 in effects) {
                        _local9 = null;
                        switch (_local8) {
                            case ConditionEffect.NOTHING:
                                break;
                            case ConditionEffect.QUIET:
                            case ConditionEffect.WEAK:
                            case ConditionEffect.SLOWED:
                            case ConditionEffect.SICK:
                            case ConditionEffect.DAZED:
                            case ConditionEffect.BLIND:
                            case ConditionEffect.HALLUCINATING:
                            case ConditionEffect.DRUNK:
                            case ConditionEffect.CONFUSED:
                            case ConditionEffect.STUN_IMMUNE:
                            case ConditionEffect.INVISIBLE:
                            case ConditionEffect.PARALYZED:
                            case ConditionEffect.SPEEDY:
                            case ConditionEffect.BLEEDING:
                            case ConditionEffect.STASIS:
                            case ConditionEffect.STASIS_IMMUNE:
                            case ConditionEffect.ARMOR_BROKEN:
                            case ConditionEffect.BLUR:
                                _local9 = ConditionEffect.effects_[_local8];
                                break;
                            case ConditionEffect.STUNNED:
                                if (this.isStunImmune()) {
                                    map_.mapOverlay_.addChild(new CharacterStatusText(this, "Immune", 0xFF0000, 3000));
                                } else {
                                    _local9 = ConditionEffect.effects_[_local8];
                                }
                                break;
                        }
                        if (_local9 != null) {
                            if ((this.condition_ | _local9.bit_) != this.condition_) {
                                this.condition_ = (this.condition_ | _local9.bit_);
                                map_.mapOverlay_.addChild(new CharacterStatusText(this, _local9.name_, 0xFF0000, 3000, _local7));
                                _local7 = (_local7 + 500);
                            }
                        }
                    }
                }
            }
            var _local6:Vector.<uint> = BloodComposition.getBloodComposition(this.objectType_, this.texture_, this.props_.bloodProb_, this.props_.bloodColor_);
            if (this.dead_) {
                map_.addObj(new ExplosionEffect(_local6, this.size_, 30), x_, y_);
            } else {
                if (proj != null) {
                    map_.addObj(new HitEffect(_local6, this.size_, 10, proj.angle_, proj.projProps_.speed_), x_, y_);
                } else {
                    map_.addObj(new ExplosionEffect(_local6, this.size_, 10), x_, y_);
                }
            }
            if (proj != null && this.pvp_ && map_.player_ == this)
                if (map_.goDict_[proj.ownerId_] is Player) {
                    damage = Math.max(1, damage / 5);
                }
            _local10 = this.isArmorBroken() || (proj != null && proj.projProps_.armorPiercing_);
            if (damage > 0) {
                if (!Parameters.data_["disableDamageText"]) {
                    map_.mapOverlay_.addChild(new CharacterStatusText(this, ("-" + (Parameters.data_["damageInfo"] ? (damage + " [" + HP_ + "]") : damage)), ((_local10) ? 0x9000FF : 0xFF0000), 1000));
                }
            }
            if (map_.player_ == this && proj != null) {
                map_.gs_.gsc_.sendVisibullet(proj.damage_, proj.ownerId_, proj.bulletId_, _local10);
            }
        }

        public function drawName(graphicsData:Vector.<IGraphicsData>, camera:GameCamera):void {
            if (this.nameBitmap_ == null) {
                this.nameText_ = this.makeNameText(this.name_);
                this.nameBitmap_ = this.generateNameBitmapData(this.nameText_);
                this.nameFill_ = new GraphicsBitmapFill(null, new Matrix(), false, false);
                this.namePath_ = new GraphicsPath(GraphicHelper._H_2, new Vector.<Number>());
            }
            var _local3:int = ((this.nameBitmap_.width / 2) + 1);
            var _local4:int = 30;
            var _local5:Vector.<Number> = this.namePath_.data;
            _local5.length = 0;
            _local5.push((screenVec_[0] - _local3), screenVec_[1], (screenVec_[0] + _local3), screenVec_[1], (screenVec_[0] + _local3), (screenVec_[1] + _local4), (screenVec_[0] - _local3), (screenVec_[1] + _local4));
            this.nameFill_.bitmapData = this.nameBitmap_;
            var _local6:Matrix = this.nameFill_.matrix;
            _local6.identity();
            _local6.translate(_local5[0], _local5[1]);
            graphicsData.push(this.nameFill_);
            graphicsData.push(this.namePath_);
            graphicsData.push(GraphicHelper.END_FILL);
        }

        public function setTexture(file:String, index:int):void {
            this.texture_ = AssetLibrary._xK_(file, index);
            this.textureScale_ = (this.texture_.height / 8);
        }

        public function getPortrait():BitmapData {
            var _local1:BitmapData;
            var _local2:int;
            if (this.portrait_ == null) {
                _local1 = (this.props_.portrait_ != null) ? this.props_.portrait_.getTexture() : this.texture_;
                _local2 = (4 / _local1.width) * 100;
                this.portrait_ = TextureRedrawer.resize(_local1, this.mask_, _local2, true, this.tex1Id_, this.tex2Id_);
                this.portrait_ = TextureRedrawer.outlineGlow(this.portrait_, 0, 0);
            }
            return (this.portrait_);
        }

        public function setAttack(itemType:int, angle:Number):void {
            this.attackAngle_ = angle;
            this.attackStart_ = getTimer();
        }

        public function drawConditionIcons(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
            var _local9:BitmapData;
            var _local10:GraphicsBitmapFill;
            var _local11:GraphicsPath;
            var _local12:Number;
            var _local13:Number;
            var _local14:Matrix;
            if (this.condIcons_ == null) {
                this.condIcons_ = new Vector.<BitmapData>();
                this.condIconFills_ = new Vector.<GraphicsBitmapFill>();
                this.condIconPaths_ = new Vector.<GraphicsPath>();
            }
            this.condIcons_.length = 0;
            var _local4:int = (time / 500);
            ConditionEffect.addConditionIcons(this.condition_, this.condIcons_, _local4);
            var _local5:Number = screenVec_[3];
            var _local6:Number = this.quadVerts_[1];
            var _local7:int = this.condIcons_.length;
            var _local8:int;
            while (_local8 < _local7) {
                _local9 = this.condIcons_[_local8];
                if (_local8 >= this.condIconFills_.length) {
                    this.condIconFills_.push(new GraphicsBitmapFill(null, new Matrix(), false, false));
                    this.condIconPaths_.push(new GraphicsPath(GraphicHelper._H_2, new Vector.<Number>()));
                }
                _local10 = this.condIconFills_[_local8];
                _local11 = this.condIconPaths_[_local8];
                _local10.bitmapData = _local9;
                _local12 = ((_local5 - ((_local9.width * _local7) / 2)) + (_local8 * _local9.width));
                _local13 = (_local6 - (_local9.height / 2));
                _local11.data.length = 0;
                _local11.data.push(_local12, _local13, (_local12 + _local9.width), _local13, (_local12 + _local9.width), (_local13 + _local9.height), _local12, (_local13 + _local9.height));
                _local14 = _local10.matrix;
                _local14.identity();
                _local14.translate(_local12, _local13);
                graphicsData.push(_local10);
                graphicsData.push(_local11);
                graphicsData.push(GraphicHelper.END_FILL);
                _local8++;
            }
        }

        public function toString():String {
            return ("[" + getQualifiedClassName(this) + " id: " + objectId_ + " type: " + ObjectLibrary.typeToDisplayId_[this.objectType_] + " pos: " + x_ + ", " + y_ + "]");
        }

        protected function makeNameText(name:String):SimpleText {
            var _local2:SimpleText = new SimpleText(16, 0xFFFFFF, false, 0, 0, "Myriad Pro");
            _local2.setBold(true);
            _local2.text = name;
            _local2.updateMetrics();
            return (_local2);
        }

        protected function generateNameBitmapData(nameText:SimpleText):BitmapData {
            var _local2:BitmapData = new BitmapData(nameText.width, 64, true, 0);
            _local2.draw(nameText, null);
            _local2.applyFilter(_local2, _local2.rect, PointUtil._P_5, new GlowFilter(0, 1, 3, 3, 2, 1));
            return (_local2);
        }

        protected function getHallucinationTexture():BitmapData {
            if (this.hallucinationTex_ == null) {
                this.hallucinationTex_ = AssetLibrary._xK_("lofiChar8x8", int((Math.random() * 239)));
            }
            return (this.hallucinationTex_);
        }

        protected function getTexture(camera:GameCamera, time:int):BitmapData {
            var _local6:Number;
            var _local7:int;
            var _local8:MaskedImage;
            var _local9:int;
            var _local10:BitmapData;
            var _local11:int;
            var _local12:BitmapData;
            var _local3:BitmapData = this.texture_;
            var _local4:int = this.size_;
            var _local5:BitmapData;
            if (this.animatedChar_ != null) {
                _local6 = 0;
                _local7 = AnimatedChar.STAND;
                if (time < (this.attackStart_ + ATTACK_PERIOD_MS)) {
                    if (!this.props_.dontFaceAttacks_) {
                        this.facing_ = this.attackAngle_;
                    }
                    _local6 = (((time - this.attackStart_) % ATTACK_PERIOD_MS) / ATTACK_PERIOD_MS);
                    _local7 = AnimatedChar.ATTACK;
                } else {
                    if (((!((this.moveVec_.x == 0))) || (!((this.moveVec_.y == 0))))) {
                        _local9 = (0.5 / this.moveVec_.length);
                        _local9 = (_local9 + (400 - (_local9 % 400)));
                        if ((((((((this.moveVec_.x > MOVE_EPSILON)) || ((this.moveVec_.x < MOVE_EPSILON_NEG)))) || ((this.moveVec_.y > MOVE_EPSILON)))) || ((this.moveVec_.y < MOVE_EPSILON_NEG)))) {
                            this.facing_ = Math.atan2(this.moveVec_.y, this.moveVec_.x);
                            _local7 = AnimatedChar.WALK;
                        } else {
                            _local7 = AnimatedChar.STAND;
                        }
                        _local6 = ((time % _local9) / _local9);
                    }
                }
                _local8 = this.animatedChar_.imageFromFacing(this.facing_, camera, _local7, _local6);
                _local3 = _local8.image_;
                _local5 = _local8.mask_;
            } else {
                if (this.animations_ != null) {
                    _local10 = this.animations_.getTexture(time);
                    if (_local10 != null) {
                        _local3 = _local10;
                    }
                }
            }
            if (((this.props_.drawOnGround_) || (!((this.obj3D_ == null))))) {
                return (_local3);
            }
            if (camera.isHallucinating_) {
                _local11 = (((_local3 == null)) ? 8 : _local3.width);
                _local3 = this.getHallucinationTexture();
                _local5 = null;
                _local4 = (this.size_ * Math.min(1.5, (_local11 / _local3.width)));
            }
            if (this.isStasis()) {
                _local3 = _G_._R_9(_local3, GRAYSCALE_FILTER);
            }
            if (this.colorFlash_ != null) {
                if (!this.colorFlash_.isFinished(time)) {
                    _local3 = this.colorFlash_.apply(_local3, time);
                } else {
                    this.colorFlash_ = null;
                }
            }
            if ((((this.tex1Id_ == 0)) && ((this.tex2Id_ == 0)))) {
                _local3 = TextureRedrawer.redraw(_local3, _local4, false, 0, 0);
            } else {
                _local12 = null;
                if (this.textureCache_ == null) {
                    this.textureCache_ = new Dictionary();
                } else {
                    _local12 = this.textureCache_[_local3];
                }
                if (_local12 == null) {
                    _local12 = TextureRedrawer.resize(_local3, _local5, _local4, false, this.tex1Id_, this.tex2Id_);
                    _local12 = TextureRedrawer.outlineGlow(_local12, 0, 0);
                    this.textureCache_[_local3] = _local12;
                }
                _local3 = _local12;
            }
            return (_local3);
        }

    }
}//package com.company.assembleegameclient.objects
