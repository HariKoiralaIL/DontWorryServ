package particleeffects {

    import com.company.assembleegameclient.map.Square;
    import com.company.assembleegameclient.map._0D_v;
    import com.company.assembleegameclient.objects.BasicObject;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.util.GraphicHelper;

    import flash.display.BitmapData;
    import flash.display.GraphicsBitmapFill;
    import flash.display.GraphicsPath;
    import flash.display.IGraphicsData;
    import flash.geom.Matrix;

    import spriteanimation.Animations;

    /** Sprite (optionally animated) particle defined by ParticleProperties; drifts in a random direction. */
    public class XMLParticle extends BasicObject {

        public var texture_:BitmapData = null;
        public var animation_:Animations = null;
        public var size_:int;
        public var timeLeft_:Number;
        public var velocityX_:Number;
        public var velocityY_:Number;
        protected var bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null, null, false, false);
        protected var path_:GraphicsPath = new GraphicsPath(GraphicHelper._H_2, null);
        protected var vertices_:Vector.<Number> = new Vector.<Number>();
        protected var matrix_:Matrix = new Matrix();

        public function XMLParticle(props:ParticleProperties) {
            super();
            objectId_ = _7y();
            this.size_ = props.size_;
            z_ = props.z_;
            this.timeLeft_ = props.duration_;
            this.texture_ = props.textureData_.getTexture(objectId_);
            if (props.animationData_ != null) {
                this.animation_ = new Animations(props.animationData_);
            }
            var angle:Number = ((Math.PI * 2) * Math.random());
            this.velocityX_ = ((Math.cos(angle) * 0.1) * 5);
            this.velocityY_ = ((Math.sin(angle) * 0.1) * 5);
        }

        override public function update(time:int, dt:int):Boolean {
            var seconds:Number = (dt / 1000);
            this.timeLeft_ = (this.timeLeft_ - seconds);
            if (this.timeLeft_ <= 0) {
                return false;
            }
            x_ = (x_ + (this.velocityX_ * seconds));
            y_ = (y_ + (this.velocityY_ * seconds));
            return true;
        }

        override public function draw(graphicsData:Vector.<IGraphicsData>, camera:_0D_v, time:int):void {
            var frame:BitmapData;
            var texture:BitmapData = this.texture_;
            if (this.animation_ != null) {
                frame = this.animation_.getTexture(time);
                if (frame != null) {
                    texture = frame;
                }
            }
            texture = TextureRedrawer.redraw(texture, this.size_, true, 0, 0);
            var w:int = texture.width;
            var h:int = texture.height;
            this.vertices_.length = 0;
            this.vertices_.push(
                (_bY_[3] - (w / 2)), (_bY_[4] - h),
                (_bY_[3] + (w / 2)), (_bY_[4] - h),
                (_bY_[3] + (w / 2)), _bY_[4],
                (_bY_[3] - (w / 2)), _bY_[4]);
            this.path_.data = this.vertices_;
            this.bitmapFill_.bitmapData = texture;
            this.matrix_.identity();
            this.matrix_.translate(this.vertices_[0], this.vertices_[1]);
            this.bitmapFill_.matrix = this.matrix_;
            graphicsData.push(this.bitmapFill_);
            graphicsData.push(this.path_);
            graphicsData.push(GraphicHelper.END_FILL);
        }

        public function moveTo(newX:Number, newY:Number):Boolean {
            var square:Square = map_.getSquare(newX, newY);
            if (square == null) {
                return false;
            }
            x_ = newX;
            y_ = newY;
            _0H_B_ = square;
            return true;
        }

    }
}
