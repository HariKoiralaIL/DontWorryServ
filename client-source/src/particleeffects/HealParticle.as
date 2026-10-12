package particleeffects {

    import com.company.assembleegameclient.objects.GameObject;

    /** Particle that rises while staying at a fixed angle/radius around a game object. */
    public class HealParticle extends Particle {

        public var timeLeft_:int;
        public var go_:GameObject;
        public var angle_:Number;
        public var radius_:Number;
        protected var riseSpeed_:Number;

        public function HealParticle(color:uint, z:Number, size:int, lifetime:int, riseSpeed:Number, go:GameObject, angle:Number, radius:Number) {
            super(color, z, size);
            this.riseSpeed_ = riseSpeed;
            this.timeLeft_ = lifetime;
            this.go_ = go;
            this.angle_ = angle;
            this.radius_ = radius;
        }

        override public function update(time:int, dt:int):Boolean {
            this.timeLeft_ = (this.timeLeft_ - dt);
            if (this.timeLeft_ <= 0) {
                return false;
            }
            x_ = (this.go_.x_ + (this.radius_ * Math.cos(this.angle_)));
            y_ = (this.go_.y_ + (this.radius_ * Math.sin(this.angle_)));
            z_ = (z_ + ((this.riseSpeed_ * dt) * 0.008));
            return true;
        }

    }
}
