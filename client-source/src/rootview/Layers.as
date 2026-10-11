package rootview {
import flash.display.Sprite;
import flash.display.DisplayObjectContainer;

/** Stacking order of the root display list. Layers are listed bottom to top. */
public class Layers extends Sprite {

    public var menu:DisplayObjectContainer;
    public var tooltips:DisplayObjectContainer;
    public var promotions:DisplayObjectContainer;
    public var overlay:DisplayObjectContainer;

    public function Layers() {
        this.menu = new Sprite();
        addChild(this.menu);
        this.tooltips = new Sprite();
        addChild(this.tooltips);
        this.promotions = new Sprite();
        addChild(this.promotions);
        this.overlay = new Sprite();
        addChild(this.overlay);
    }

}
}//package rootview
