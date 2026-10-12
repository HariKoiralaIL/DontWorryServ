package particleeffects {

    import com.company.assembleegameclient.parameters.Parameters;

    public class TeleportEffect extends ParticleEffect {

        private static const PARTICLE_COUNT:int = 20;

        override public function update(time:int, dt:int):Boolean {
            var angle:Number;
            var distance:Number;
            var lifetime:int;
            var particle:TeleportParticle;
            var i:int = 0;
            while (i < PARTICLE_COUNT) {
                angle = ((2 * Math.PI) * Math.random());
                distance = (0.7 * Math.random());
                lifetime = (500 + (1000 * Math.random()));
                particle = new TeleportParticle(0xFF, 50, 0.1, lifetime);
                if (!Parameters.data_["disableParticles"]) {
                    map_.addObj(particle, (x_ + (distance * Math.cos(angle))), (y_ + (distance * Math.sin(angle))));
                }
                i++;
            }
            return false;
        }

    }
}

import particleeffects.Particle;

class TeleportParticle extends Particle {

    public var timeLeft_:int;
    protected var riseSpeed_:Number;

    public function TeleportParticle(color:uint, size:int, riseSpeed:Number, lifetime:int) {
        super(color, 0, size);
        this.riseSpeed_ = riseSpeed;
        this.timeLeft_ = lifetime;
    }

    override public function update(time:int, dt:int):Boolean {
        this.timeLeft_ = (this.timeLeft_ - dt);
        if (this.timeLeft_ <= 0) {
            return false;
        }
        z_ = (z_ + ((this.riseSpeed_ * dt) * 0.008));
        return true;
    }

}
