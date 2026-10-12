package particleeffects {

    import com.company.assembleegameclient.parameters.Parameters;

    public class HitEffect extends ParticleEffect {

        public var particleColors_:Vector.<uint>;
        public var particleCount_:int;
        public var angle_:Number;
        public var speed_:Number;

        public function HitEffect(colors:Vector.<uint>, size:int, count:int, angle:Number, speed:Number) {
            this.particleColors_ = colors;
            size_ = size;
            this.particleCount_ = count;
            this.angle_ = angle;
            this.speed_ = speed;
        }

        override public function update(time:int, dt:int):Boolean {
            var color:uint;
            var particle:Particle;
            if (this.particleColors_.length == 0) {
                return false;
            }
            var baseVX:Number = ((this.speed_ / 600) * Math.cos((this.angle_ + Math.PI)));
            var baseVY:Number = ((this.speed_ / 600) * Math.sin((this.angle_ + Math.PI)));
            var i:int = 0;
            while (i < this.particleCount_) {
                color = this.particleColors_[int((this.particleColors_.length * Math.random()))];
                particle = new DriftParticle(color, 0.5, size_, (200 + (Math.random() * 100)), (baseVX + ((Math.random() - 0.5) * 0.4)), (baseVY + ((Math.random() - 0.5) * 0.4)), 0);
                if (!Parameters.data_["disableParticles"]) {
                    map_.addObj(particle, x_, y_);
                }
                i++;
            }
            return false;
        }

    }
}
