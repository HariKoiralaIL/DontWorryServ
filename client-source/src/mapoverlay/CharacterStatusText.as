package mapoverlay {
import com.company.assembleegameclient.map.GameCamera;
import com.company.assembleegameclient.objects.GameObject;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.filters.GlowFilter;
import flash.geom.Point;

/**
 * Short floating text above a game object that drifts upward
 * and disappears after its lifetime.
 */
public class CharacterStatusText extends Sprite implements IMapOverlayElement {

    /** How many pixels the text rises over its lifetime. */
    public static const RISE_HEIGHT:int = 40;

    private static const FONT:String = "Myriad Pro";
    private static const FONT_SIZE:int = 24;
    private static const OBJECT_HEIGHT_FACTOR:int = 5;
    private static const OFFSET_MARGIN:int = 20;

    public var go_:GameObject;
    public var offset:Point;
    public var color_:uint;
    public var lifetime_:int;
    public var offsetTime:int;
    private var startTime_:int = 0;

    /**
     * @param lifetime   how long the text stays visible, in milliseconds
     * @param offsetTime delay before the text appears, in milliseconds
     */
    public function CharacterStatusText(go:GameObject, text:String, color:uint, lifetime:int, offsetTime:int = 0) {
        this.go_ = go;
        this.offset = new Point(0, (((-(go.texture_.height) * (go.size_ / 100)) * OBJECT_HEIGHT_FACTOR) - OFFSET_MARGIN));
        this.color_ = color;
        this.lifetime_ = lifetime;
        this.offsetTime = offsetTime;
        var label:SimpleText = new SimpleText(FONT_SIZE, color, false, 0, 0, FONT);
        label.setBold(true);
        label.text = text;
        label.updateMetrics();
        label.filters = [new GlowFilter(0, 1, 4, 4, 2, 1)];
        label.x = (-(label.width) / 2);
        label.y = (-(label.height) / 2);
        addChild(label);
        visible = false;
    }

    public function draw(camera:GameCamera, time:int):Boolean {
        if (this.startTime_ == 0) {
            this.startTime_ = (time + this.offsetTime);
        }
        if (time < this.startTime_) {
            visible = false;
            return true;
        }
        var elapsed:int = (time - this.startTime_);
        if (elapsed > this.lifetime_ || (this.go_ != null && this.go_.map_ == null)) {
            return false;
        }
        if (this.go_ == null || !this.go_.unusedFlag_) {
            visible = false;
            return true;
        }
        visible = true;
        x = (this.go_.screenVec_[0] + this.offset.x);
        var rise:Number = ((elapsed / this.lifetime_) * RISE_HEIGHT);
        y = ((this.go_.screenVec_[1] + this.offset.y) - rise);
        return true;
    }
}
}
