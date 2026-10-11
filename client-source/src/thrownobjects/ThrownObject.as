package thrownobjects {
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;

import flash.display.BitmapData;
import flash.geom.Point;

// Formerly _0I_R_. A spinning sprite that travels in a straight line from start to end
// over `lifetime` ms while arcing up and down (z follows a half sine wave).
public class ThrownObject extends RotatingBitmapObject {

    private static const SPRITE_SHEET:String = "lofiObj3";
    private static const SPRITE_INDEX:int = 411;
    private static const SPRITE_SIZE:int = 80;
    private static const SPIN_SPEED:Number = 0.2;
    private static const ARC_HEIGHT:Number = 2;

    public var lifetime_:int;
    public var timeLeft_:int;
    public var start_:Point;
    public var end_:Point;
    public var dx_:Number;   // velocity in tiles per ms
    public var dy_:Number;
    public var pathX_:Number;
    public var pathY_:Number;

    public function ThrownObject(lifetime:int, start:Point, end:Point) {
        var bitmap:BitmapData = AssetLibrary._xK_(SPRITE_SHEET, SPRITE_INDEX);
        bitmap = TextureRedrawer.redraw(bitmap, SPRITE_SIZE, true, 0, 0, false);
        rotationSpeed_ = SPIN_SPEED;
        super(0, bitmap);
        this.lifetime_ = this.timeLeft_ = lifetime;
        this.start_ = start;
        this.end_ = end;
        this.dx_ = (end.x - start.x) / lifetime;
        this.dy_ = (end.y - start.y) / lifetime;
        this.pathX_ = x_ = start.x;
        this.pathY_ = y_ = start.y;
    }

    override public function update(time:int, dt:int):Boolean {
        this.timeLeft_ -= dt;
        if (this.timeLeft_ <= 0) {
            return false;
        }
        z_ = Math.sin((this.timeLeft_ / this.lifetime_) * Math.PI) * ARC_HEIGHT;
        setSizeFromZ(z_);
        this.pathX_ += this.dx_ * dt;
        this.pathY_ += this.dy_ * dt;
        moveTo(this.pathX_, this.pathY_);
        return true;
    }
}
}
