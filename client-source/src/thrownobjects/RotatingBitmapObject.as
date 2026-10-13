package thrownobjects {
import com.company.assembleegameclient.map.Square;
import com.company.assembleegameclient.map.GameCamera;
import com.company.assembleegameclient.objects.BasicObject;
import com.company.util.GraphicHelper;

import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsPath;
import flash.display.IGraphicsData;
import flash.geom.Matrix;

// Formerly _0H_Q_. A map object drawn as a single bitmap quad that can spin
// around its center. Has no shadow.
//
// NOTE: _bY_ (projected position), _P_m, _7y(), _0H_B_ and the GameCamera type come from
// BasicObject / its package and keep their obfuscated names until those are refactored.
public class RotatingBitmapObject extends BasicObject {

    public var size_:int;
    protected var bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null, null, false, false);
    protected var path_:GraphicsPath = new GraphicsPath(GraphicHelper._H_2, null);
    protected var vertices_:Vector.<Number> = new Vector.<Number>();  // formerly vS_
    protected var matrix_:Matrix = new Matrix();                      // formerly _01i
    protected var rotationSpeed_:Number = 0;                          // formerly _A_o (radians per update)
    private var bitmap_:BitmapData;                                   // formerly _01Y_
    private var rotation_:Number = 0;                                 // formerly _in_

    public function RotatingBitmapObject(z:Number, bitmap:BitmapData) {
        super();
        hasShadow_ = false;
        objectId_ = getNextFakeObjectId();
        this.bitmap_ = bitmap;
        z_ = z;
    }

    override public function drawShadow(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
    }

    override public function draw(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
        var w:int = this.bitmap_.width;
        var h:int = this.bitmap_.height;
        var left:Number = screenVec_[3] - w / 2;
        var right:Number = screenVec_[3] + w / 2;
        var top:Number = screenVec_[4] - h / 2;
        var bottom:Number = screenVec_[4] + h / 2;

        this.vertices_.length = 0;
        this.vertices_.push(left, top, right, top, right, bottom, left, bottom);
        this.path_.data = this.vertices_;
        this.bitmapFill_.bitmapData = this.bitmap_;

        this.matrix_.identity();
        if (this.rotationSpeed_) {
            this.rotation_ += this.rotationSpeed_;
            this.matrix_.translate(-w / 2, -h / 2);
            this.matrix_.rotate(this.rotation_);
            this.matrix_.translate(w / 2, h / 2);
        }
        this.matrix_.translate(left, top);
        this.bitmapFill_.matrix = this.matrix_;

        // The original pushed bitmapFill_ twice in a row; the second push simply
        // replaced the first, so one is enough.
        graphicsData.push(this.bitmapFill_);
        graphicsData.push(this.path_);
        graphicsData.push(GraphicHelper.END_FILL);
    }

    // Moves to (newX, newY) if a map square exists there. Returns false otherwise.
    public function moveTo(newX:Number, newY:Number):Boolean {
        var square:Square = map_.getSquare(newX, newY);
        if (!square) {
            return false;
        }
        x_ = newX;
        y_ = newY;
        square_ = square;
        return true;
    }

    // formerly _H_9
    public function setSizeFromZ(z:int):void {
        this.size_ = (z / 100) * 5;
    }
}
}
