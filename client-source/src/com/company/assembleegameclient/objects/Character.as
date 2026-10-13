package com.company.assembleegameclient.objects {
    import audio.SoundEffects;

    public class Character extends GameObject {

        public function Character(xml:XML) {
            super(xml);
            this.hitSound_ = ((xml.hasOwnProperty("HitSound")) ? String(xml.HitSound) : "monster/default_hit");
            SoundEffects.load(this.hitSound_);
            this.deathSound_ = ((xml.hasOwnProperty("DeathSound")) ? String(xml.DeathSound) : "monster/default_death");
            SoundEffects.load(this.deathSound_);
        }
        public var unusedInt_:int = 0;
        public var damageType_:uint = 0;
        public var hitSound_:String;
        public var deathSound_:String;

        override public function damage(itemType:int, damage:int, effects:Vector.<uint>, kill:Boolean, proj:Projectile):void {
            super.damage(itemType, damage, effects, kill, proj);
            if (dead_) {
                SoundEffects.play(this.deathSound_);
            } else {
                SoundEffects.play(this.hitSound_);
            }
        }

    }
}//package com.company.assembleegameclient.objects
