package particleeffects {

    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.util._04d;

    /** A puff of spark particles at a game object's position. */
    public class SparkEffect extends ParticleEffect {

        private static const PARTICLE_COUNT:int = 10;

        public var go_:GameObject;
        public var color_:int;

        public function SparkEffect(go:GameObject, color:int) {
            this.go_ = go;
            this.color_ = color;
        }

        override public function update(time:int, dt:int):Boolean {
            if (this.go_.map_ == null) {
                return false;
            }
            x_ = this.go_.x_;
            y_ = this.go_.y_;
            var i:int = 0;
            while (i < PARTICLE_COUNT) {
                map_.addObj(new SparkParticle(100, this.color_, 400, 0.75, _04d._F_e(4), _04d._F_e(4)), x_, y_);
                i++;
            }
            return false;
        }

    }
}
