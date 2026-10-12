package particleeffects {

    import com.company.assembleegameclient.parameters.Parameters;

    import flash.geom.Point;

    /** A single particle thrown in an arc from start to end. */
    public class ThrowEffect extends ParticleEffect {

        private static const PARTICLE_SIZE:int = 200;
        private static const FLIGHT_TIME:int = 1500;

        public var start_:Point;
        public var end_:Point;
        public var color_:int;

        public function ThrowEffect(start:Point, end:Point, color:int) {
            this.start_ = start;
            this.end_ = end;
            this.color_ = color;
        }

        override public function update(time:int, dt:int):Boolean {
            x_ = this.start_.x;
            y_ = this.start_.y;
            var particle:ThrowParticle = new ThrowParticle(PARTICLE_SIZE, this.color_, FLIGHT_TIME, this.start_, this.end_);
            if (!Parameters.data_["disableParticles"]) {
                map_.addObj(particle, x_, y_);
            }
            return false;
        }

    }
}

import particleeffects.Particle;
import particleeffects.SparkParticle;

import com.company.assembleegameclient.util._04d;

import flash.geom.Point;

class ThrowParticle extends Particle {

    public var lifetime_:int;
    public var timeLeft_:int;
    public var initialSize_:int;
    public var start_:Point;
    public var end_:Point;
    public var dx_:Number;
    public var dy_:Number;
    public var pathX_:Number;
    public var pathY_:Number;

    public function ThrowParticle(size:int, color:int, lifetime:int, start:Point, end:Point) {
        super(color, 0, size);
        this.lifetime_ = (this.timeLeft_ = lifetime);
        this.initialSize_ = size;
        this.start_ = start;
        this.end_ = end;
        this.dx_ = ((this.end_.x - this.start_.x) / this.timeLeft_);
        this.dy_ = ((this.end_.y - this.start_.y) / this.timeLeft_);
        this.pathX_ = (x_ = this.start_.x);
        this.pathY_ = (y_ = this.start_.y);
    }

    override public function update(time:int, dt:int):Boolean {
        this.timeLeft_ = (this.timeLeft_ - dt);
        if (this.timeLeft_ <= 0) {
            return false;
        }
        z_ = (Math.sin(((this.timeLeft_ / this.lifetime_) * Math.PI)) * 2);
        setSize(0); // the thrown object itself is invisible; only its spark trail is drawn
        this.pathX_ = (this.pathX_ + (this.dx_ * dt));
        this.pathY_ = (this.pathY_ + (this.dy_ * dt));
        moveTo(this.pathX_, this.pathY_);
        map_.addObj(new SparkParticle((100 * (z_ + 1)), color_, 400, z_, _04d._F_e(1), _04d._F_e(1)), this.pathX_, this.pathY_);
        return true;
    }

}
