package particleeffects {

    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.util.ObjectPool;

    /** Continuously emits pooled BubbleParticles around a game object. */
    public class BubbleEffect extends ParticleEffect {

        private static const MAX_LOOKBACK:Number = 400;

        public var go_:GameObject;
        public var lastUpdate_:int = -1;
        public var interval_:Number;
        private var poolKey_:String;
        private var effectProps_:EffectProperties;

        public function BubbleEffect(go:GameObject, props:EffectProperties) {
            this.go_ = go;
            this.effectProps_ = props;
            this.interval_ = (((1 - props.rate) * MAX_LOOKBACK) + 1);
            this.poolKey_ = ("BubbleEffect_" + Math.random());
        }

        override public function update(time:int, dt:int):Boolean {
            var firstTick:int;
            var spawnTime:int;
            var angle:Number;
            var distance:Number;
            var particle:BubbleParticle;
            var px:Number;
            var py:Number;
            if (this.go_.map_ == null) {
                return false;
            }
            if (!this.lastUpdate_) {
                this.lastUpdate_ = time;
                return true;
            }
            firstTick = int((this.lastUpdate_ / this.interval_));
            var lastTick:int = int((time / this.interval_));
            var ownerX:Number = this.go_.x_;
            var ownerY:Number = this.go_.y_;
            if (this.lastUpdate_ < 0) {
                this.lastUpdate_ = Math.max(0, (time - MAX_LOOKBACK));
            }
            x_ = ownerX;
            y_ = ownerY;
            var tick:int = firstTick;
            while (tick < lastTick) {
                spawnTime = (tick * this.interval_);
                particle = BubbleParticle.create(this.poolKey_, this.effectProps_.color, this.effectProps_.speed, this.effectProps_.life, this.effectProps_.lifeVariance, this.effectProps_.speedVariance, this.effectProps_.spread);
                particle.restart(spawnTime, time);
                angle = (Math.random() * Math.PI);
                distance = (Math.random() * 0.4);
                px = (ownerX + (distance * Math.cos(angle)));
                py = (ownerY + (distance * Math.sin(angle)));
                map_.addObj(particle, px, py);
                tick++;
            }
            this.lastUpdate_ = time;
            return true;
        }

        override public function removeFromMap():void {
            super.removeFromMap();
            ObjectPool.dump(this.poolKey_);
        }

    }
}
