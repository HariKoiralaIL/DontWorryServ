package particleeffects {

    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.parameters.Parameters;

    import flash.geom.Point;

    /** A thin ring of particles at the given radius around a game object. */
    public class RingEffect extends ParticleEffect {

        private static const PARTICLE_COUNT:int = 12;
        private static const PARTICLE_SIZE:int = 0;
        private static const PARTICLE_LIFETIME:int = 200;

        public var start_:Point;
        public var effectRadius_:Number;
        public var color_:int;

        public function RingEffect(go:GameObject, radius:Number, color:int) {
            this.start_ = new Point(go.x_, go.y_);
            this.effectRadius_ = radius;
            this.color_ = color;
        }

        override public function update(time:int, dt:int):Boolean {
            var angle:Number;
            var outer:Point;
            var inner:Point;
            var particle:Particle;
            x_ = this.start_.x;
            y_ = this.start_.y;
            var i:int = 0;
            while (i < PARTICLE_COUNT) {
                angle = (((i * 2) * Math.PI) / PARTICLE_COUNT);
                outer = new Point((this.start_.x + (this.effectRadius_ * Math.cos(angle))), (this.start_.y + (this.effectRadius_ * Math.sin(angle))));
                inner = new Point((this.start_.x + ((this.effectRadius_ * 0.9) * Math.cos(angle))), (this.start_.y + ((this.effectRadius_ * 0.9) * Math.sin(angle))));
                particle = new TrailParticle(PARTICLE_SIZE, this.color_, PARTICLE_LIFETIME, inner, outer);
                if (!Parameters.data_["disableParticles"]) {
                    map_.addObj(particle, x_, y_);
                }
                i++;
            }
            return false;
        }

    }
}
