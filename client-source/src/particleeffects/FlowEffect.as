package particleeffects {

    import com.company.assembleegameclient.net.messages.data.LocationData;
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.parameters.Parameters;

    import flash.geom.Point;

    /** Particles spawned at a point that accelerate towards a game object. */
    public class FlowEffect extends ParticleEffect {

        private static const PARTICLE_COUNT:int = 5;

        public var start_:Point;
        public var go_:GameObject;
        public var color_:int;

        public function FlowEffect(start:LocationData, go:GameObject, color:int) {
            this.start_ = new Point(start.x_, start.y_);
            this.go_ = go;
            this.color_ = color;
        }

        override public function update(time:int, dt:int):Boolean {
            var size:int;
            var particle:Particle;
            x_ = this.start_.x;
            y_ = this.start_.y;
            var i:int = 0;
            while (i < PARTICLE_COUNT) {
                size = ((3 + int((Math.random() * 5))) * 20);
                particle = new FlowParticle(0.5, size, this.color_, this.start_, this.go_);
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

import com.company.assembleegameclient.objects.GameObject;

import flash.geom.Point;

class FlowParticle extends Particle {

    public var start_:Point;
    public var go_:GameObject;
    public var maxDist_:Number;
    public var flowSpeed_:Number;

    public function FlowParticle(z:Number, size:int, color:int, start:Point, go:GameObject) {
        super(color, z, size);
        this.start_ = start;
        this.go_ = go;
        var self:Point = new Point(x_, y_);
        var target:Point = new Point(this.go_.x_, this.go_.y_);
        this.maxDist_ = Point.distance(self, target);
        this.flowSpeed_ = (Math.random() * 5);
    }

    override public function update(time:int, dt:int):Boolean {
        var acceleration:Number = 8;
        var self:Point = new Point(x_, y_);
        var target:Point = new Point(this.go_.x_, this.go_.y_);
        var dist:Number = Point.distance(self, target);
        if (dist < 0.5) {
            return false;
        }
        this.flowSpeed_ = (this.flowSpeed_ + ((acceleration * dt) / 1000));
        this.maxDist_ = (this.maxDist_ - ((this.flowSpeed_ * dt) / 1000));
        var newDist:Number = (dist - ((this.flowSpeed_ * dt) / 1000));
        if (newDist > this.maxDist_) {
            newDist = this.maxDist_;
        }
        var offsetX:Number = (this.go_.x_ - x_);
        var offsetY:Number = (this.go_.y_ - y_);
        offsetX = (offsetX * (newDist / dist));
        offsetY = (offsetY * (newDist / dist));
        moveTo((this.go_.x_ - offsetX), (this.go_.y_ - offsetY));
        return true;
    }

}
