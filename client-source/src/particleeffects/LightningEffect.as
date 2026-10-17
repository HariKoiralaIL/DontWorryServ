package particleeffects {

    import com.company.assembleegameclient.net.messages.data.LocationData;
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.util.MathUtil;

    import flash.geom.Point;

    /** A jittery line of fading particles from a game object to a target. */
    public class LightningEffect extends ParticleEffect {

        public var start_:Point;
        public var end_:Point;
        public var color_:int;
        public var particleSize_:int;

        public function LightningEffect(go:GameObject, target:LocationData, color:int, particleSize:int) {
            this.start_ = new Point(go.x_, go.y_);
            this.end_ = new Point(target.x_, target.y_);
            this.color_ = color;
            this.particleSize_ = particleSize;
        }

        override public function update(time:int, dt:int):Boolean {
            var position:Point;
            var particle:Particle;
            var jitterFactor:Number;
            x_ = this.start_.x;
            y_ = this.start_.y;
            var distance:Number = Point.distance(this.start_, this.end_);
            var count:int = (distance * 3);
            var i:int = 0;
            while (i < count) {
                position = Point.interpolate(this.start_, this.end_, (i / count));
                particle = new SparkParticle(this.particleSize_, this.color_, (1000 - ((i / count) * 900)), 0.5, 0, 0);
                jitterFactor = Math.min(i, (count - i));
                map_.addObj(particle, (position.x + MathUtil.randomSpread(((distance / 200) * jitterFactor))), (position.y + MathUtil.randomSpread(((distance / 200) * jitterFactor))));
                i++;
            }
            return false;
        }

    }
}
