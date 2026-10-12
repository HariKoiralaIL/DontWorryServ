package particleeffects {

    public class ExplosionEffect extends ParticleEffect {

        public var particleColors_:Vector.<uint>;
        public var particleCount_:int;

        public function ExplosionEffect(colors:Vector.<uint>, size:int, count:int) {
            this.particleColors_ = colors;
            size_ = size;
            this.particleCount_ = count;
        }

        override public function update(time:int, dt:int):Boolean {
            var color:uint;
            var particle:Particle;
            if (this.particleColors_.length == 0) {
                return false;
            }
            var i:int = 0;
            while (i < this.particleCount_) {
                color = this.particleColors_[int((this.particleColors_.length * Math.random()))];
                particle = new DriftParticle(color, 0.5, size_, (200 + (Math.random() * 100)), (Math.random() - 0.5), (Math.random() - 0.5), 0);
                map_.addObj(particle, x_, y_);
                i++;
            }
            return false;
        }

    }
}
