package particleeffects {

    import com.company.assembleegameclient.objects.GameObject;

    /** Periodically emits an XML-defined particle at a game object's position. */
    public class XMLEffect extends ParticleEffect {

        private var go_:GameObject;
        private var particleProps_:ParticleProperties;
        private var cooldown_:Number;
        private var emitTimer_:Number;

        public function XMLEffect(go:GameObject, props:EffectProperties) {
            this.go_ = go;
            this.particleProps_ = ParticleLibrary.particles[props.particle];
            this.cooldown_ = props.cooldown;
            this.emitTimer_ = 0;
        }

        override public function update(time:int, dt:int):Boolean {
            if (this.go_.map_ == null) {
                return false;
            }
            var dtSeconds:Number = (dt / 1000);
            this.emitTimer_ = (this.emitTimer_ - dtSeconds);
            if (this.emitTimer_ >= 0) {
                return true;
            }
            this.emitTimer_ = this.cooldown_;
            map_.addObj(new XMLParticle(this.particleProps_), this.go_.x_, this.go_.y_);
            return true;
        }

    }
}
