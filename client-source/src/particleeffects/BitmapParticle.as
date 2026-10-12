package particleeffects {

    import com.company.assembleegameclient.map.GameCamera;
    import com.company.assembleegameclient.objects.BasicObject;
    import com.company.util.GraphicHelper;
    import com.company.util._G_;

    import flash.display.BitmapData;
    import flash.display.GraphicsBitmapFill;
    import flash.display.GraphicsPath;
    import flash.display.IGraphicsData;
    import flash.geom.Matrix;

    /**
     * Textured particle with alpha, driven by CustomParticleEffect / OrbitEffect.
     * Holds state only; movement is performed by the owning effect.
     */
    public class BitmapParticle extends BasicObject {

        public var timeLeft_:Number = 0;
        public var lifetime_:Number = 0;
        public var speedX_:Number;
        public var speedY_:Number;
        public var rise_:Number;
        public var currentSize_:Number;
        public var lX_:Number = 0;
        public var lY_:Number = 0;
        public var pOwnerX_:Number = 0;
        public var pOwnerY_:Number = 0;
        public var cloudInitLife_:Number = 0;
        public var fadeInitLife_:Number = 0;
        public var fadedIn_:Boolean = false;
        public var bitmapData_:BitmapData;
        public var bitmapIndex_:Number = -1;
        public var alpha_:Number = 1;
        protected var vertices_:Vector.<Number> = new Vector.<Number>(8);
        protected var matrix_:Matrix = new Matrix();
        protected var path_:GraphicsPath = new GraphicsPath(GraphicHelper._H_2, null);
        protected var bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null, null, false, false);

        public function BitmapParticle(bitmapData:BitmapData) {
            super();
            this.bitmapFill_.bitmapData = bitmapData;
            this.bitmapData_ = bitmapData;
            objectId_ = _7y();
        }

        override public function draw(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
            this.bitmapFill_.bitmapData = _G_._0C_m(this.bitmapData_, this.alpha_);
            var halfW:Number = (this.bitmapFill_.bitmapData.width / 2);
            var halfH:Number = (this.bitmapFill_.bitmapData.height / 2);
            this.vertices_[6] = (this.vertices_[0] = (_bY_[3] - halfW));
            this.vertices_[3] = (this.vertices_[1] = (_bY_[4] - halfH));
            this.vertices_[4] = (this.vertices_[2] = (_bY_[3] + halfW));
            this.vertices_[7] = (this.vertices_[5] = (_bY_[4] + halfH));
            this.path_.data = this.vertices_;
            this.matrix_.identity();
            this.matrix_.translate(this.vertices_[0], this.vertices_[1]);
            this.bitmapFill_.matrix = this.matrix_;
            graphicsData.push(this.bitmapFill_);
            graphicsData.push(this.path_);
            graphicsData.push(GraphicHelper.END_FILL);
        }

        override public function removeFromMap():void {
            map_ = null;
            _0H_B_ = null;
        }

        public function initialize(lifetime:Number, speedX:Number, speedY:Number, rise:Number, z:Number):void {
            this.timeLeft_ = lifetime;
            this.lifetime_ = lifetime;
            this.speedX_ = speedX;
            this.speedY_ = speedY;
            this.rise_ = rise;
            z_ = z;
        }

    }
}
