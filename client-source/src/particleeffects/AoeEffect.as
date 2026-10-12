package particleeffects {

    import com.company.assembleegameclient.parameters.Parameters;

    import flash.geom.Point;

    /** Particles shooting outwards from a point in all directions (area-of-effect burst). */
    public class AoeEffect extends ParticleEffect {

        private static const PARTICLE_SIZE:int = 200;
        private static const PARTICLE_LIFETIME:int = 200;

        public var start_:Point;
        public var effectRadius_:Number;
        public var color_:int;

        public function AoeEffect(center:Point, radius:Number, color:int) {
            this.start_ = center;
            this.effectRadius_ = radius;
            this.color_ = color;
        }

        override public function update(time:int, dt:int):Boolean {
            var angle:Number;
            var edge:Point;
            var particle:Particle;
            x_ = this.start_.x;
            y_ = this.start_.y;
            var count:int = (4 + (this.effectRadius_ * 2));
            var i:int = 0;
            while (i < count) {
                angle = (((i * 2) * Math.PI) / count);
                edge = new Point((this.start_.x + (this.effectRadius_ * Math.cos(angle))), (this.start_.y + (this.effectRadius_ * Math.sin(angle))));
                particle = new TrailParticle(PARTICLE_SIZE, this.color_, PARTICLE_LIFETIME, this.start_, edge);
                if (!Parameters.data_["disableParticles"]) {
                    map_.addObj(particle, x_, y_);
                }
                i++;
            }
            return false;
        }

    }
}
