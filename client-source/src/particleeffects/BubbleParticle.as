package particleeffects {

    import com.company.assembleegameclient.util._wW_;

    /** Pooled particle used by BubbleEffect: rises, optionally drifting sideways. */
    public class BubbleParticle extends Particle {

        private static const DRIFT_SCALE:Number = 0.0025;

        public static function create(poolKey:*, color:uint, baseSpeed:Number, life:Number, lifeVariance:Number, speedVariance:Number, spread:Number):BubbleParticle {
            var particle:BubbleParticle = (_wW_.getObject(poolKey) as BubbleParticle);
            if (!particle) {
                particle = new BubbleParticle(color, baseSpeed, life, lifeVariance, speedVariance, spread);
            }
            return particle;
        }

        public var startTime_:int;
        public var speed:Number;
        public var spread:Number;
        public var baseSpeed_:Number;
        public var life:Number;
        public var lifeVariance:Number;
        public var speedVariance:Number;
        public var timeLeft_:Number;
        public var driftX_:Number;
        public var driftY_:Number;

        public function BubbleParticle(color:uint, baseSpeed:Number, life:Number, lifeVariance:Number, speedVariance:Number, spread:Number) {
            super(color, 0, (75 + (Math.random() * 50)));
            this.baseSpeed_ = baseSpeed;
            this.life = (life * 1000);
            this.lifeVariance = lifeVariance;
            this.speedVariance = speedVariance;
            this.spread = spread;
            this.driftX_ = 0;
            this.driftY_ = 0;
        }

        override public function update(time:int, dt:int):Boolean {
            var elapsed:Number = ((time - this.startTime_) / 1000);
            this.timeLeft_ = (this.timeLeft_ - dt);
            if (this.timeLeft_ <= 0) {
                return false;
            }
            z_ = (this.speed * elapsed);
            if (this.spread > 0) {
                moveTo((x_ + ((this.driftX_ * dt) * DRIFT_SCALE)), (y_ + ((this.driftY_ * dt) * DRIFT_SCALE)));
            }
            return true;
        }

        public function restart(startTime:int, time:int):void {
            this.startTime_ = startTime;
            var roll:Number = Math.random();
            this.speed = ((this.baseSpeed_ - (this.baseSpeed_ * (roll * (1 - this.speedVariance)))) * 10);
            if (this.spread > 0) {
                this.driftX_ = ((Math.random() * this.spread) - 0.1);
                this.driftY_ = ((Math.random() * this.spread) - 0.1);
            }
            var elapsed:Number = ((time - startTime) / 1000);
            this.timeLeft_ = (this.life - (this.life * (roll * (1 - this.lifeVariance))));
            z_ = (this.speed * elapsed);
        }

    }
}
