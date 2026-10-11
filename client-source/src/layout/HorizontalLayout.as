package layout {
import flash.display.DisplayObject;

public class HorizontalLayout implements ILayout {

    public var padding:int;

    public function HorizontalLayout(padding:int) {
        this.padding = padding;
    }

    public function layout(items:Vector.<DisplayObject>):void {
        var item:DisplayObject;
        var offset:int = 0;
        var count:int = items.length;
        for (var i:int = 0; i < count; i++) {
            item = items[i];
            item.x = offset;
            offset += item.width + padding;
        }
    }

}
}