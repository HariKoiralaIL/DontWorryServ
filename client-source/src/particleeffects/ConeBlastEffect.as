package particleeffects {

    import com.company.assembleegameclient.net.messages.data.LocationData;
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.parameters.Parameters;

    import flash.geom.Point;

    /** A 60-degree fan of particles aimed from a game object towards a target. */
    public class ConeBlastEffect extends ParticleEffect {

        private static const PARTICLE_COUNT:int = 7;
        private static const PARTICLE_SIZE:int = 200;
        private static const PARTICLE_LIFETIME:int = 100;
        private static const CONE_ANGLE:Number = (Math.PI / 3);

        public var start_:Point;
        public var aimTarget_:LocationData;
        public var effectRadius_:Number;
        public var color_:int;

        public function ConeBlastEffect(go:GameObject, target:LocationData, radius:Number, color:int) {
            this.start_ = new Point(go.x_, go.y_);
            this.aimTarget_ = target;
            this.effectRadius_ = radius;
            this.color_ = color;
        }

        override public function update(time:int, dt:int):Boolean {
            var angle:Number;
            var edge:Point;
            var particle:Particle;
            x_ = this.start_.x;
            y_ = this.start_.y;
            var aimAngle:Number = Math.atan2((this.aimTarget_.y_ - this.start_.y), (this.aimTarget_.x_ - this.start_.x));
            var i:int = 0;
            while (i < PARTICLE_COUNT) {
                angle = ((aimAngle - (CONE_ANGLE / 2)) + ((i * CONE_ANGLE) / PARTICLE_COUNT));
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
