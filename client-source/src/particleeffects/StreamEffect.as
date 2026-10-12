package particleeffects {

    import com.company.assembleegameclient.net.messages.data._Q_0;
    import com.company.assembleegameclient.parameters.Parameters;

    import flash.geom.Point;

    /** Wavy streams of particles travelling from a start point to an end point. */
    public class StreamEffect extends ParticleEffect {

        private static const PARTICLE_COUNT:int = 5;

        public var start_:Point;
        public var end_:Point;
        public var color_:int;

        public function StreamEffect(start:_Q_0, end:_Q_0, color:int) {
            this.start_ = new Point(start.x_, start.y_);
            this.end_ = new Point(end.x_, end.y_);
            this.color_ = color;
        }

        override public function update(time:int, dt:int):Boolean {
            var size:int;
            var particle:StreamParticle;
            x_ = this.start_.x;
            y_ = this.start_.y;
            var i:int = 0;
            while (i < PARTICLE_COUNT) {
                size = ((3 + int((Math.random() * 5))) * 20);
                particle = new StreamParticle(1.85, size, this.color_, (1500 + (Math.random() * 3000)), (0.1 + (Math.random() * 0.1)), this.start_, this.end_);
                if (!Parameters.data_["disableParticles"]) {
                    map_.addObj(particle, x_, y_);
                }
                i++;
            }
            return false;
        }

    }
}

import particleeffects.Particle;

import flash.geom.Point;

class StreamParticle extends Particle {

    private static const DEFLECT_AMOUNT:Number = 0.25;

    public var timeLeft_:int;
    public var riseSpeed_:Number;
    public var start_:Point;
    public var end_:Point;
    public var dx_:Number;
    public var dy_:Number;
    public var pathX_:Number;
    public var pathY_:Number;
    public var xDeflect_:Number;
    public var yDeflect_:Number;
    public var period_:Number;

    public function StreamParticle(z:Number, size:int, color:int, lifetime:int, riseSpeed:Number, start:Point, end:Point) {
        super(color, z, size);
        this.riseSpeed_ = riseSpeed;
        this.timeLeft_ = lifetime;
        this.start_ = start;
        this.end_ = end;
        this.dx_ = ((this.end_.x - this.start_.x) / this.timeLeft_);
        this.dy_ = ((this.end_.y - this.start_.y) / this.timeLeft_);
        var pathSpeed:Number = (Point.distance(start, end) / this.timeLeft_);
        this.xDeflect_ = ((this.dy_ / pathSpeed) * DEFLECT_AMOUNT);
        this.yDeflect_ = ((-(this.dx_) / pathSpeed) * DEFLECT_AMOUNT);
        this.pathX_ = (x_ = this.start_.x);
        this.pathY_ = (y_ = this.start_.y);
        this.period_ = (0.25 + (Math.random() * 0.5));
    }

    override public function update(time:int, dt:int):Boolean {
        this.timeLeft_ = (this.timeLeft_ - dt);
        if (this.timeLeft_ <= 0) {
            return false;
        }
        this.pathX_ = (this.pathX_ + (this.dx_ * dt));
        this.pathY_ = (this.pathY_ + (this.dy_ * dt));
        var wave:Number = Math.sin(((this.timeLeft_ / 1000) / this.period_));
        moveTo((this.pathX_ + (this.xDeflect_ * wave)), (this.pathY_ + (this.yDeflect_ * wave)));
        return true;
    }

}
