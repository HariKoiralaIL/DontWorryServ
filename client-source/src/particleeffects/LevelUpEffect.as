package particleeffects {

    import com.company.assembleegameclient.objects.GameObject;

    /** Two interleaved helices of particles that spiral up around a game object. */
    public class LevelUpEffect extends ParticleEffect {

        private static const DURATION:int = 2000;

        public var go_:GameObject;
        public var helix1_:Vector.<LevelUpParticle> = new Vector.<LevelUpParticle>();
        public var helix2_:Vector.<LevelUpParticle> = new Vector.<LevelUpParticle>();
        public var startTime_:int = -1;

        public function LevelUpEffect(go:GameObject, color:uint, particlesPerHelix:int) {
            super();
            this.go_ = go;
            var i:int = 0;
            while (i < particlesPerHelix) {
                this.helix1_.push(new LevelUpParticle(color, 100));
                this.helix2_.push(new LevelUpParticle(color, 100));
                i++;
            }
        }

        override public function update(time:int, dt:int):Boolean {
            if (this.go_.map_ == null) {
                this.killParticles();
                return false;
            }
            x_ = this.go_.x_;
            y_ = this.go_.y_;
            if (this.startTime_ < 0) {
                this.startTime_ = time;
            }
            var progress:Number = ((time - this.startTime_) / DURATION);
            if (progress >= 1) {
                this.killParticles();
                return false;
            }
            this.updateHelix(this.helix1_, 1, 0, progress);
            this.updateHelix(this.helix2_, 1, Math.PI, progress);
            return true;
        }

        public function updateHelix(particles:Vector.<LevelUpParticle>, direction:Number, phase:Number, progress:Number):void {
            var i:int;
            var particle:LevelUpParticle;
            var angle:Number;
            var px:Number;
            var py:Number;
            i = 0;
            while (i < particles.length) {
                particle = particles[i];
                particle.z_ = (((progress * 2) - 1) + (i / particles.length));
                if (particle.z_ >= 0) {
                    if (particle.z_ > 1) {
                        particle.alive_ = false;
                    } else {
                        angle = (direction * ((((2 * Math.PI) * (i / particles.length)) + ((2 * Math.PI) * progress)) + phase));
                        px = (this.go_.x_ + (0.5 * Math.cos(angle)));
                        py = (this.go_.y_ + (0.5 * Math.sin(angle)));
                        if (particle.map_ == null) {
                            map_.addObj(particle, px, py);
                        } else {
                            particle.moveTo(px, py);
                        }
                    }
                }
                i++;
            }
        }

        private function killParticles():void {
            var particle:LevelUpParticle;
            for each (particle in this.helix1_) {
                particle.alive_ = false;
            }
            for each (particle in this.helix2_) {
                particle.alive_ = false;
            }
        }

    }
}

import particleeffects.Particle;

class LevelUpParticle extends Particle {

    public var alive_:Boolean = true;

    public function LevelUpParticle(color:uint, size:int) {
        super(color, 0, size);
    }

    override public function update(time:int, dt:int):Boolean {
        return this.alive_;
    }

}
