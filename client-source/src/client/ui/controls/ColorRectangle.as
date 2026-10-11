package client.ui.controls {
import flash.display.Shape;

/** A filled rectangle whose size and colour can be changed after creation. */
public class ColorRectangle extends Shape {

    private var _width:int;
    private var _height:int;
    private var _color:int;

    public function setSize(width:int, height:int):void {
        _width = width;
        _height = height;
        redraw();
    }

    public function setColor(color:int):void {
        _color = color;
        redraw();
    }

    private function redraw():void {
        graphics.clear();
        graphics.beginFill(_color);
        graphics.drawRect(0, 0, _width, _height);
        graphics.endFill();
    }

}
}
