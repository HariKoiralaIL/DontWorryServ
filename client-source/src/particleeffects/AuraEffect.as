package particleeffects {

    import com.company.assembleegameclient.objects.GameObject;

    /** One-shot ring of rising, coloured HealParticles around a game object. */
    public class AuraEffect extends ParticleEffect {

        private static const PARTICLE_COUNT:int = 10;

        public var go_:GameObject;
        public var color_:uint;

        public function AuraEffect(go:GameObject, color:uint) {
            this.go_ = go;
            this.color_ = color;
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
            var i:int = 0;
            while (i < PARTICLE_COUNT) {
                angle = ((2 * Math.PI) * (i / PARTICLE_COUNT));
                size = ((3 + int((Math.random() * 5))) * 20);
                radius = (0.3 + (0.4 * Math.random()));
                particle = new HealParticle(this.color_, (Math.random() * 0.3), size, 1000, (0.1 + (Math.random() * 0.1)), this.go_, angle, radius);
                map_.addObj(particle, (x_ + (radius * Math.cos(angle))), (y_ + (radius * Math.sin(angle))));
                i++;
            }
            return false;
        }

    }
}
