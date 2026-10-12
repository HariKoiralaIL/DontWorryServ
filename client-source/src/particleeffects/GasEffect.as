package particleeffects {

    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.util._04d;

    /** Emits gas particles while the owner is moving. */
    public class GasEffect extends ParticleEffect {

        public var go_:GameObject;
        public var effectProps_:EffectProperties;
        public var color_:int;
        public var rate:Number;

        public function GasEffect(go:GameObject, props:EffectProperties) {
            this.go_ = go;
            this.color_ = props.color;
            this.rate = props.rate;
            this.effectProps_ = props;
        }

        override public function update(time:int, dt:int):Boolean {
            var roll:Number;
            var velocityX:Number;
            var velocityY:Number;
            var lifetime:Number;
            var particle:GasParticle;
            if (this.go_.map_ == null) {
                return false;
            }
            var moved:Boolean = ((x_ != this.go_.x_) || (y_ != this.go_.y_));
            x_ = this.go_.x_;
            y_ = this.go_.y_;
            if (moved) {
                var i:int = 0;
                while (i < this.rate) {
                    roll = Math.random();
                    velocityX = _04d._F_e((this.effectProps_.speed - (this.effectProps_.speed * (roll * (1 - this.effectProps_.speedVariance)))));
                    velocityY = _04d._F_e((this.effectProps_.speed - (this.effectProps_.speed * (roll * (1 - this.effectProps_.speedVariance)))));
                    lifetime = ((this.effectProps_.life * 1000) - ((this.effectProps_.life * 1000) * (roll * this.effectProps_.lifeVariance)));
                    particle = new GasParticle(150, this.color_, lifetime, this.effectProps_.spread, 0, velocityX, velocityY);
                    map_.addObj(particle, x_, y_);
                    i++;
                }
            }
            return true;
        }

    }
}
