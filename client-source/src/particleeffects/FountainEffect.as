package particleeffects {

    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.util.ObjectPool;

    public class FountainEffect extends ParticleEffect {

        private static const SPAWN_INTERVAL:int = 50;
        private static const INITIAL_LOOKBACK:int = 400;

        public var go_:GameObject;
        public var lastUpdate_:int = -1;

        public function FountainEffect(go:GameObject) {
            this.go_ = go;
        }

        override public function update(time:int, dt:int):Boolean {
            var spawnTime:int;
            var particle:FountainParticle;
            if (this.go_.map_ == null) {
                return false;
            }
            if (this.lastUpdate_ < 0) {
                this.lastUpdate_ = Math.max(0, (time - INITIAL_LOOKBACK));
            }
            x_ = this.go_.x_;
            y_ = this.go_.y_;
            var tick:int = (this.lastUpdate_ / SPAWN_INTERVAL);
            while (tick < (time / SPAWN_INTERVAL)) {
                spawnTime = (tick * SPAWN_INTERVAL);
                particle = (ObjectPool.getOrCreate(FountainParticle) as FountainParticle);
                particle.restart(spawnTime, time);
                if (!Parameters.data_["disableParticles"]) {
                    map_.addObj(particle, x_, y_);
                }
                tick++;
            }
            this.lastUpdate_ = time;
            return true;
        }

    }
}

import particleeffects.Particle;

import com.company.assembleegameclient.util.ObjectPool;

class FountainParticle extends Particle {

    private static const GRAVITY:Number = -4.9;
    private static const INITIAL_VELOCITY:Number = 6.5;
    private static const INITIAL_Z:Number = 0.75;
    private static const COLOR:uint = 4285909;
    private static const SIZE:int = 100;

    public var startTime_:int;
    protected var dirX_:Number;
    protected var dirY_:Number;

    public function FountainParticle() {
        super(COLOR, INITIAL_Z, SIZE);
    }

    public function restart(startTime:int, time:int):void {
        var angle:Number = ((2 * Math.PI) * Math.random());
        this.dirX_ = Math.cos(angle);
        this.dirY_ = Math.sin(angle);
        this.startTime_ = startTime;
        var elapsedMs:int = (time - this.startTime_);
        x_ = (x_ + ((this.dirX_ * elapsedMs) * 0.0008));
        y_ = (y_ + ((this.dirY_ * elapsedMs) * 0.0008));
        var t:Number = ((time - this.startTime_) / 1000);
        z_ = ((INITIAL_Z + (INITIAL_VELOCITY * t)) + (GRAVITY * (t * t)));
    }

    override public function removeFromMap():void {
        super.removeFromMap();
        ObjectPool.releaseInstance(this);
    }

    override public function update(time:int, dt:int):Boolean {
        var t:Number = ((time - this.startTime_) / 1000);
        moveTo((x_ + ((this.dirX_ * dt) * 0.0008)), (y_ + ((this.dirY_ * dt) * 0.0008)));
        z_ = ((INITIAL_Z + (INITIAL_VELOCITY * t)) + (GRAVITY * (t * t)));
        return (z_ > 0);
    }

}
