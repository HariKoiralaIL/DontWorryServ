package particleeffects {

    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.util.AssetLibrary;

    import flash.display.BitmapData;

    /**
     * XML-configurable particle emitter ("CustomParticles" / "CloudParticles").
     * Particles are recycled through a pool; size, alpha and position are
     * animated according to the EffectProperties.
     */
    public class CustomParticleEffect extends ParticleEffect {

        public static function create(props:EffectProperties, go:GameObject):CustomParticleEffect {
            return new CustomParticleEffect(props, go);
        }

        public var cloud_:Boolean = false;
        private var pool_:Vector.<BitmapParticle> = new Vector.<BitmapParticle>();
        private var active_:Vector.<BitmapParticle> = new Vector.<BitmapParticle>();
        private var effectOwner_:GameObject;
        private var emitted_:Number = 0;
        private var effectTime_:Number = 0;
        private var effectProps_:EffectProperties;

        public function CustomParticleEffect(props:EffectProperties, go:GameObject) {
            this.effectOwner_ = go;
            this.effectProps_ = props;
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
            var targetEmitted:Number = (this.effectProps_.rate * this.effectTime_);
            var spawnCount:int = (targetEmitted - this.emitted_);
            var i:int = 0;
            while (i < spawnCount) {
                this.spawnParticle();
                i++;
            }
            this.emitted_ = (this.emitted_ + spawnCount);
            this.updateActiveParticles(dtSeconds);
            return true;
        }

        override public function removeFromMap():void {
            var particle:BitmapParticle;
            for each (particle in this.active_) {
                map_.removeObj(particle.objectId_);
            }
            this.active_ = null;
            this.pool_ = null;
            super.removeFromMap();
        }

        private function buildTexture(index:uint, size:Number):BitmapData {
            if (this.effectProps_.bitmapFile) {
                var source:BitmapData = AssetLibrary.getImageFromSet(this.effectProps_.bitmapFile, index);
                return TextureRedrawer.redraw(source, size, true, 0, 0);
            }
            return TextureRedrawer.redrawSolidSquare(this.effectProps_.color, size);
        }

        private function spawnParticle():void {
            var particle:BitmapParticle;
            var textureIndex:Object = null;
            if (this.pool_.length) {
                particle = this.pool_.pop();
                particle.cloudInitLife_ = 0;
                particle.fadeInitLife_ = 0;
                particle.fadedIn_ = false;
                particle.alpha_ = 1;
            } else {
                particle = new BitmapParticle(null);
            }
            if (this.effectProps_.bitmapFile) {
                textureIndex = this.effectProps_.bitmapIndex;
                if (this.effectProps_.bitmapIndexMax != -1) {
                    textureIndex = Math.floor(Math.random() * (1 + this.effectProps_.bitmapIndexMax - this.effectProps_.bitmapIndex) + this.effectProps_.bitmapIndex);
                }
            }
            particle.bitmapData_ = this.buildTexture(uint(textureIndex), this.effectProps_.size);
            if (textureIndex != null) {
                particle.bitmapIndex_ = uint(textureIndex);
            }
            if (this.effectProps_.fadeIn != -1) {
                particle.alpha_ = 0;
            }
            particle.initialize(
                (this.effectProps_.life + (this.effectProps_.lifeVariance * ((2 * Math.random()) - 1))),
                (this.effectProps_.speed + (this.effectProps_.speedVariance * ((2 * Math.random()) - 1))),
                (this.effectProps_.speed + (this.effectProps_.speedVariance * ((2 * Math.random()) - 1))),
                (this.effectProps_.rise + (this.effectProps_.riseVariance * ((2 * Math.random()) - 1))),
                (z_ + (this.effectProps_.rangeZ * Math.random())));
            particle.currentSize_ = this.effectProps_.size;
            var offsetX:Number = this.effectProps_.rangeX * ((2 * Math.random()) - 1);
            var offsetY:Number = this.effectProps_.rangeY * ((2 * Math.random()) - 1);
            map_.addObj(particle, x_ + offsetX, y_ + offsetY);
            particle.lX_ = offsetX;
            particle.lY_ = offsetY;
            particle.pOwnerX_ = this.effectOwner_.x_;
            particle.pOwnerY_ = this.effectOwner_.y_;
            this.active_.push(particle);
        }

        private function updateActiveParticles(dtSeconds:Number):void {
            var particle:BitmapParticle;
            var i:int = 0;
            while (i < this.active_.length) {
                particle = this.active_[i];
                particle.timeLeft_ = (particle.timeLeft_ - dtSeconds);
                if (particle.timeLeft_ <= 0) {
                    this.active_.splice(i, 1);
                    map_.removeObj(particle.objectId_);
                    i--;
                    this.pool_.push(particle);
                } else {
                    if (this.cloud_ && (particle.pOwnerX_ != this.effectOwner_.x_ || particle.pOwnerY_ != this.effectOwner_.y_)) {
                        // cloud: once the owner has moved away, shrink the particle over its remaining life
                        if (particle.cloudInitLife_ == 0) {
                            particle.cloudInitLife_ = particle.timeLeft_;
                        }
                        particle.currentSize_ = (particle.timeLeft_ / particle.cloudInitLife_) * this.effectProps_.size;
                        if (particle.currentSize_ < 0) {
                            particle.currentSize_ = 0;
                        }
                        particle.bitmapData_ = this.buildTexture(uint(particle.bitmapIndex_), particle.currentSize_);
                    } else if (this.effectProps_.growth != 0) {
                        particle.currentSize_ += this.effectProps_.growth * dtSeconds;
                        if (particle.currentSize_ < 0) {
                            particle.currentSize_ = 0;
                        }
                        particle.bitmapData_ = this.buildTexture(uint(particle.bitmapIndex_), particle.currentSize_);
                    }
                    this.applyFade(particle);
                    particle.rise_ = (particle.rise_ + (this.effectProps_.riseAcc * dtSeconds));
                    if (!this.effectProps_.attached) {
                        particle.x_ = (particle.x_ + (particle.speedX_ * dtSeconds));
                        particle.y_ = (particle.y_ + (particle.speedY_ * dtSeconds));
                        particle.z_ = (particle.z_ + (particle.rise_ * dtSeconds));
                    } else {
                        particle.lX_ += particle.speedX_ * dtSeconds;
                        particle.lY_ += particle.speedY_ * dtSeconds;
                        particle.x_ = x_ + particle.lX_;
                        particle.y_ = y_ + particle.lY_;
                        particle.square_ = map_.getSquare(particle.x_, particle.y_);
                        particle.z_ = (particle.z_ + (particle.rise_ * dtSeconds));
                    }
                }
                i++;
            }
        }

        private function applyFade(particle:BitmapParticle):void {
            var age:Number = (particle.lifetime_ - particle.timeLeft_);
            if (this.effectProps_.fadeIn != -1) {
                if (age <= this.effectProps_.fadeIn) {
                    particle.alpha_ = age / this.effectProps_.fadeIn;
                    if (particle.alpha_ > 1) {
                        particle.alpha_ = 1;
                    }
                } else {
                    if (!particle.fadedIn_ && particle.alpha_ < 1) {
                        particle.alpha_ = 1;
                    }
                    particle.fadedIn_ = true;
                }
            }
            if (this.effectProps_.fadeOut != -1 && age >= this.effectProps_.fadeOut) {
                if (particle.fadeInitLife_ == 0) {
                    particle.fadeInitLife_ = particle.timeLeft_;
                }
                particle.alpha_ = (particle.timeLeft_ / particle.fadeInitLife_);
                if (particle.alpha_ < 0) {
                    particle.alpha_ = 0;
                }
            }
        }

    }
}
