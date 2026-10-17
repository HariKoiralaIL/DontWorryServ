package particleeffects {

    import com.company.assembleegameclient.net.messages.data.LocationData;
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.util.MathUtil;

    import flash.geom.Point;

    /** A straight line of spark particles from a game object to a target. */
    public class LineEffect extends ParticleEffect {

        private static const PARTICLE_COUNT:int = 30;

        public var start_:Point;
        public var end_:Point;
        public var color_:int;

        public function LineEffect(go:GameObject, target:LocationData, color:int) {
            this.start_ = new Point(go.x_, go.y_);
            this.end_ = new Point(target.x_, target.y_);
            this.color_ = color;
        }

        override public function update(time:int, dt:int):Boolean {
            var position:Point;
            var particle:Particle;
            x_ = this.start_.x;
            y_ = this.start_.y;
            var i:int = 0;
            while (i < PARTICLE_COUNT) {
                position = Point.interpolate(this.start_, this.end_, (i / PARTICLE_COUNT));
                particle = new SparkParticle(100, this.color_, 700, 0.5, MathUtil.randomSpread(1), MathUtil.randomSpread(1));
                if (!Parameters.data_["disableParticles"]) {
                    map_.addObj(particle, position.x, position.y);
                }
                i++;
            }
            return false;
        }

    }
}
