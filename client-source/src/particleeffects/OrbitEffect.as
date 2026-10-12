package particleeffects {

    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.util.AssetLibrary;

    import flash.display.BitmapData;

    /** A single bitmap particle that orbits a game object. */
    public class OrbitEffect extends ParticleEffect {

        public static function create(props:EffectProperties, go:GameObject):OrbitEffect {
            return new OrbitEffect(props, go);
        }

        private var particle_:BitmapParticle;
        private var effectOwner_:GameObject;
        private var angle_:Number = 0;
        private var effectTime_:Number = 0;
        private var effectProps_:EffectProperties;
        private var bitmapData:BitmapData;

        public function OrbitEffect(props:EffectProperties, go:GameObject) {
            this.effectOwner_ = go;
            this.effectProps_ = props;
            this.angle_ = this.effectProps_.angleOffset;
            if (this.effectProps_.bitmapFile) {
                this.bitmapData = AssetLibrary._xK_(this.effectProps_.bitmapFile, this.effectProps_.bitmapIndex);
                this.bitmapData = TextureRedrawer.redraw(this.bitmapData, this.effectProps_.size, true, 0, 0);
            } else {
                this.bitmapData = TextureRedrawer.redrawSolidSquare(this.effectProps_.color, this.effectProps_.size);
            }
        }

        override public function update(time:int, dt:int):Boolean {
            var dtSeconds:Number = (dt / 1000);
            if (this.effectOwner_.map_ == null) {
                return false;
            }
            x_ = this.effectOwner_.x_;
            y_ = this.effectOwner_.y_;
            z_ = (this.effectOwner_.z_ + this.effectProps_.zOffset);
            this.effectTime_ = (this.effectTime_ + dtSeconds);
            if (this.particle_ == null) {
                this.particle_ = new BitmapParticle(this.bitmapData);
                this.particle_.lX_ = 0;
                this.particle_.lY_ = 0;
                map_.addObj(this.particle_, x_, y_);
                this.particle_.z_ = this.effectProps_.zOffset;
            }
            this.angle_ += this.effectProps_.speed * dtSeconds;
            this.angle_ = this.angle_ % 360;
            this.particle_.lX_ = this.effectProps_.radius * Math.cos(this.angle_ * Math.PI / 180);
            this.particle_.lY_ = -this.effectProps_.radius * Math.sin(this.angle_ * Math.PI / 180);
            this.particle_.x_ = this.x_ + this.particle_.lX_;
            this.particle_.y_ = this.y_ + this.particle_.lY_;
            this.particle_._0H_B_ = map_.getSquare(this.particle_.x_, this.particle_.y_);
            return true;
        }

        override public function removeFromMap():void {
            if (this.particle_ != null) {
                map_.removeObj(this.particle_.objectId_);
            }
            super.removeFromMap();
        }

    }
}
