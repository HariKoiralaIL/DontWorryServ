package spriteeditor {
import flash.display.BitmapData;
import flash.display.Sprite;

/** Base class for bitmap editing widgets; subclasses override all three methods. */
public class BitmapEditor extends Sprite {

    public function getBitmapData():BitmapData {
        return (null);
    }

    public function loadBitmapData(bitmapData:BitmapData):void {
    }

    public function clear():void {
    }

}
}
