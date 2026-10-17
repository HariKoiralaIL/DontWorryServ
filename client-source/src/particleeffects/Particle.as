package particleeffects {

    import com.company.assembleegameclient.map.Square;
    import com.company.assembleegameclient.map.GameCamera;
    import com.company.assembleegameclient.objects.BasicObject;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.util.GraphicHelper;

    import flash.display.BitmapData;
    import flash.display.GraphicsBitmapFill;
    import flash.display.GraphicsPath;
    import flash.display.IGraphicsData;
    import flash.geom.Matrix;

    /** A single solid-colour square particle. */
    public class Particle extends BasicObject {

        public var size_:int;
        public var color_:uint;
        protected var bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null, null, false, false);
        protected var path_:GraphicsPath = new GraphicsPath(GraphicHelper.RECT_COMMANDS, null);
        protected var vertices_:Vector.<Number> = new Vector.<Number>();
        protected var matrix_:Matrix = new Matrix();

        public function Particle(color:uint, z:Number, size:int) {
            super();
            objectId_ = getNextFakeObjectId();
            this.setZ(z);
            this.setColor(color);
            this.setSize(size);
        }

        override public function draw(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
            var texture:BitmapData = TextureRedrawer.redrawSolidSquare(this.color_, this.size_);
            var halfW:Number = texture.width / 2;
            var halfH:Number = texture.height / 2;
            this.vertices_.length = 0;
            this.vertices_.push(
                (screenVec_[3] - halfW), (screenVec_[4] - halfH),
                (screenVec_[3] + halfW), (screenVec_[4] - halfH),
                (screenVec_[3] + halfW), (screenVec_[4] + halfH),
                (screenVec_[3] - halfW), (screenVec_[4] + halfH));
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
            square_ = square;
            return true;
        }

        public function setColor(color:uint):void {
            this.color_ = color;
        }

        public function setZ(z:Number):void {
            z_ = z;
        }

        public function setSize(size:int):void {
            this.size_ = ((size / 100) * 5);
        }

    }
}
