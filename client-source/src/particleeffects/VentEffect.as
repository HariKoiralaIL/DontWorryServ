package particleeffects {

    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.util._wW_;

    public class VentEffect extends ParticleEffect {

        private static const SPAWN_INTERVAL:int = 50;
        private static const INITIAL_LOOKBACK:int = 400;

        public var go_:GameObject;
        public var lastUpdate_:int = -1;

        public function VentEffect(go:GameObject) {
            this.go_ = go;
        }

        override public function update(time:int, dt:int):Boolean {
            var spawnTime:int;
            var particle:VentParticle;
            var angle:Number;
            var distance:Number;
            var px:Number;
            var py:Number;
            if (this.go_.map_ == null) {
                return false;
            }
            if (this.lastUpdate_ < 0) {
                this.lastUpdate_ = Math.max(0, (time - INITIAL_LOOKBACK));
            }
            x_ = this.go_.x_;
            y_ = this.go_.y_;
            var tick:int = int((this.lastUpdate_ / SPAWN_INTERVAL));
            while (tick < int((time / SPAWN_INTERVAL))) {
                spawnTime = (tick * SPAWN_INTERVAL);
                particle = (_wW_._B_1(VentParticle) as VentParticle);
                particle.restart(spawnTime, time);
                angle = (Math.random() * Math.PI);
                distance = (Math.random() * 0.4);
                px = (this.go_.x_ + (distance * Math.cos(angle)));
                py = (this.go_.y_ + (distance * Math.sin(angle)));
                if (!Parameters.data_["disableParticles"]) {
                    map_.addObj(particle, px, py);
                }
                tick++;
            }
            this.lastUpdate_ = time;
            return true;
        }

    }
}

import particleeffects.Particle;

import com.company.assembleegameclient.util._wW_;

class VentParticle extends Particle {

    private static const COLOR:uint = 2542335;

    public var startTime_:int;
    // Declared int in the original client, so the fractional rise speed is truncated (1 or 2).
    public var speed_:int;

    public function VentParticle() {
        var roll:Number = Math.random();
        super(COLOR, 0, (75 + (roll * 50)));
        this.speed_ = (2.5 - (roll * 1.5));
    }

    public function restart(startTime:int, time:int):void {
        this.startTime_ = startTime;
        var t:Number = ((time - this.startTime_) / 1000);
        z_ = (this.speed_ * t);
    }

    override public function removeFromMap():void {
        super.removeFromMap();
        _wW_._ay(this);
    }

    override public function update(time:int, dt:int):Boolean {
        var t:Number = ((time - this.startTime_) / 1000);
        z_ = (this.speed_ * t);
        return (z_ < 1);
    }

}
