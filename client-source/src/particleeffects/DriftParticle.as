package particleeffects {

    import flash.geom.Vector3D;

    /** Particle that moves with a constant 3D velocity until its lifetime runs out. */
    public class DriftParticle extends Particle {

        public var lifetime_:int;
        public var timeLeft_:int;
        protected var moveVec_:Vector3D = new Vector3D();

        public function DriftParticle(color:uint, z:Number, size:int, lifetime:int, vx:Number, vy:Number, vz:Number) {
            super(color, z, size);
            this.timeLeft_ = (this.lifetime_ = lifetime);
            this.moveVec_.x = vx;
            this.moveVec_.y = vy;
            this.moveVec_.z = vz;
        }

        override public function update(time:int, dt:int):Boolean {
            this.timeLeft_ = (this.timeLeft_ - dt);
            if (this.timeLeft_ <= 0) {
                return false;
            }
            x_ = (x_ + ((this.moveVec_.x * dt) * 0.008));
            y_ = (y_ + ((this.moveVec_.y * dt) * 0.008));
            z_ = (z_ + ((this.moveVec_.z * dt) * 0.008));
            return true;
        }

    }
}
