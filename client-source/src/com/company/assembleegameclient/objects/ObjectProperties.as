package com.company.assembleegameclient.objects {
    import flash.utils.Dictionary;

    import audio.SoundEffects;

    public class ObjectProperties {

        public function ObjectProperties(xml:XML) {
            var _local2:XML;
            var _local3:XML;
            var _local4:int;
            this.projectiles_ = new Dictionary();
            super();
            if (xml == null) {
                return;
            }
            this.type_ = int(xml.@type);
            this.id_ = String(xml.@id);
            this.displayId_ = this.id_;
            if (xml.hasOwnProperty("DisplayId")) {
                this.displayId_ = xml.DisplayId;
            }
            this.shadowSize_ = ((xml.hasOwnProperty("ShadowSize")) ? xml.ShadowSize : 100);
            this.isPlayer_ = xml.hasOwnProperty("Player");
            this.isEnemy_ = xml.hasOwnProperty("Enemy");
            this.drawOnGround_ = xml.hasOwnProperty("DrawOnGround");
            if (((this.drawOnGround_) || (xml.hasOwnProperty("DrawUnder")))) {
                this.drawUnder_ = true;
            }
            this.occupySquare_ = xml.hasOwnProperty("OccupySquare");
            this.fullOccupy_ = xml.hasOwnProperty("FullOccupy");
            this.enemyOccupySquare_ = xml.hasOwnProperty("EnemyOccupySquare");
            this.static_ = xml.hasOwnProperty("Static");
            this.noMiniMap_ = xml.hasOwnProperty("NoMiniMap");
            this.protectFromGroundDamage_ = xml.hasOwnProperty("ProtectFromGroundDamage");
            this.protectFromSink_ = xml.hasOwnProperty("ProtectFromSink");
            this.flying_ = xml.hasOwnProperty("Flying");
            this.showName_ = xml.hasOwnProperty("ShowName");
            this.dontFaceAttacks_ = xml.hasOwnProperty("DontFaceAttacks");
            if (xml.hasOwnProperty("Z")) {
                this.z_ = Number(xml.Z);
            }
            if (xml.hasOwnProperty("Color")) {
                this.color_ = uint(xml.Color);
            }
            if (xml.hasOwnProperty("Size")) {
                this.minSize_ = (this.maxSize_ = xml.Size);
            } else {
                if (xml.hasOwnProperty("MinSize")) {
                    this.minSize_ = xml.MinSize;
                }
                if (xml.hasOwnProperty("MaxSize")) {
                    this.maxSize_ = xml.MaxSize;
                }
                if (xml.hasOwnProperty("SizeStep")) {
                    this.sizeStep_ = xml.SizeStep;
                }
            }
            this.oldSound_ = ((xml.hasOwnProperty("OldSound")) ? String(xml.OldSound) : null);
            for each (_local2 in xml.Projectile) {
                _local4 = int(_local2.@id);
                this.projectiles_[_local4] = new ProjectileProperties(_local2);
            }
            this.angleCorrection_ = ((xml.hasOwnProperty("AngleCorrection")) ? ((Number(xml.AngleCorrection) * Math.PI) / 4) : 0);
            this.rotation_ = ((xml.hasOwnProperty("Rotation")) ? xml.Rotation : 0);
            if (xml.hasOwnProperty("BloodProb")) {
                this.bloodProb_ = Number(xml.BloodProb);
            }
            if (xml.hasOwnProperty("BloodColor")) {
                this.bloodColor_ = uint(xml.BloodColor);
            }
            if (xml.hasOwnProperty("ShadowColor")) {
                this.shadowColor_ = uint(xml.ShadowColor);
            }
            for each (_local3 in xml.Sound) {
                if (this.sounds_ == null) {
                    this.sounds_ = {};
                }
                this.sounds_[int(_local3.@id)] = _local3.toString();
            }
            if (xml.hasOwnProperty("Portrait")) {
                this.portrait_ = new TextureData(XML(xml.Portrait));
            }
            if (xml.hasOwnProperty("WhileMoving")) {
                this.whileMoving_ = new WhileMovingProperties(XML(xml.WhileMoving));
            }
        }
        public var type_:int;
        public var id_:String;
        public var displayId_:String;
        public var shadowSize_:int;
        public var isPlayer_:Boolean = false;
        public var isEnemy_:Boolean = false;
        public var drawOnGround_:Boolean = false;
        public var drawUnder_:Boolean = false;
        public var occupySquare_:Boolean = false;
        public var fullOccupy_:Boolean = false;
        public var enemyOccupySquare_:Boolean = false;
        public var static_:Boolean = false;
        public var noMiniMap_:Boolean = false;
        public var protectFromGroundDamage_:Boolean = false;
        public var protectFromSink_:Boolean = false;
        public var z_:Number = 0;
        public var flying_:Boolean = false;
        public var color_:uint = 0xFFFFFF;
        public var showName_:Boolean = false;
        public var dontFaceAttacks_:Boolean = false;
        public var bloodProb_:Number = 0;
        public var bloodColor_:uint = 0xFF0000;
        public var shadowColor_:uint = 0;
        public var sounds_:Object = null;
        public var portrait_:TextureData = null;
        public var minSize_:int = 100;
        public var maxSize_:int = 100;
        public var sizeStep_:int = 5;
        public var whileMoving_:WhileMovingProperties = null;
        public var oldSound_:String = null;
        public var projectiles_:Dictionary;
        public var angleCorrection_:Number = 0;
        public var rotation_:Number = 0;

        public function loadSounds():void {
            var _local1:String;
            if (this.sounds_ == null) {
                return;
            }
            for each (_local1 in this.sounds_) {
                SoundEffects.load(_local1);
            }
        }

        public function getSize():int {
            if (this.minSize_ == this.maxSize_) {
                return (this.minSize_);
            }
            var _local1:int = ((this.maxSize_ - this.minSize_) / this.sizeStep_);
            return ((this.minSize_ + (int((Math.random() * _local1)) * this.sizeStep_)));
        }

    }
}//package com.company.assembleegameclient.objects

class WhileMovingProperties {

    public var z_:Number = 0;
    public var flying_:Boolean = false;

    public function WhileMovingProperties(xml:XML) {
        if (xml.hasOwnProperty("Z")) {
            this.z_ = Number(xml.Z);
        }
        this.flying_ = xml.hasOwnProperty("Flying");
    }
}
