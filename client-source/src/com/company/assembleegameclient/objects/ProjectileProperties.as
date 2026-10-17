package com.company.assembleegameclient.objects {

    import com.company.assembleegameclient.util.ConditionEffect;

    import com.company.assembleegameclient.util.*;

    public class ProjectileProperties {

        public function ProjectileProperties(xml:XML) {
            var _local2:XML;
            super();
            this.bulletType_ = int(xml.@id);
            this.objectId_ = xml.ObjectId;
            this.lifetime_ = int(xml.LifetimeMS);
            this.speed_ = int(xml.Speed);
            this.size_ = ((xml.hasOwnProperty("Size")) ? Number(xml.Size) : -1);
            if (xml.hasOwnProperty("Damage")) {
                this.minDamage_ = (this.maxDamage_ = int(xml.Damage));
            } else {
                this.minDamage_ = int(xml.MinDamage);
                this.maxDamage_ = int(xml.MaxDamage);
            }
            for each (_local2 in xml.ConditionEffect) {
                if (this.effects_ == null) {
                    this.effects_ = new Vector.<uint>();
                }
                this.effects_.push(ConditionEffect.getIndexByName(String(_local2)));
            }
            this.multiHit_ = xml.hasOwnProperty("MultiHit");
            this.passesCover_ = xml.hasOwnProperty("PassesCover");
            this.armorPiercing_ = xml.hasOwnProperty("ArmorPiercing");
            this.particleTrail_ = xml.hasOwnProperty("ParticleTrail");
            this.trailColor_ = ((this.particleTrail_) ? Number(xml.ParticleTrail) : Number(0xFF00FF));
            if (this.trailColor_ == 0) {
                this.trailColor_ = 0xFF00FF;
            }
            this.wavy_ = xml.hasOwnProperty("Wavy");
            this.parametric_ = xml.hasOwnProperty("Parametric");
            this.boomerang_ = xml.hasOwnProperty("Boomerang");
            this.amplitude_ = ((xml.hasOwnProperty("Amplitude")) ? Number(xml.Amplitude) : 0);
            this.frequency_ = ((xml.hasOwnProperty("Frequency")) ? Number(xml.Frequency) : 1);
            this.magnitude_ = ((xml.hasOwnProperty("Magnitude")) ? Number(xml.Magnitude) : 3);
        }
        public var bulletType_:int;
        public var objectId_:String;
        public var lifetime_:int;
        public var speed_:int;
        public var size_:int;
        public var minDamage_:int;
        public var maxDamage_:int;
        public var effects_:Vector.<uint> = null;
        public var multiHit_:Boolean;
        public var passesCover_:Boolean;
        public var armorPiercing_:Boolean;
        public var particleTrail_:Boolean;
        public var trailColor_:int = 0xFF00FF;
        public var wavy_:Boolean;
        public var parametric_:Boolean;
        public var boomerang_:Boolean;
        public var amplitude_:Number;
        public var frequency_:Number;
        public var magnitude_:Number;
    }
}//package com.company.assembleegameclient.objects
