package particleeffects {

    import com.company.assembleegameclient.objects.GameObject;

    /** Continuous effect: spawns a white rising particle near a game object every half second. */
    public class HealingEffect extends ParticleEffect {

        private static const SPAWN_INTERVAL:int = 500;

        public var go_:GameObject;
        public var lastSpawn_:int;

        public function HealingEffect(go:GameObject) {
            this.go_ = go;
            this.lastSpawn_ = 0;
        }

        override public function update(time:int, dt:int):Boolean {
            var angle:Number;
            var size:int;
            var radius:Number;
            var particle:HealParticle;
            if (this.go_.map_ == null) {
                return false;
            }
            x_ = this.go_.x_;
            y_ = this.go_.y_;
            if ((time - this.lastSpawn_) > SPAWN_INTERVAL) {
                angle = ((2 * Math.PI) * Math.random());
                size = ((3 + int((Math.random() * 5))) * 20);
                radius = (0.3 + (0.4 * Math.random()));
                particle = new HealParticle(0xFFFFFF, (Math.random() * 0.3), size, 1000, (0.1 + (Math.random() * 0.1)), this.go_, angle, radius);
                map_.addObj(particle, (x_ + (radius * Math.cos(angle))), (y_ + (radius * Math.sin(angle))));
                this.lastSpawn_ = time;
            }
            return true;
        }

    }
}
