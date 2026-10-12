package particleeffects {

    import com.company.assembleegameclient.net.messages.data._Q_0;
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.parameters.Parameters;

    import flash.geom.Point;

    /** Particles flying from a center point out to a surrounding circle. */
    public class BurstEffect extends ParticleEffect {

        private static const PARTICLE_COUNT:int = 24;
        private static const PARTICLE_SIZE:int = 100;

        public var center_:Point;
        public var edgePoint_:Point;
        public var color_:int;

        // 'go' is unused but kept so existing call sites keep working.
        public function BurstEffect(go:GameObject, center:_Q_0, edgePoint:_Q_0, color:int) {
            this.center_ = new Point(center.x_, center.y_);
            this.edgePoint_ = new Point(edgePoint.x_, edgePoint.y_);
            this.color_ = color;
        }

        override public function update(time:int, dt:int):Boolean {
            var angle:Number;
            var ringPoint:Point;
            var particle:Particle;
            x_ = this.center_.x;
            y_ = this.center_.y;
            var radius:Number = Point.distance(this.center_, this.edgePoint_);
            var i:int = 0;
            while (i < PARTICLE_COUNT) {
                angle = (((i * 2) * Math.PI) / PARTICLE_COUNT);
                ringPoint = new Point((this.center_.x + (radius * Math.cos(angle))), (this.center_.y + (radius * Math.sin(angle))));
                particle = new TrailParticle(PARTICLE_SIZE, this.color_, (100 + (Math.random() * 200)), this.center_, ringPoint);
                if (!Parameters.data_["disableParticles"]) {
                    map_.addObj(particle, x_, y_);
                }
                i++;
            }
            return false;
        }

    }
}
