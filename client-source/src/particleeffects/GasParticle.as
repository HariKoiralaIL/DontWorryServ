package particleeffects {

    /** Spark particle with random jitter that dies when it touches a static object. */
    public class GasParticle extends SparkParticle {

        private var spread_:Number;

        public function GasParticle(size:int, color:int, lifetime:int, spread:Number, z:Number, dx:Number, dy:Number) {
            this.spread_ = spread;
            super(size, color, lifetime, z, dx, dy);
        }

        override public function update(time:int, dt:int):Boolean {
            timeLeft_ = (timeLeft_ - dt);
            if (timeLeft_ <= 0) {
                return false;
            }
            if (((square_.obj_) && (square_.obj_.props_.static_))) {
                return false;
            }
            var jitterX:Number = (Math.random() * this.spread_);
            var jitterY:Number = (Math.random() * this.spread_);
            x_ = (x_ + (((dx_ * jitterX) * dt) / 1000));
            y_ = (y_ + (((dy_ * jitterY) * dt) / 1000));
            setSize(((timeLeft_ / lifetime_) * initialSize_));
            return true;
        }

    }
}
